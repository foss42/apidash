import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dashboard_models.dart';
import '../providers/dashboard_providers.dart';
import 'dashboard_common.dart';

class ScriptCoverageSection extends ConsumerWidget {
  const ScriptCoverageSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(scriptCoverageProvider);
    return DashboardSection(
      title: 'Test & script coverage',
      child: async.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => Text('Could not load coverage: $e'),
        data: (c) => _CoverageBody(coverage: c),
      ),
    );
  }
}

class _CoverageBody extends StatelessWidget {
  const _CoverageBody({required this.coverage});
  final ScriptCoverage coverage;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (coverage.totalRequests == 0) {
      return Text(
        'No requests in the selected collection(s).',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
      );
    }

    final testPct = coverage.testCoverage;
    final scriptPct = coverage.scriptCoverage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            DashboardKpiCard(
              label: 'Test coverage',
              value: formatPct(testPct),
              subtitle: '${coverage.withPostScript}/${coverage.totalRequests} with post-scripts',
              emphasized: true,
              valueColor: testPct >= 0.7
                  ? dashboardSuccessColor(context)
                  : testPct >= 0.4
                      ? Colors.orange.shade800
                      : scheme.error,
            ),
            DashboardKpiCard(
              label: 'Any scripts',
              value: formatPct(scriptPct),
              subtitle: '${coverage.withAnyScript} of ${coverage.totalRequests}',
            ),
            DashboardKpiCard(
              label: 'Pre-request',
              value: '${coverage.withPreScript}',
            ),
            DashboardKpiCard(
              label: 'Post-response',
              value: '${coverage.withPostScript}',
            ),
          ],
        ),
        kVSpacer16,
        Text(
          'Post-response scripts act as tests / assertions for coverage.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
        ),
        kVSpacer8,
        ClipRRect(
          borderRadius: kBorderRadius8,
          child: LinearProgressIndicator(
            value: testPct.clamp(0.0, 1.0),
            minHeight: 10,
            backgroundColor: scheme.surfaceContainerHighest,
          ),
        ),
        kVSpacer16,
        Text(
          'Missing tests (${coverage.uncoveredTests.length})',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        kVSpacer8,
        if (coverage.uncoveredTests.isEmpty)
          Text(
            'All requests have a post-response script.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          )
        else
          ...coverage.uncoveredTests.take(12).map(
                (r) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(Icons.science_outlined,
                          size: 16, color: scheme.onSurfaceVariant),
                      kHSpacer8,
                      Expanded(
                        child: Text(
                          r.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Text(
                        r.hasPre ? 'pre only' : 'no scripts',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }
}
