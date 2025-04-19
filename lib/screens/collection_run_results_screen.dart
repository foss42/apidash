import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/collection_run_results_provider.dart';

class CollectionRunResultsScreen extends ConsumerWidget {
  const CollectionRunResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(collectionRunResultsProvider);
    
    if (results == null) {
      return const Center(child: Text('No run results available'));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${results.collectionName} - Run results'),
        actions: [
          TextButton.icon(
            onPressed: () {
              // will implement the export result action in future
            },
            icon: const Icon(Icons.download),
            label: const Text('Export Results'),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: () {
              // run again will trigger the collection run again
              //will be implemented

            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Run Again'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Run Summary
              Row(
                children: [
                  const Icon(Icons.access_time),
                  const SizedBox(width: 8),
                  Text(
                    'Ran ${DateFormat('MMM d, yyyy at h:mm:ss a').format(results.startTime)}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Stats Grid
              Row(
                children: [
                  _StatCard(
                    label: 'Source',
                    value: 'Runner',
                    icon: Icons.play_circle_outline,
                  ),
                  const SizedBox(width: 16),
                  _StatCard(
                    label: 'Environment',
                    value: results.environment,
                    icon: Icons.settings_outlined,
                  ),
                  const SizedBox(width: 16),
                  _StatCard(
                    label: 'Iterations',
                    value: results.iterations.toString(),
                    icon: Icons.repeat,
                  ),
                  const SizedBox(width: 16),
                  _StatCard(
                    label: 'Duration',
                    value: '${(results.totalDurationMs / 1000).toStringAsFixed(3)}s',
                    icon: Icons.timer_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Test Results
              Row(
                children: [
                  _TestResultCard(
                    label: 'All Tests',
                    count: results.results.length,
                    color: Colors.grey.shade200,
                  ),
                  const SizedBox(width: 16),
                  _TestResultCard(
                    label: 'Passed',
                    count: results.passedTests,
                    color: Colors.green.shade100,
                  ),
                  const SizedBox(width: 16),
                  _TestResultCard(
                    label: 'Failed',
                    count: results.failedTests,
                    color: Colors.red.shade100,
                  ),
                  const SizedBox(width: 16),
                  _TestResultCard(
                    label: 'Skipped',
                    count: results.skippedTests,
                    color: Colors.orange.shade100,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Results Table
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Iteration 1',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Table(
                        columnWidths: const {
                          0: FlexColumnWidth(3), // Request Name
                          1: FlexColumnWidth(1), // Method
                          2: FlexColumnWidth(1), // Status
                          3: FlexColumnWidth(1), // Time
                          4: FlexColumnWidth(1), // Size
                        },
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                            ),
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Request Name'),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Method'),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Status'),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Time'),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Size'),
                              ),
                            ],
                          ),
                          ...results.results.map((result) => TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(result.requestName),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(result.method),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  result.statusCode?.toString() ?? 'Error',
                                  style: TextStyle(
                                    color: result.statusCode != null && result.statusCode! >= 200 && result.statusCode! < 300
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${result.responseTimeMs}ms'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${(result.responseSize / 1024).toStringAsFixed(2)} KB'),
                              ),
                            ],
                          )).toList(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _TestResultCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _TestResultCard({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
} 