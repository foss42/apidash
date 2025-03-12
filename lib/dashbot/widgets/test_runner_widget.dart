import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'content_renderer.dart';

class TestRunnerWidget extends ConsumerStatefulWidget {
  final String testCases;

  const TestRunnerWidget({Key? key, required this.testCases}) : super(key: key);

  @override
  ConsumerState<TestRunnerWidget> createState() => _TestRunnerWidgetState();
}

class _TestRunnerWidgetState extends ConsumerState<TestRunnerWidget> {
  List<Map<String, dynamic>> _parsedTests = [];
  Map<int, Map<String, dynamic>> _results = {};
  bool _isRunning = false;
  int _currentTestIndex = -1;

  @override
  void initState() {
    super.initState();
    _parseTestCases();
  }

  void _parseTestCases() {
    // Basic parsing of cURL commands from the text
    final curlRegex = RegExp(r'```(.*?)curl\s+(.*?)```', dotAll: true);
    final descriptionRegex = RegExp(r'###\s*(.*?)\n', dotAll: true);

    final curlMatches = curlRegex.allMatches(widget.testCases);
    final descMatches = descriptionRegex.allMatches(widget.testCases);

    List<Map<String, dynamic>> tests = [];
    int index = 0;

    for (var match in curlMatches) {
      String? description = "Test case ${index + 1}";
      if (index < descMatches.length) {
        description = descMatches.elementAt(index).group(1)?.trim();
      }

      final curlCommand = match.group(2)?.trim() ?? "";

      tests.add({
        'description': description,
        'command': curlCommand,
        'index': index,
      });

      index++;
    }

    setState(() {
      _parsedTests = tests;
    });
  }

  Future<void> _runTest(int index) async {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
      _currentTestIndex = index;
    });

    final test = _parsedTests[index];
    final command = test['command'];

    try {
      // Parse curl command to make HTTP request
      // This is a simplified version - a real implementation would need to handle all curl options
      final urlMatch = RegExp(r'"([^"]*)"').firstMatch(command);
      String url = urlMatch?.group(1) ?? "";

      if (url.isEmpty) {
        final urlMatch2 = RegExp(r"'([^']*)'").firstMatch(command);
        url = urlMatch2?.group(1) ?? "";
      }

      if (url.isEmpty) {
        throw Exception("Could not parse URL from curl command");
      }

      // Determine HTTP method (default to GET)
      String method = "GET";
      if (command.contains("-X POST") || command.contains("--request POST")) {
        method = "POST";
      } else if (command.contains("-X PUT") || command.contains("--request PUT")) {
        method = "PUT";
      } // Add other methods as needed

      // Make the actual request
      http.Response response;
      if (method == "GET") {
        response = await http.get(Uri.parse(url));
      } else if (method == "POST") {
        // Extract body if present
        final bodyMatch = RegExp(r'-d\s+"([^"]*)"').firstMatch(command);
        final body = bodyMatch?.group(1) ?? "";
        response = await http.post(Uri.parse(url), body: body);
      } else {
        throw Exception("Unsupported HTTP method: $method");
      }

      setState(() {
        _results[index] = {
          'status': response.statusCode,
          'body': response.body,
          'headers': response.headers,
          'isSuccess': response.statusCode >= 200 && response.statusCode < 300,
        };
      });
    } catch (e) {
      setState(() {
        _results[index] = {
          'error': e.toString(),
          'isSuccess': false,
        };
      });
    } finally {
      setState(() {
        _isRunning = false;
        _currentTestIndex = -1;
      });
    }
  }

  Future<void> _runAllTests() async {
    for (int i = 0; i < _parsedTests.length; i++) {
      await _runTest(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          Expanded(
            child: _parsedTests.isEmpty
                ? Center(child: Text("No test cases found"))
                : _buildTestList(),
          ),
          const SizedBox(height: 16),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'API Test Runner',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.help_outline),
          tooltip: 'How to use',
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('API Test Runner'),
                content: const Text(
                  'This tool runs the API tests generated from your request.\n\n'
                      '• Click "Run All" to execute all tests\n'
                      '• Click individual "Run" buttons to execute specific tests\n'
                      '• Click "Copy" to copy a curl command to clipboard',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTestList() {
    return ListView.builder(
      itemCount: _parsedTests.length,
      itemBuilder: (context, index) {
        final test = _parsedTests[index];
        final result = _results[index];
        final bool hasResult = result != null;
        final bool isSuccess = hasResult ? result['isSuccess'] ?? false : false;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            title: Text(
              test['description'] ?? "Test case ${index + 1}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: hasResult
                    ? (isSuccess
                    ? Colors.green
                    : Colors.red)
                    : null,
              ),
            ),
            subtitle: Text('Test ${index + 1} of ${_parsedTests.length}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copy command',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: test['command']));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Command copied to clipboard')),
                    );
                  },
                ),
                if (_currentTestIndex == index && _isRunning)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  IconButton(
                    icon: Icon(hasResult
                        ? (isSuccess ? Icons.check_circle : Icons.error)
                        : Icons.play_arrow),
                    color: hasResult
                        ? (isSuccess ? Colors.green : Colors.red)
                        : null,
                    tooltip: hasResult ? 'Run again' : 'Run test',
                    onPressed: () => _runTest(index),
                  ),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Command:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(top: 4, bottom: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      width: double.infinity,
                      child: SelectableText(
                        test['command'],
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
                    if (hasResult) ...[
                      const Divider(),
                      Text(
                        'Result:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSuccess ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (result.containsKey('error'))
                        Text(
                          'Error: ${result['error']}',
                          style: const TextStyle(color: Colors.red),
                        )
                      else ...[
                        Text('Status: ${result['status']}'),
                        const SizedBox(height: 8),
                        const Text(
                          'Response:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          width: double.infinity,
                          child: renderContent(
                              context,
                              _tryFormatJson(result['body'])
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          onPressed: _isRunning ? null : _runAllTests,
          icon: const Icon(Icons.play_circle_outline),
          label: const Text("Run All Tests"),
        ),
      ],
    );
  }

  String _tryFormatJson(dynamic input) {
    if (input == null) return "null";

    if (input is! String) return input.toString();

    try {
      final decoded = json.decode(input);
      return JsonEncoder.withIndent('  ').convert(decoded);
    } catch (e) {
      return input;
    }
  }
}
