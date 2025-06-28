import 'dart:convert';
import 'package:apidash_core/apidash_core.dart' as http;
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'content_renderer.dart';

class TestRunnerWidget extends ConsumerStatefulWidget {
  final String testCases;

  const TestRunnerWidget({
    super.key,
    required this.testCases,
  });

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
    final curlRegex = RegExp(r'```bash\ncurl\s+(.*?)\n```', dotAll: true);
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

      final curlCommand = match.group(1)?.trim() ?? "";

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
      final urlMatch = RegExp(r'"([^"]*)"').firstMatch(command) ??
          RegExp(r"'([^']*)'").firstMatch(command);
      final url = urlMatch?.group(1) ?? "";
      if (url.isEmpty) throw Exception("Could not parse URL from curl command");

      String method = "GET";
      if (command.contains("-X POST") || command.contains("--request POST")) {
        method = "POST";
      } else if (command.contains("-X PUT") ||
          command.contains("--request PUT")) {
        method = "PUT";
      }

      http.Response response;
      if (method == "GET") {
        response = await http.get(Uri.parse(url));
      } else if (method == "POST") {
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
      if (!mounted) return;
      await _runTest(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Test Runner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'How to use',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('API Test Runner'),
                  content: const Text(
                    'Run generated API tests:\n\n'
                    '• "Run All" executes all tests\n'
                    '• "Run" executes a single test\n'
                    '• "Copy" copies the curl command',
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _parsedTests.isEmpty
                  ? const Center(child: Text("No test cases found"))
                  : _buildTestList(),
            ),
            const SizedBox(height: 16),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildTestList() {
    return ListView.builder(
      itemCount: _parsedTests.length,
      itemBuilder: (context, index) {
        final test = _parsedTests[index];
        final result = _results[index];
        final bool hasResult = result != null;
        final bool isSuccess = hasResult && (result['isSuccess'] ?? false);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ExpansionTile(
            title: Text(
              test['description'] ?? "Test case ${index + 1}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color:
                    hasResult ? (isSuccess ? Colors.green : Colors.red) : null,
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
                      const SnackBar(content: Text('Command copied')),
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
                        color:
                            Theme.of(context).colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      width: double.infinity,
                      child: SelectableText(
                        test['command'],
                        style: kCodeStyle,
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
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerLow,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          width: double.infinity,
                          child: renderContent(
                              context, _tryFormatJson(result['body'])),
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
    } catch (_) {
      return input;
    }
  }
}
