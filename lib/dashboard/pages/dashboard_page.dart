import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dashboard_models.dart';
import '../providers/dashboard_providers.dart';
import '../widgets/collection_dashboard_view.dart';
import '../widgets/webhook_reports_dialog.dart';
import '../widgets/workflow_dashboard_view.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(dashboardTabProvider);
    final range = ref.watch(dashboardTimeRangeProvider);
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            children: [
              SegmentedButton<DashboardTab>(
                segments: const [
                  ButtonSegment(
                    value: DashboardTab.collections,
                    label: Text('Collections'),
                    icon: Icon(Icons.folder_outlined, size: 18),
                  ),
                  ButtonSegment(
                    value: DashboardTab.workflows,
                    label: Text('Workflows'),
                    icon: Icon(Icons.account_tree_outlined, size: 18),
                  ),
                ],
                selected: {tab},
                onSelectionChanged: (next) {
                  ref.read(dashboardTabProvider.notifier).state = next.first;
                },
              ),
              kHSpacer16,
              Text(
                tab == DashboardTab.collections
                    ? 'Collection Dashboard'
                    : 'Workflow Dashboard',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const Spacer(),
              Builder(
                builder: (context) {
                  final auto = ref.watch(webhookAutoSendProvider);
                  return Badge(
                    isLabelVisible: auto.active,
                    label: Text(auto.interval.label),
                    child: FilledButton.tonalIcon(
                      onPressed: () => showWebhookReportsDialog(context, ref),
                      icon: Icon(
                        auto.active
                            ? Icons.schedule_send_outlined
                            : Icons.webhook_outlined,
                        size: 18,
                      ),
                      label: Text(
                        auto.active ? 'Webhook · auto' : 'Webhook reports',
                      ),
                    ),
                  );
                },
              ),
              kHSpacer10,
              if (tab == DashboardTab.collections)
                const Padding(
                  padding: EdgeInsets.only(left: 4, right: 4),
                  child: _CollectionFilter(),
                )
              else
                const Padding(
                  padding: EdgeInsets.only(left: 4, right: 4),
                  child: _WorkflowFilter(),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Row(
            children: [
              Text(
                'Range',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
              kHSpacer12,
              Wrap(
                spacing: 8,
                children: [
                  for (final r in DashboardTimeRange.values)
                    ChoiceChip(
                      label: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(r.label),
                      ),
                      selected: range == r,
                      onSelected: (_) {
                        ref.read(dashboardTimeRangeProvider.notifier).state = r;
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: tab == DashboardTab.collections
              ? const CollectionDashboardView()
              : const WorkflowDashboardView(),
        ),
      ],
    );
  }
}

class _CollectionFilter extends ConsumerWidget {
  const _CollectionFilter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(dashboardCollectionFilterProvider);
    final options = ref.watch(dashboardCollectionOptionsProvider);
    return DropdownButtonHideUnderline(
      child: DropdownButton<String?>(
        value: selected,
        hint: const Text('All collections'),
        borderRadius: kBorderRadius8,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        items: [
          const DropdownMenuItem<String?>(
            value: null,
            child: Text('All collections'),
          ),
          for (final o in options)
            DropdownMenuItem<String?>(
              value: o.id,
              child: Text(o.name),
            ),
        ],
        onChanged: (v) {
          ref.read(dashboardCollectionFilterProvider.notifier).state = v;
        },
      ),
    );
  }
}

class _WorkflowFilter extends ConsumerWidget {
  const _WorkflowFilter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(dashboardWorkflowFilterProvider);
    final options = ref.watch(dashboardWorkflowOptionsProvider);
    return DropdownButtonHideUnderline(
      child: DropdownButton<String?>(
        value: selected,
        hint: const Text('All workflows'),
        borderRadius: kBorderRadius8,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        items: [
          const DropdownMenuItem<String?>(
            value: null,
            child: Text('All workflows'),
          ),
          for (final id in options)
            DropdownMenuItem<String?>(
              value: id,
              child: Text(id),
            ),
        ],
        onChanged: (v) {
          ref.read(dashboardWorkflowFilterProvider.notifier).state = v;
        },
      ),
    );
  }
}
