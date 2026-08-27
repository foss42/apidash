import 'package:apidash/consts.dart';
import 'package:apidash/workflow/consts.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/common_widgets/common_widgets.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/ai_request/request_pane_ai.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/request_pane_graphql.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/request_pane_rest.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/response_pane.dart';
import 'package:apidash/screens/home_page/editor_pane/url_card.dart';
import 'package:apidash/services/storage/workspace_storage.dart';
import 'package:apidash/workflow/engine/workflow_request_executor.dart';
import 'package:apidash/workflow/engine/workflow_runner.dart';
import 'package:apidash/workflow/models/workflow_models.dart';
import 'package:apidash/workflow/widgets/workflow_variable_browser.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_split_view/multi_split_view.dart';

Future<void> showWorkflowRequestStepEditor(
  BuildContext context,
  WidgetRef ref, {
  required WorkflowGraphNode node,
}) {
  final workflow = ref.read(activeWorkflowProvider);
  if (workflow == null || node.type != WorkflowNodeType.request) {
    return Future.value();
  }

  final resolved = resolveWorkflowNodeRequest(
    node: node,
    storage: workspaceStorage,
  );
  final request = resolved.copyWith(
    httpRequestModel: resolved.httpRequestModel ?? const HttpRequestModel(),
  );

  if (context.isMediumWindow) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (dialogContext) => ProviderScope(
          overrides: [
            ..._editorOverrides(
              ref: ref,
              node: node,
              request: request,
            ),
          ],
          child: WorkflowRequestStepEditorPage(node: node),
        ),
      ),
    );
  }

  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) => ProviderScope(
      overrides: [
        ..._editorOverrides(
          ref: ref,
          node: node,
          request: request,
        ),
      ],
      child: Dialog(
        insetPadding: const EdgeInsets.all(20),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: 1280,
          height: 820,
          child: WorkflowRequestStepEditorPage(node: node),
        ),
      ),
    ),
  );
}

List _editorOverrides({
  required WidgetRef ref,
  required WorkflowGraphNode node,
  required RequestModel request,
}) {
  return [
    selectedIdStateProvider.overrideWith((ref) => request.id),
    activeCollectionProvider.overrideWith(
      (scopeRef) => ActiveCollectionNotifier.ephemeral(
        scopeRef,
        workspaceStorage,
        request,
      ),
    ),
    selectedRequestModelProvider.overrideWith((scopeRef) {
      final collection = scopeRef.watch(activeCollectionProvider);
      return collection?[request.id];
    }),
    codePaneVisibleStateProvider.overrideWith((ref) => false),
    requestPersistHookProvider.overrideWith((scopeRef) {
      return (requestId, model) async {
        await scopeRef
            .read(activeWorkflowProvider.notifier)
            .updateNodeRequest(node.id, model);
        final workflow = scopeRef.read(activeWorkflowProvider);
        if (workflow == null) {
          return;
        }
        WorkflowGraphNode? currentNode;
        for (final candidate in workflow.graph.nodes) {
          if (candidate.id == node.id) {
            currentNode = candidate;
            break;
          }
        }
        if (currentNode == null) {
          return;
        }
        final label =
            model.name.trim().isNotEmpty ? model.name.trim() : currentNode.label;
        if (label != currentNode.label) {
          await scopeRef.read(activeWorkflowProvider.notifier).updateSelectedNode(
                currentNode.copyWith(label: label),
              );
        }
      };
    }),
  ];
}

class WorkflowRequestStepEditorPage extends ConsumerStatefulWidget {
  const WorkflowRequestStepEditorPage({
    super.key,
    required this.node,
  });

  final WorkflowGraphNode node;

  @override
  ConsumerState<WorkflowRequestStepEditorPage> createState() =>
      _WorkflowRequestStepEditorPageState();
}

class _WorkflowRequestStepEditorPageState
    extends ConsumerState<WorkflowRequestStepEditorPage> {
  final _extractionVarController = TextEditingController();
  final _extractionPathController = TextEditingController();
  final MultiSplitViewController _splitController = MultiSplitViewController(
    areas: [
      Area(id: 'variables', size: 260, min: 200, max: 360),
      Area(id: 'request', min: 420),
      Area(id: 'response', size: 360, min: 280, max: 520),
    ],
  );
  bool _testing = false;

  @override
  void dispose() {
    _extractionVarController.dispose();
    _extractionPathController.dispose();
    _splitController.dispose();
    super.dispose();
  }

  Future<void> _confirmDeleteStep() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete step'),
        content: const Text(
          'Remove this request step from the workflow? Its connections will also be removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(kLabelCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(kTooltipDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) {
      return;
    }
    await ref.read(activeWorkflowProvider.notifier).deleteNode(widget.node.id);
    ref.read(selectedWorkflowNodeIdProvider.notifier).state = null;
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _testStep() async {
    final workflow = ref.read(activeWorkflowProvider);
    final requestId = ref.read(selectedIdStateProvider);
    final current = ref.read(selectedRequestModelProvider);
    if (workflow == null || requestId == null || current == null) {
      return;
    }
    final latestNode = workflow.nodeById(widget.node.id);
    if (latestNode == null) {
      return;
    }

    setState(() => _testing = true);
    final notifier = ref.read(activeCollectionProvider.notifier);
    notifier.replaceSelectedRequest(
      current.copyWith(
        isWorking: true,
        sendingTime: DateTime.now(),
        responseStatus: null,
        message: null,
        httpResponseModel: null,
      ),
    );

    final request = resolveWorkflowNodeRequest(
      node: latestNode.copyWith(request: current.toJson()),
      storage: workspaceStorage,
    );

    final result = await executeWorkflowRequest(
      ref: ref,
      requestModel: request,
      scopedVariables: const {},
      logLabel: '${workflow.id}/${widget.node.id}',
    );

    final latest = ref.read(selectedRequestModelProvider) ?? current;
    notifier.replaceSelectedRequest(
      latest.copyWith(
        isWorking: false,
        responseStatus: result.statusCode ?? (result.ok ? 200 : -1),
        message: result.message,
        httpResponseModel: result.httpResponseModel,
      ),
    );

    if (mounted) {
      setState(() => _testing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final workflow = ref.watch(activeWorkflowProvider);
    final node = workflow?.graph.nodes
        .where((candidate) => candidate.id == widget.node.id)
        .cast<WorkflowGraphNode?>()
        .firstWhere((candidate) => candidate != null, orElse: () => null);
    if (workflow == null || node == null) {
      return const Scaffold(
        body: Center(child: Text(kMsgWorkflowNotFound)),
      );
    }

    final apiType = ref.watch(
      selectedRequestModelProvider.select((value) => value?.apiType),
    );
    final method = ref.watch(
      selectedRequestModelProvider.select(
        (value) => value?.httpRequestModel?.method ?? HTTPVerb.get,
      ),
    );
    final subtitle = switch (apiType) {
      APIType.ai => kLabelAiRequest,
      APIType.graphql => 'GraphQL request',
      _ => '${method.name.toUpperCase()} request',
    };

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(node.label.isNotEmpty ? node.label : kLabelWorkflowStep),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: kTooltipDelete,
            onPressed: _confirmDeleteStep,
          ),
          FilledButton.tonalIcon(
            onPressed: _testing ? null : _testStep,
            icon: _testing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.play_arrow_rounded),
            label: const Text('Test step'),
          ),
          kHSpacer8,
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(kLabelWorkflowDone),
          ),
          kHSpacer12,
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: kP12,
            child: WorkflowStepUrlBar(),
          ),
          const Divider(height: 1),
          Expanded(
            child: context.isMediumWindow
                ? DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        const TabBar(
                          tabs: [
                            Tab(text: kLabelRequest),
                            Tab(text: kLabelWorkflowVariables),
                            Tab(text: kLabelWorkflowStepOutput),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              _requestColumn(node),
                              WorkflowVariableBrowser(nodeId: node.id),
                              const ResponsePane(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : MultiSplitViewTheme(
                    data: MultiSplitViewThemeData(
                      dividerThickness: 3,
                      dividerPainter: DividerPainters.background(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        highlightedColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        animationEnabled: false,
                      ),
                    ),
                    child: MultiSplitView(
                      controller: _splitController,
                      builder: (context, area) {
                        return switch (area.id) {
                          'variables' => WorkflowVariableBrowser(nodeId: node.id),
                          'response' => Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: kP12,
                                  child: Text(
                                    kLabelWorkflowStepOutput,
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                ),
                                const Divider(height: 1),
                                const Expanded(child: ResponsePane()),
                              ],
                            ),
                          _ => _requestColumn(node),
                        };
                      },
                    ),
                  ),
          ),
          const Divider(height: 1),
          SizedBox(
            height: 188,
            child: _ExtractionsPanel(
              node: node,
              varController: _extractionVarController,
              pathController: _extractionPathController,
            ),
          ),
        ],
      ),
    );
  }

  Widget _requestColumn(WorkflowGraphNode node) {
    return Consumer(
      builder: (context, ref, _) {
        final apiType = ref.watch(
          selectedRequestModelProvider.select((value) => value?.apiType),
        );
        return switch (apiType) {
          APIType.ai =>
            const EditAIRequestPane(showViewCodeButton: false),
          APIType.graphql =>
            const EditGraphQLRequestPane(showViewCodeButton: false),
          _ => const EditRestRequestPane(showViewCodeButton: false),
        };
      },
    );
  }
}

class _ExtractionsPanel extends ConsumerWidget {
  const _ExtractionsPanel({
    required this.node,
    required this.varController,
    required this.pathController,
  });

  final WorkflowGraphNode node;
  final TextEditingController varController;
  final TextEditingController pathController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final workflow = ref.watch(activeWorkflowProvider);
    final currentNode = workflow?.graph.nodes
        .where((candidate) => candidate.id == node.id)
        .cast<WorkflowGraphNode?>()
        .firstWhere((candidate) => candidate != null, orElse: () => null);
    if (currentNode == null) {
      return const SizedBox.shrink();
    }

    final extractions = currentNode.extractions;

    return ColoredBox(
      color: scheme.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  kLabelWorkflowExtractions,
                  style: theme.textTheme.titleSmall,
                ),
                if (extractions.isNotEmpty) ...[
                  kHSpacer8,
                  Text(
                    '${extractions.length}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.outline,
                    ),
                  ),
                ],
                const Spacer(),
                Text(
                  'Map a response path to a {{variable}}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.outline,
                  ),
                ),
              ],
            ),
            kVSpacer8,
            Expanded(
              child: extractions.isEmpty
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'None yet.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.outline,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: extractions.length,
                      separatorBuilder: (_, _) => kVSpacer4,
                      itemBuilder: (context, index) {
                        final extraction = extractions[index];
                        return _ExtractionRow(
                          varName: extraction.varName,
                          pathLabel:
                              '${extraction.source}.${extraction.jsonPath}',
                          onDelete: () async {
                            await ref
                                .read(activeWorkflowProvider.notifier)
                                .updateSelectedNode(
                                  currentNode.copyWith(
                                    extractions: extractions
                                        .where((item) => item != extraction)
                                        .toList(),
                                  ),
                                );
                          },
                        );
                      },
                    ),
            ),
            kVSpacer8,
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Variable',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      kVSpacer4,
                      TextField(
                        controller: varController,
                        style: kCodeStyle.copyWith(
                          color: scheme.onSurface,
                        ),
                        decoration: getTextFieldInputDecoration(
                          scheme,
                          hintText: 'userId',
                          isDense: true,
                          contentPadding: kP10,
                        ),
                      ),
                    ],
                  ),
                ),
                kHSpacer8,
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Path',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      kVSpacer4,
                      TextField(
                        controller: pathController,
                        style: kCodeStyle.copyWith(
                          color: scheme.onSurface,
                        ),
                        decoration: getTextFieldInputDecoration(
                          scheme,
                          hintText: 'token',
                          isDense: true,
                          contentPadding: kP10,
                        ),
                      ),
                    ],
                  ),
                ),
                kHSpacer8,
                FilledButton(
                  style: FilledButton.styleFrom(
                    visualDensity: VisualDensity.standard,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  onPressed: () async {
                    final varName = varController.text.trim();
                    final jsonPath = pathController.text.trim();
                    if (varName.isEmpty || jsonPath.isEmpty) {
                      return;
                    }
                    await ref
                        .read(activeWorkflowProvider.notifier)
                        .updateSelectedNode(
                          currentNode.copyWith(
                            extractions: [
                              ...extractions,
                              WorkflowExtraction(
                                varName: varName,
                                jsonPath: jsonPath,
                              ),
                            ],
                          ),
                        );
                    varController.clear();
                    pathController.clear();
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ExtractionRow extends StatelessWidget {
  const _ExtractionRow({
    required this.varName,
    required this.pathLabel,
    required this.onDelete,
  });

  final String varName;
  final String pathLabel;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: scheme.secondaryContainer.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '{{$varName}}',
              style: theme.textTheme.labelMedium?.copyWith(
                fontFamily: kCodeStyle.fontFamily,
                fontWeight: FontWeight.w600,
                color: scheme.onSecondaryContainer,
              ),
            ),
          ),
          kHSpacer10,
          Expanded(
            child: Text(
              pathLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
                fontFamily: kCodeStyle.fontFamily,
              ),
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            tooltip: kTooltipDelete,
            icon: Icon(
              Icons.close_rounded,
              size: 18,
              color: scheme.onSurfaceVariant,
            ),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

class WorkflowStepUrlBar extends ConsumerWidget {
  const WorkflowStepUrlBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedId = ref.watch(selectedIdStateProvider);
    final requestModel = ref.watch(selectedRequestModelProvider);
    final apiType = requestModel?.apiType;
    final url = requestModel?.httpRequestModel?.url ??
        requestModel?.aiRequestModel?.httpRequestModel?.url ??
        '';

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: theme.colorScheme.surfaceContainerHighest),
        borderRadius: kBorderRadius12,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            switch (apiType) {
              APIType.ai => const AIModelSelector(),
              APIType.graphql => kSizedBoxEmpty,
              _ => const DropdownButtonHTTPMethod(),
            },
            if (apiType != APIType.graphql) kHSpacer8,
            Expanded(
              child: selectedId == null
                  ? TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: kLabelURL,
                        hintText: kHintTextUrlCard,
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                    )
                  : EnvURLField(
                      selectedId: selectedId,
                      initialValue: url,
                      onChanged: (value) {
                        ref
                            .read(activeCollectionProvider.notifier)
                            .update(url: value);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
