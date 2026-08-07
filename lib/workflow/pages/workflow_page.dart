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
import 'package:apidash/screens/mobile/workflows_page/mobile_workflows_pane.dart';
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
    final readOnly = context.isMediumWindow;
    final isDashbotPopped =
        ref.watch(dashbotWindowNotifierProvider.select((s) => s.isPopped));
    final onWorkflowsRail =
        ref.watch(navRailIndexStateProvider) == kNavRailWorkflowsIndex;
    final showDashbot = !readOnly && !isDashbotPopped && onWorkflowsRail;

    final historyButton = IconButton(
      tooltip: kTooltipFlowHistory,
      onPressed: workflow == null
          ? null
          : () => showFlowHistoryDrawer(context),
      icon: const Icon(Icons.history_rounded),
    );
    final envDropdown = const EnvironmentDropdown();

    if (readOnly) {
      return DrawerSplitView(
        scaffoldKey: kWorkflowScaffoldKey,
        title: Text(
          workflow?.name ?? kLabelWorkflows,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leftDrawerContent: const MobileWorkflowsPane(),
        actions: [
          historyButton,
          envDropdown,
          kHSpacer8,
        ],
        onDrawerChanged: (value) =>
            ref.read(leftDrawerStateProvider.notifier).state = value,
        mainContent: Padding(
          padding: kPb70,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRect(
                  child: WorkflowCanvas(readOnly: true),
                ),
              ),
              const WorkflowRunInspector(),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: kP8,
          child: Row(
            children: [
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: WorkflowSelectorDropdown(),
                  ),
                ),
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
                  label: const Text('Edit node'),
                ),
              ],
              const Spacer(),
              historyButton,
              kHSpacer4,
              envDropdown,
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: showDashbot
              ? EqualSplitView(
                  leftWidget: const ClipRect(
                    child: WorkflowCanvas(),
                  ),
                  rightWidget: const DashbotTab(),
                )
              : const ClipRect(
                  child: WorkflowCanvas(),
                ),
        ),
        const WorkflowRunInspector(),
      ],
    );
  }
}
