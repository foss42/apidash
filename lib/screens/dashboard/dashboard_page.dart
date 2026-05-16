import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:apidash/providers/providers.dart';

import 'collection_dashboard_page.dart';
import 'workflow_dashboard_page.dart';

enum _DashboardView { collections, workflows }

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  _DashboardView _view = _DashboardView.collections;

  @override
  Widget build(BuildContext context) {
    ref.listen<DashboardOpenIntent?>(dashboardOpenIntentProvider, (prev, next) {
      if (next == null) return;
      setState(() {
        _view = next.tab == DashboardMainTab.workflows
            ? _DashboardView.workflows
            : _DashboardView.collections;
      });
      if (next.workflowId != null) {
        ref.read(workflowDashboardFocusIdProvider.notifier).state = next.workflowId;
      }
      ref.read(dashboardOpenIntentProvider.notifier).state = null;
    });

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: [
              SegmentedButton<_DashboardView>(
                segments: const [
                  ButtonSegment(
                    value: _DashboardView.collections,
                    label: Text('Collections'),
                    icon: Icon(Icons.view_list_rounded),
                  ),
                  ButtonSegment(
                    value: _DashboardView.workflows,
                    label: Text('Workflows'),
                    icon: Icon(Icons.account_tree_rounded),
                  ),
                ],
                selected: {_view},
                onSelectionChanged: (value) => setState(() => _view = value.first),
              ),
            ],
          ),
        ),
        Expanded(
          child: _view == _DashboardView.collections
              ? const CollectionDashboardPage()
              : const WorkflowDashboardPage(),
        ),
      ],
    );
  }
}
