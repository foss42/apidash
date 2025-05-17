import 'package:flutter/material.dart';
import '../models/performance_test_result.dart';
import '../services/performance_test_service.dart';
import '../widgets/performance_test_chart.dart';

class PerformanceTestScreen extends StatefulWidget {
  final String url;
  final String method;
  final Map<String, String> headers;
  final String? body;

  const PerformanceTestScreen({
    Key? key,
    required this.url,
    required this.method,
    required this.headers,
    this.body,
  }) : super(key: key);

  @override
  State<PerformanceTestScreen> createState() => _PerformanceTestScreenState();
}

class _PerformanceTestScreenState extends State<PerformanceTestScreen> {
  final _performanceTestService = PerformanceTestService();
  List<PerformanceTestResult> _results = [];
  bool _isRunning = false;

  final _virtualUsersController = TextEditingController(text: '50');
  final _durationController = TextEditingController(text: '5');
  final _rampUpDurationController = TextEditingController(text: '2');
  bool _rampUp = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('URL: ${widget.url}'),
                    Text('Method: ${widget.method}'),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _virtualUsersController,
                            decoration: const InputDecoration(
                              labelText: 'Virtual Users',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _durationController,
                            decoration: const InputDecoration(
                              labelText: 'Duration (seconds)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _rampUp,
                          onChanged: (value) {
                            setState(() {
                              _rampUp = value ?? false;
                            });
                          },
                        ),
                        const Text('Ramp up virtual users'),
                        const SizedBox(width: 16),
                        if (_rampUp)
                          Expanded(
                            child: TextField(
                              controller: _rampUpDurationController,
                              decoration: const InputDecoration(
                                labelText: 'Ramp-up Duration (seconds)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isRunning ? null : _startTest,
                      child: Text(_isRunning ? 'Running...' : 'Start Test'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_results.isNotEmpty) ...[
              const Text(
                'Test Results',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: PerformanceTestChart(results: _results),
              ),
              const SizedBox(height: 16),
              _buildSummary(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    if (_results.isEmpty) return const SizedBox();

    final lastResult = _results.last;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Requests: ${lastResult.totalRequests}'),
            Text('Average Requests/s: ${lastResult.requestsPerSecond.toStringAsFixed(2)}'),
            Text('Average Response Time: ${lastResult.avgResponseTime.toStringAsFixed(2)} ms'),
            Text('Min Response Time: ${lastResult.minResponseTime.toStringAsFixed(2)} ms'),
            Text('Max Response Time: ${lastResult.maxResponseTime.toStringAsFixed(2)} ms'),
            Text('Error Rate: ${lastResult.errorRate.toStringAsFixed(2)}%'),
          ],
        ),
      ),
    );
  }

  Future<void> _startTest() async {
    setState(() {
      _isRunning = true;
      _results = [];
    });

    final results = await _performanceTestService.runLoadTest(
      url: widget.url,
      method: widget.method,
      headers: widget.headers,
      body: widget.body,
      virtualUsers: int.parse(_virtualUsersController.text),
      durationSeconds: int.parse(_durationController.text),
      rampUp: _rampUp,
      rampUpDurationSeconds: _rampUp ? int.parse(_rampUpDurationController.text) : 0,
    );

    setState(() {
      _results = results;
      _isRunning = false;
    });
  }

  @override
  void dispose() {
    _virtualUsersController.dispose();
    _durationController.dispose();
    _rampUpDurationController.dispose();
    super.dispose();
  }
} 