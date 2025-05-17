import 'package:apidash_core/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/models/collection_model.dart';
import 'package:apidash/providers/collection_runner_provider.dart';
import 'package:postman/postman.dart';
import 'package:apidash/providers/providers.dart';

import '../providers/collection_run_results_provider.dart';
import '../providers/settings_providers.dart';
import '../screens/collection_run_results_screen.dart';

// Create a service provider for running collections
final collectionRunServiceProvider = Provider((ref) => CollectionRunService(ref));
final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
// Service class for running collections
class CollectionRunService {
  final Ref ref;

  CollectionRunService(this.ref);

  Future<void> runCollection({
    required Collection collection,
    required CollectionRunConfig config,
    required BuildContext context,
  }) async {
    // Get the active environment
    final activeEnvId = ref.read(activeEnvironmentIdStateProvider);
    final envMap = ref.read(availableEnvironmentVariablesStateProvider);
    final activeEnv = activeEnvId != null ? envMap[activeEnvId] : null;

    // Get all needed providers and state
    final collectionRunResultsNotifier = ref.read(collectionRunResultsProvider.notifier);
    final collectionStateNotifierRef = ref.read(collectionStateNotifierProvider.notifier);
    final defaultUriScheme = ref.read(settingsProvider).defaultUriScheme;
    final isSSLDisabled = ref.read(settingsProvider).isSSLDisabled;
    final collectionState = ref.read(collectionStateNotifierProvider);

    // Start the run
    collectionRunResultsNotifier.startRun(
      collectionName: collection.name,
      environment:  'none',
      iterations: config.iterations,
    );

    // Execute requests
    for (var i = 0; i < config.iterations; i++) {
      for (var requestId in collection.requests) {
        // Skip if request is not selected
        if (!config.selectedRequestIds.contains(requestId)) continue;

        // Get the request model
        final request = collectionState?[requestId];
        if (request == null) continue;

        try {
          // Get the substituted request model
          final substitutedRequest = collectionStateNotifierRef
              .getSubstitutedHttpRequestModel(request.httpRequestModel!);
          print(substitutedRequest);

    
          // Send the request
          final responseRec = await sendHttpRequest(
            requestId,
            request.apiType,
            substitutedRequest,
            defaultUriScheme: defaultUriScheme,
            noSSL: isSSLDisabled,
          );
          print(responseRec);

          // Add result
          collectionRunResultsNotifier.addResult(
            RunResult(
              requestId: requestId,
              requestName: request.name,
              url: substitutedRequest.url,
              method: substitutedRequest.method.toString(),
              statusCode: responseRec.$1?.statusCode,
              responseTimeMs: responseRec.$2?.inMilliseconds ?? 0,
              responseSize: responseRec.$1?.bodyBytes.length ?? 0,
              error: responseRec.$3,
            ),
          );

          // print(RunResult);

          // Add delay between requests if specified
          if (config.delayMs > 0) {
            await Future.delayed(Duration(milliseconds: config.delayMs));
          }
        } catch (e) {
          print('Error running request: $e');
          collectionRunResultsNotifier.addResult(
            RunResult(
              requestId: requestId,
              requestName: request.name,
              url: request.httpRequestModel?.url ?? '',
              method: request.httpRequestModel?.method.toString() ?? 'GET',
              responseTimeMs: 0,
              responseSize: 0,
              error: e.toString(),
            ),
          );
        }
      }
    }

    // Mark run as complete
    collectionRunResultsNotifier.finishRun();
    print('About to navigate to results screen...');
    // Navigate to results screen if context is still valid
    // if (context.mounted) {
    //   print('navigatipon operated');
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const CollectionRunResultsScreen(),
        ),
      );
      // print('navigation ');
    // }
  }
}

class CollectionRunnerDialog extends ConsumerWidget {
  final Collection collection;

  const CollectionRunnerDialog({
    super.key,
    required this.collection,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(collectionRunConfigProvider);
    final configNotifier = ref.read(collectionRunConfigProvider.notifier);
    final collectionState = ref.watch(collectionStateNotifierProvider);

    final iterationsController = TextEditingController(
      text: config.iterations.toString(),
    );
    final delayController = TextEditingController(
      text: config.delayMs.toString(),
    );
    final virtualUsersController = TextEditingController(
      text: config.virtualUsers.toString(),
    );
    final durationController = TextEditingController(
      text: config.durationSeconds.toString(),
    );
    final rampUpDurationController = TextEditingController(
      text: config.rampUpDurationSeconds.toString(),
    );

    return AlertDialog(
      title: Row(
        children: [
          const Text('Run Collection'),
          const Spacer(),
          TextButton(
            onPressed: () {
              configNotifier.setMode(RunMode.functional);
              configNotifier.setIterations(1);
              configNotifier.setDelay(0);
              configNotifier.setVirtualUsers(50);
              configNotifier.setDurationSeconds(5);
              configNotifier.setRampUp(true);
              configNotifier.setRampUpDurationSeconds(2);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
      content: SizedBox(
        width: 800,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side - Run Configuration
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Choose how to run your collection',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Run Mode Options
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<RunMode>(
                          title: const Text('Functional'),
                          subtitle: const Text('Run collection with iterations'),
                          value: RunMode.functional,
                          groupValue: config.mode,
                          onChanged: (value) {
                            if (value != null) {
                              configNotifier.setMode(value);
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<RunMode>(
                          title: const Text('Performance'),
                          subtitle: const Text('Load test with virtual users'),
                          value: RunMode.performance,
                          groupValue: config.mode,
                          onChanged: (value) {
                            if (value != null) {
                              configNotifier.setMode(value);
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Run Configuration
                  const Text(
                    'Run configuration',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (config.mode == RunMode.functional) ...[
                    // Iterations
                    Row(
                      children: [
                        const Text('Iterations'),
                        const SizedBox(width: 8),
                        Tooltip(
                          message: 'Number of times to run the collection',
                          child: const Icon(Icons.info_outline, size: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        suffixText: 'times',
                      ),
                      controller: iterationsController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final iterations = int.tryParse(value);
                        if (iterations != null && iterations > 0) {
                          configNotifier.setIterations(iterations);
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    // Delay
                    Row(
                      children: [
                        const Text('Delay'),
                        const SizedBox(width: 8),
                        Tooltip(
                          message: 'Time delay between iterations',
                          child: const Icon(Icons.info_outline, size: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        suffixText: 'ms',
                      ),
                      controller: delayController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final delay = int.tryParse(value);
                        if (delay != null && delay >= 0) {
                          configNotifier.setDelay(delay);
                        }
                      },
                    ),
                  ] else ...[
                    // Virtual Users
                    Row(
                      children: [
                        const Text('Virtual Users'),
                        const SizedBox(width: 8),
                        Tooltip(
                          message: 'Number of concurrent users',
                          child: const Icon(Icons.info_outline, size: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        suffixText: 'users',
                      ),
                      controller: virtualUsersController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final users = int.tryParse(value);
                        if (users != null && users > 0) {
                          configNotifier.setVirtualUsers(users);
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    // Test Duration
                    Row(
                      children: [
                        const Text('Test Duration'),
                        const SizedBox(width: 8),
                        Tooltip(
                          message: 'Duration of the performance test',
                          child: const Icon(Icons.info_outline, size: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        suffixText: 'seconds',
                      ),
                      controller: durationController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final duration = int.tryParse(value);
                        if (duration != null && duration > 0) {
                          configNotifier.setDurationSeconds(duration);
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    // Ramp Up
                    Row(
                      children: [
                        Checkbox(
                          value: config.rampUp,
                          onChanged: (value) {
                            configNotifier.setRampUp(value ?? false);
                          },
                        ),
                        const Text('Ramp up virtual users'),
                        const SizedBox(width: 8),
                        Tooltip(
                          message: 'Gradually increase the number of users',
                          child: const Icon(Icons.info_outline, size: 16),
                        ),
                      ],
                    ),

                    if (config.rampUp) ...[
                      const SizedBox(height: 8),
                      TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          suffixText: 'seconds',
                          labelText: 'Ramp-up Duration',
                        ),
                        controller: rampUpDurationController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final duration = int.tryParse(value);
                          if (duration != null && duration > 0) {
                            configNotifier.setRampUpDurationSeconds(duration);
                          }
                        },
                      ),
                    ],
                  ],
                ],
              ),
            ),

            const SizedBox(width: 24),

            // Right side - Request Sequence
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Run order',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          final requestIds = collection.requests;
                          configNotifier.selectAllRequests(requestIds);
                        },
                        child: const Text('Select All'),
                      ),
                      TextButton(
                        onPressed: () {
                          configNotifier.deselectAllRequests();
                        },
                        child: const Text('Deselect All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    height: 300,
                    child: ListView.builder(
                      itemCount: collection.requests.length,
                      itemBuilder: (context, index) {
                        final requestId = collection.requests[index];
                        final request = collectionState?[requestId];

                        if (request == null) return const SizedBox();

                        return CheckboxListTile(
                          title: Text(request.name),
                          subtitle: Text(
                            '${request.httpRequestModel?.method.toString().toUpperCase()} ${request.httpRequestModel?.url}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          value: config.selectedRequestIds.contains(requestId),
                          onChanged: (value) {
                            configNotifier.toggleRequest(requestId);
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          dense: true,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () async {
            final collectionRunService = ref.read(collectionRunServiceProvider);
            // Navigator.of(context).pop();
            await collectionRunService.runCollection(
              collection: collection,
              config: config,
              context: context,
            );
          },
          child: const Text('Run'),
        ),
      ],
    );
  }
}