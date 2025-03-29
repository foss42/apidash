import 'package:apidash/providers/providers.dart';
import 'package:apidash/services/stress_test/stress_test_service.dart';
import 'package:apidash/models/stress_test/stress_test_config.dart';
import 'package:apidash/models/stress_test/stress_test_summary.dart';
import 'package:apidash/models/stress_test/api_request_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestStressTestPane extends ConsumerStatefulWidget {
  const RequestStressTestPane({super.key});

  @override
  ConsumerState<RequestStressTestPane> createState() => _RequestStressTestPaneState();
}

class _RequestStressTestPaneState extends ConsumerState<RequestStressTestPane> {
  final _concurrentRequestsController = TextEditingController(text: '10');
  final _timeoutController = TextEditingController(text: '30');
  bool _isRunning = false;
  bool _useIsolates = true;
  StressTestSummary? _summary;

  @override
  void dispose() {
    _concurrentRequestsController.dispose();
    _timeoutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDarkMode ? Colors.tealAccent : Colors.teal;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Parallel API Testing',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Test your API endpoint with multiple concurrent requests to evaluate performance under load.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: NumberTextField(
                    controller: _concurrentRequestsController,
                    labelText: 'Number of Concurrent Requests',
                    helperText: 'How many requests to send in parallel',
                    min: 1,
                    max: 500,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: NumberTextField(
                    controller: _timeoutController,
                    labelText: 'Timeout (seconds)',
                    helperText: 'Maximum time to wait for each request',
                    min: 1,
                    max: 300,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Use Isolates'),
              subtitle: const Text('Improves performance for high request volumes but uses more memory'),
              value: _useIsolates,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: _isRunning ? null : (value) {
                setState(() {
                  _useIsolates = value ?? true;
                });
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 200,
              child: ElevatedButton.icon(
                onPressed: _isRunning ? null : _runStressTest,
                icon: _isRunning 
                  ? const SizedBox(
                      width: 16, 
                      height: 16, 
                      child: CircularProgressIndicator(strokeWidth: 2)
                    )
                  : Icon(Icons.bolt, color: accentColor),
                label: Text(_isRunning ? 'Running Test...' : 'Run Stress Test'),
              ),
            ),
            if (_summary != null) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                'Test Results',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              _buildResultsCard(context),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _runStressTest() async {
    final requestModel = ref.read(selectedRequestModelProvider);
    if (requestModel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No request selected')),
      );
      return;
    }

    final httpRequest = requestModel.httpRequestModel;
    if (httpRequest == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid request configuration')),
      );
      return;
    }

    setState(() {
      _isRunning = true;
      _summary = null;
    });

    try {
      final collectionNotifier = ref.read(collectionStateNotifierProvider.notifier);
      
      final substitutedRequest = collectionNotifier.getSubstitutedHttpRequestModel(httpRequest);
      
      final headers = <String, String>{};
      if (substitutedRequest.headers != null) {
        for (var header in substitutedRequest.headers!) {
          if (header.value != null) {
            headers[header.name] = header.value ?? '';
          }
        }
      }

      String fullUrl = substitutedRequest.url;
      
      final concurrentRequests = int.tryParse(_concurrentRequestsController.text) ?? 10;
      final timeoutSeconds = int.tryParse(_timeoutController.text) ?? 30;

      final config = StressTestConfig(
        url: fullUrl,
        method: substitutedRequest.method.toString().split('.').last,
        headers: headers,
        body: substitutedRequest.body,
        concurrentRequests: concurrentRequests,
        timeout: Duration(seconds: timeoutSeconds),
        useIsolates: _useIsolates,
      );

      final result = await StressTestService.runTest(config);
      
      if (mounted) {
        setState(() {
          _summary = result;
          _isRunning = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        setState(() => _isRunning = false);
      }
    }
  }

  Widget _buildResultsCard(BuildContext context) {
    final summary = _summary;
    if (summary == null) return const SizedBox.shrink();

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkMode 
        ? Colors.grey[850] 
        : Colors.grey[50];

    return Card(
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildResultRow('Total Requests', '${summary.results.length}'),
            _buildResultRow('Total Duration', '${summary.totalDuration.inMilliseconds}ms'),
            _buildResultRow('Avg Response Time', '${summary.avgResponseTime.toStringAsFixed(2)}ms'),
            _buildResultRow(
              'Success Rate', 
              '${(summary.successCount / summary.results.length * 100).toStringAsFixed(1)}% (${summary.successCount}/${summary.results.length})'
            ),
            
            const SizedBox(height: 16),
            const Text('Response Status Breakdown:'),
            const SizedBox(height: 8),
            
            ..._groupResponsesByStatus(summary.results).entries.map((entry) {
              final statusText = 'Status ${entry.key}';
              final countText = '${entry.value} (${(entry.value / summary.results.length * 100).toStringAsFixed(1)}%)';
              
              return _buildResultRow(statusText, countText);
            }),
            
            const SizedBox(height: 16),
            ExpansionTile(
              title: const Text('Detailed Results'),
              backgroundColor: Colors.transparent,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 250),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: summary.results.length,
                    itemBuilder: (context, index) {
                      final result = summary.results[index];
                      final isSuccess = result.statusCode >= 200 && result.statusCode < 300;
                      
                      return ListTile(
                        dense: true,
                        title: Row(
                          children: [
                            Text(
                              '#${index + 1}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isSuccess 
                                    ? Colors.green.withValues(alpha: 0.2)
                                    : Colors.red.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: isSuccess ? Colors.green : Colors.red,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                'Status: ${result.statusCode}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isSuccess ? Colors.green : Colors.red,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('${result.duration.inMilliseconds}ms')
                          ],
                        ),
                        subtitle: result.error != null
                            ? Text(
                                'Error: ${result.error}',
                                style: const TextStyle(color: Colors.red, fontSize: 12),
                              )
                            : null,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Map<int, int> _groupResponsesByStatus(List<ApiRequestResult> results) {
    final statusMap = <int, int>{};
    
    for (final result in results) {
      statusMap.update(
        result.statusCode, 
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }
    
    return statusMap;
  }
}

class NumberTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? helperText;
  final int min;
  final int max;

  const NumberTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.helperText,
    required this.min, 
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        helperText: helperText,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        // To resolve range error
        final parsedValue = int.tryParse(value);
        if (parsedValue != null) {
          if (parsedValue < min) {
            controller.text = min.toString();
          } else if (parsedValue > max) {
            controller.text = max.toString();
          }
        } else if (value.isNotEmpty) {
          controller.text = min.toString();
        }
      },
    );
  }
}
