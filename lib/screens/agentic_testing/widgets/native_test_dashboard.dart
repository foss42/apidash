import 'package:better_networking/consts.dart';
import 'package:better_networking/models/http_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/models/models.dart';

import '../../../providers/agentic_testing_provider.dart';
import '../../../providers/agentic_providers.dart';
import '../../../providers/providers.dart';
import '../../history/history_details.dart';

class NativeTestDashboard extends ConsumerWidget {
  final String targetUrl;

  const NativeTestDashboard({super.key, required this.targetUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(agenticDashboardProvider);
    final colorScheme = Theme.of(context).colorScheme;

    final data = state.dashboardData ?? {};
    final List<dynamic> tests = data['tests'] ?? [];
    final results = state.testResults;

    final int passedCount = results.where((r) => r['passed'] == true).length;
    final int failedCount = results.where((r) => r['passed'] == false).length;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "AGENTIC TESTING DASHBOARD",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
              ),
              if (tests.isNotEmpty)
                ElevatedButton(
                  onPressed: state.isExecuting ? null : () {
                    ref.read(agenticDashboardProvider.notifier).runTests(targetUrl);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  child: Text(state.isExecuting ? "Executing..." : "Run Tests"),
                )
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: colorScheme.outlineVariant),
          const SizedBox(height: 16),

          // STATS ROW: Neutral backgrounds, text-only color accents
          Row(
            children: [
              _statBox(context, "Total Tests", tests.length.toString(), colorScheme.surfaceContainer),
              const SizedBox(width: 10),
              _statBox(context, "Passed", state.isComplete ? passedCount.toString() : "-",
                  colorScheme.surfaceContainer, // Neutral background
                  textColor: passedCount > 0 ? Colors.green : colorScheme.onSurface),
              const SizedBox(width: 10),
              _statBox(context, "Failed", state.isComplete ? failedCount.toString() : "-",
                  colorScheme.surfaceContainer, // Neutral background
                  textColor: failedCount > 0 ? colorScheme.error : colorScheme.onSurface),
            ],
          ),
          const SizedBox(height: 15),

          if (data['explanation'] != null && data['explanation'].toString().isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer, // Clean neutral background
                border: Border(left: BorderSide(color: colorScheme.secondary, width: 4)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text("💡 AI Strategy: ${data['explanation']}", style: TextStyle(fontSize: 13, color: colorScheme.onSurface)),
            ),

          const SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              itemCount: tests.length,
              itemBuilder: (context, index) {
                final test = tests[index];
                final result = results.length > index ? results[index] : null;

                Color accentColor = colorScheme.outline;
                Color cardBg = colorScheme.surfaceContainer;

                if (result != null) {
                  accentColor = result['passed'] ? Colors.green : colorScheme.error;
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: accentColor, // The Left Border Color
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4), // Expose 4px of the border
                    child: Material(
                      color: cardBg, // Solid neutral background
                      borderRadius: const BorderRadius.horizontal(right: Radius.circular(6)),
                      child: InkWell(
                        hoverColor: colorScheme.onSurface.withOpacity(0.05),
                        onTap: result == null ? null : () => _showNativeDialog(context, ref, result['request_id']),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: colorScheme.outlineVariant),
                            borderRadius: const BorderRadius.horizontal(right: Radius.circular(6)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(test['title'] ?? 'AI Test', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: colorScheme.onSurface)),
                              const SizedBox(height: 4),
                              Text("Expects: ${test['expected']}", style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12)),
                              Text("Tested: ${test['method']} ${test['url']}", style: TextStyle(color: colorScheme.primary, fontSize: 11)),
                              if (result != null) ...[
                                const SizedBox(height: 6),
                                Text(
                                  "${result['passed'] ? '✓ Passed' : '✗ Failed'}: ${result['message']}",
                                  style: TextStyle(
                                    color: accentColor, // Colored text for result
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                )
                              ]
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _statBox(BuildContext context, String label, String value, Color bgColor, {Color? textColor}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
            Text(label, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }

  void _showNativeDialog(BuildContext context, WidgetRef ref, String requestId) {
    final req = ref.read(agenticCollectionStateNotifierProvider)[requestId];
    if (req == null) return;

    final historyModel = HistoryRequestModel(
      historyId: req.id,
      metaData: HistoryMetaModel(
        historyId: req.id,
        requestId: req.id,
        apiType: req.apiType,
        name: req.name.split('::').last,
        url: req.httpRequestModel?.url ?? '',
        method: req.httpRequestModel?.method ?? HTTPVerb.get,
        responseStatus: req.responseStatus ?? -1,
        timeStamp: DateTime.now(),
      ),
      httpRequestModel: req.httpRequestModel,
      httpResponseModel: req.httpResponseModel ?? const HttpResponseModel(),
    );

    final width = MediaQuery.sizeOf(context).width * 0.85;
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
          width: width < 900.0 ? 900.0 : width,
          height: MediaQuery.sizeOf(context).height * 0.85,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ),
              Expanded(
                child: ProviderScope(
                  overrides: [selectedHistoryRequestModelProvider.overrideWith((ref) => historyModel)],
                  child: const HistoryDetails(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}