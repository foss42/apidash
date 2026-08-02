import 'package:apidash/consts.dart';
import 'package:apidash/dashbot/dashbot.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/services/storage/workspace_storage.dart';
import 'package:apidash/workflow/consts.dart';
import 'package:apidash/workflow/models/workflow_models.dart';
import 'package:apidash/workflow/widgets/workflow_history_drawer.dart';
import 'package:apidash/workflow/widgets/workflow_canvas.dart';
import 'package:apidash/workflow/widgets/workflow_logic_node_editor.dart';
import 'package:apidash/workflow/widgets/workflow_run_exchange_panel.dart';
import 'package:apidash/workflow/widgets/workflow_selector_dropdown.dart';
import 'package:apidash/screens/common_widgets/environment_dropdown.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkflowPage extends ConsumerStatefulWidget {
  const WorkflowPage({super.key});

  @override
  ConsumerState<WorkflowPage> createState() => _WorkflowPageState();
}

class _WorkflowPageState extends ConsumerState<WorkflowPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    if (!isWorkspaceStorageInitialized()) {
      return;
    }
    await ref.read(workflowCatalogProvider.notifier).reloadFromDisk();
    final selected = ref.read(selectedWorkflowIdStateProvider);
    if (selected != null) {
      await ref.read(activeWorkflowProvider.notifier).load(selected);
      return;
    }
    final workflows = ref.read(workflowCatalogProvider).value ?? const [];
    if (workflows.isNotEmpty) {
      ref.read(selectedWorkflowIdStateProvider.notifier).state =
          workflows.first.id;
      await ref.read(activeWorkflowProvider.notifier).load(workflows.first.id);
    }
  }

  WorkflowGraphNode? _selectedNode(
    String? selectedNodeId,
    WorkflowDocument? workflow,
  ) {
    if (selectedNodeId == null || workflow == null) {
      return null;
    }
    for (final node in workflow.graph.nodes) {
      if (node.id == selectedNodeId) {
        return node;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final selectedNodeId = ref.watch(selectedWorkflowNodeIdProvider);
    final workflow = ref.watch(activeWorkflowProvider);
    final selectedNode = _selectedNode(selectedNodeId, workflow);
    final isDashbotPopped =
        ref.watch(dashbotWindowNotifierProvider.select((s) => s.isPopped));
    final onWorkflowsRail =
        ref.watch(navRailIndexStateProvider) == kNavRailWorkflowsIndex;
    final showDashbot = !isDashbotPopped && onWorkflowsRail;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: kP8,
          child: Row(
            children: [
              SizedBox(
                width: context.isMediumWindow ? 240 : 320,
                child: const WorkflowSelectorDropdown(),
              ),
              if (selectedNode != null &&
                  selectedNode.type != WorkflowNodeType.manualStart) ...[
                kHSpacer8,
                FilledButton.tonalIcon(
                  style: FilledButton.styleFrom(
                    animationDuration: const Duration(milliseconds: 120),
                  ),
                  onPressed: () => openWorkflowNodeEditor(
                    context,
                    ref,
                    node: selectedNode,
                  ),
                  icon: const Icon(Icons.tune_rounded),
                  label: Text(
                    context.isMediumWindow ? 'Edit' : 'Edit node',
                  ),
                ),
              ],
              const Spacer(),
              IconButton(
                tooltip: kTooltipFlowHistory,
                onPressed: workflow == null
                    ? null
                    : () => showFlowHistoryDrawer(context),
                icon: const Icon(Icons.history_rounded),
              ),
              kHSpacer4,
              const EnvironmentDropdown(),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: showDashbot
              ? const EqualSplitView(
                  leftWidget: ClipRect(child: WorkflowCanvas()),
                  rightWidget: DashbotTab(),
                )
              : const ClipRect(child: WorkflowCanvas()),
        ),
        const WorkflowRunInspector(),
      ],
    );
  }
}
