import 'package:apidash/consts.dart';
import 'package:apidash/workflow/consts.dart';
import 'package:apidash/workflow/models/workflow_models.dart';
import 'package:apidash/workflow/providers/workflow_providers.dart';
import 'package:apidash/workflow/providers/workflow_ui_providers.dart';
import 'package:apidash/workflow/widgets/workflow_request_step_editor.dart';
import 'package:apidash/workflow/widgets/workflow_variable_browser.dart';
import 'package:apidash/workflow/utils/workflow_loop_utils.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_split_view/multi_split_view.dart';

Future<void> openWorkflowNodeEditor(
  BuildContext context,
  WidgetRef ref, {
  required WorkflowGraphNode node,
}) {
  return switch (node.type) {
    WorkflowNodeType.request =>
      showWorkflowRequestStepEditor(context, ref, node: node),
    WorkflowNodeType.loop =>
      showWorkflowLoopStepEditor(context, ref, node: node),
    WorkflowNodeType.condition =>
      showWorkflowConditionStepEditor(context, ref, node: node),
    WorkflowNodeType.delay =>
      showWorkflowDelayStepEditor(context, ref, node: node),
    _ => Future.value(),
  };
}

Future<void> showWorkflowLoopStepEditor(
  BuildContext context,
  WidgetRef ref, {
  required WorkflowGraphNode node,
}) {
  return _showLogicNodeEditor(
    context,
    node: node,
    editor: _WorkflowLoopStepEditorPage(node: node),
  );
}

Future<void> showWorkflowConditionStepEditor(
  BuildContext context,
  WidgetRef ref, {
  required WorkflowGraphNode node,
}) {
  return _showLogicNodeEditor(
    context,
    node: node,
    editor: _WorkflowConditionStepEditorPage(node: node),
  );
}

Future<void> showWorkflowDelayStepEditor(
  BuildContext context,
  WidgetRef ref, {
  required WorkflowGraphNode node,
}) {
  return _showLogicNodeEditor(
    context,
    node: node,
    editor: _WorkflowDelayStepEditorPage(node: node),
  );
}

Future<void> _showLogicNodeEditor(
  BuildContext context, {
  required WorkflowGraphNode node,
  required Widget editor,
}) {
  if (context.isMediumWindow) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (dialogContext) => editor,
      ),
    );
  }

  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) => Dialog(
      insetPadding: const EdgeInsets.all(20),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 1280,
        height: 820,
        child: editor,
      ),
    ),
  );
}

class _WorkflowLoopStepEditorPage extends ConsumerStatefulWidget {
  const _WorkflowLoopStepEditorPage({required this.node});

  final WorkflowGraphNode node;

  @override
  ConsumerState<_WorkflowLoopStepEditorPage> createState() =>
      _WorkflowLoopStepEditorPageState();
}

class _WorkflowLoopStepEditorPageState
    extends ConsumerState<_WorkflowLoopStepEditorPage> {
  late final TextEditingController _labelController;
  late final TextEditingController _listVarController;
  late final TextEditingController _itemFieldController;
  late final TextEditingController _itemAsController;
  late final TextEditingController _iterationsController;
  late WorkflowLoopMode _loopMode;
  final MultiSplitViewController _splitController = MultiSplitViewController(
    areas: [
      Area(id: 'variables', size: 260, min: 200, max: 360),
      Area(id: 'config', min: 420),
      Area(id: 'guide', size: 360, min: 280, max: 520),
    ],
  );

  @override
  void initState() {
    super.initState();
    final listVar = formatLoopListVariableRef(
      widget.node.loopExpression ?? 'var:items',
    );
    _labelController = TextEditingController(
      text: widget.node.label.isNotEmpty ? widget.node.label : kLabelWorkflowLoop,
    );
    _listVarController = TextEditingController(text: listVar);
    _itemFieldController = TextEditingController(
      text: widget.node.loopItemField ?? '',
    );
    _itemAsController = TextEditingController(
      text: widget.node.loopItemAs ?? '',
    );
    _loopMode = widget.node.loopMode;
    final maxIterations = widget.node.loopMaxIterations;
    _iterationsController = TextEditingController(
      text: maxIterations != null && maxIterations > 0 ? '$maxIterations' : '',
    );
  }

  @override
  void dispose() {
    _labelController.dispose();
    _listVarController.dispose();
    _itemFieldController.dispose();
    _itemAsController.dispose();
    _iterationsController.dispose();
    _splitController.dispose();
    super.dispose();
  }

  WorkflowGraphNode? _currentNode(WorkflowDocument? workflow) {
    if (workflow == null) {
      return null;
    }
    for (final candidate in workflow.graph.nodes) {
      if (candidate.id == widget.node.id) {
        return candidate;
      }
    }
    return null;
  }

  Future<void> _saveAndClose() async {
    final saved = await _persist();
    if (!saved || !mounted) {
      return;
    }
    Navigator.of(context).pop();
  }

  Future<bool> _persist() async {
    final label = _labelController.text.trim();
    final iterationsRaw = _iterationsController.text.trim();
    final parsedIterations = int.tryParse(iterationsRaw);

    if (_loopMode == WorkflowLoopMode.repeat) {
      if (parsedIterations == null || parsedIterations <= 0) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Set times to repeat to a number greater than 0'),
            ),
          );
        }
        return false;
      }
      await ref.read(activeWorkflowProvider.notifier).updateSelectedNode(
            widget.node.copyWith(
              label: label.isNotEmpty
                  ? label
                  : 'Repeat $parsedIterations times',
              loopMode: WorkflowLoopMode.repeat,
              loopMaxIterations: parsedIterations,
              clearLoopExpression: true,
              clearLoopItemField: true,
              clearLoopItemAs: true,
            ),
          );
      return true;
    }

    final listVar = parseLoopListVariableName(_listVarController.text);
    if (listVar == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Fill List (e.g. {{users}}) - the loop will not work without it',
            ),
          ),
        );
      }
      return false;
    }
    final itemField = _itemFieldController.text.trim();
    final itemAs = parseLoopListVariableName(_itemAsController.text) ??
        _itemAsController.text.trim();
    if ((itemField.isEmpty) != (itemAs.isEmpty)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Set both Variable and Path, or leave both empty',
            ),
          ),
        );
      }
      return false;
    }
    final loopMaxIterations =
        parsedIterations != null && parsedIterations > 0
            ? parsedIterations
            : null;
    await ref.read(activeWorkflowProvider.notifier).updateSelectedNode(
          widget.node.copyWith(
            label: label.isNotEmpty ? label : kLabelWorkflowLoop,
            loopMode: WorkflowLoopMode.forEach,
            loopExpression: encodeLoopListExpression(listVar),
            loopMaxIterations: loopMaxIterations,
            clearLoopMaxIterations: loopMaxIterations == null,
            loopItemField: itemField.isEmpty ? null : itemField,
            clearLoopItemField: itemField.isEmpty,
            loopItemAs: itemAs.isEmpty ? null : itemAs,
            clearLoopItemAs: itemAs.isEmpty,
          ),
        );
    return true;
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete node'),
        content: const Text(
          'Remove this loop from the workflow? Its connections will also be removed.',
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

  @override
  Widget build(BuildContext context) {
    final workflow = ref.watch(activeWorkflowProvider);
    final node = _currentNode(workflow);
    if (workflow == null || node == null) {
      return const Scaffold(
        body: Center(child: Text(kMsgWorkflowNotFound)),
      );
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          await _persist();
        }
      },
      child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () async {
            await _persist();
            if (mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              node.label.isNotEmpty ? node.label : kLabelWorkflowLoop,
            ),
            Text(
              _loopMode == WorkflowLoopMode.repeat
                  ? 'Repeat N times'
                  : 'For each item in a list',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: kTooltipDelete,
            onPressed: _confirmDelete,
          ),
          FilledButton(
            onPressed: _saveAndClose,
            child: const Text(kLabelWorkflowDone),
          ),
          kHSpacer12,
        ],
      ),
      body: _LogicNodeEditorBody(
        nodeId: node.id,
        splitController: _splitController,
        config: _LoopConfigPanel(
          labelController: _labelController,
          listVarController: _listVarController,
          itemFieldController: _itemFieldController,
          itemAsController: _itemAsController,
          iterationsController: _iterationsController,
          loopMode: _loopMode,
          onLoopModeChanged: (mode) => setState(() => _loopMode = mode),
        ),
        guide: const _LoopGuidePanel(),
      ),
    ),
    );
  }
}

class _WorkflowConditionStepEditorPage extends ConsumerStatefulWidget {
  const _WorkflowConditionStepEditorPage({required this.node});

  final WorkflowGraphNode node;

  @override
  ConsumerState<_WorkflowConditionStepEditorPage> createState() =>
      _WorkflowConditionStepEditorPageState();
}

class _WorkflowConditionStepEditorPageState
    extends ConsumerState<_WorkflowConditionStepEditorPage> {
  late final TextEditingController _labelController;
  late final TextEditingController _expressionController;
  final MultiSplitViewController _splitController = MultiSplitViewController(
    areas: [
      Area(id: 'variables', size: 260, min: 200, max: 360),
      Area(id: 'config', min: 420),
      Area(id: 'guide', size: 360, min: 280, max: 520),
    ],
  );

  static const _expressionPresets = [
    'status>=200',
    'status<400',
    'status>=200&&status<300',
    'var:token',
    'true',
    'false',
  ];

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(
      text: widget.node.label.isNotEmpty
          ? widget.node.label
          : kLabelWorkflowCondition,
    );
    _expressionController = TextEditingController(
      text: widget.node.conditionExpression ?? 'status>=200',
    );
  }

  @override
  void dispose() {
    _labelController.dispose();
    _expressionController.dispose();
    _splitController.dispose();
    super.dispose();
  }

  WorkflowGraphNode? _currentNode(WorkflowDocument? workflow) {
    if (workflow == null) {
      return null;
    }
    for (final candidate in workflow.graph.nodes) {
      if (candidate.id == widget.node.id) {
        return candidate;
      }
    }
    return null;
  }

  Future<void> _saveAndClose() async {
    final expression = _expressionController.text.trim();
    if (expression.isEmpty) {
      return;
    }
    final label = _labelController.text.trim();
    await ref.read(activeWorkflowProvider.notifier).updateSelectedNode(
          widget.node.copyWith(
            label: label.isNotEmpty ? label : kLabelWorkflowCondition,
            conditionExpression: expression,
          ),
        );
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete node'),
        content: const Text(
          'Remove this condition from the workflow? Its connections will also be removed.',
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

  @override
  Widget build(BuildContext context) {
    final workflow = ref.watch(activeWorkflowProvider);
    final node = _currentNode(workflow);
    if (workflow == null || node == null) {
      return const Scaffold(
        body: Center(child: Text(kMsgWorkflowNotFound)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              node.label.isNotEmpty ? node.label : kLabelWorkflowCondition,
            ),
            Text(
              'True / False branch',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: kTooltipDelete,
            onPressed: _confirmDelete,
          ),
          FilledButton(
            onPressed: _saveAndClose,
            child: const Text(kLabelWorkflowDone),
          ),
          kHSpacer12,
        ],
      ),
      body: _LogicNodeEditorBody(
        nodeId: node.id,
        splitController: _splitController,
        config: _ConditionConfigPanel(
          labelController: _labelController,
          expressionController: _expressionController,
          presets: _expressionPresets,
          onPresetSelected: (value) => setState(() {
            _expressionController.text = value;
          }),
        ),
        guide: const _ConditionGuidePanel(),
      ),
    );
  }
}

class _WorkflowDelayStepEditorPage extends ConsumerStatefulWidget {
  const _WorkflowDelayStepEditorPage({required this.node});

  final WorkflowGraphNode node;

  @override
  ConsumerState<_WorkflowDelayStepEditorPage> createState() =>
      _WorkflowDelayStepEditorPageState();
}

class _WorkflowDelayStepEditorPageState
    extends ConsumerState<_WorkflowDelayStepEditorPage> {
  late final TextEditingController _labelController;
  late final TextEditingController _delayController;
  final MultiSplitViewController _splitController = MultiSplitViewController(
    areas: [
      Area(id: 'variables', size: 260, min: 200, max: 360),
      Area(id: 'config', min: 420),
      Area(id: 'guide', size: 360, min: 280, max: 520),
    ],
  );

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(
      text: widget.node.label.isNotEmpty
          ? widget.node.label
          : kLabelWorkflowDelay,
    );
    final delayMs = widget.node.delayMs;
    _delayController = TextEditingController(
      text: delayMs != null && delayMs > 0 ? '$delayMs' : '1000',
    );
  }

  @override
  void dispose() {
    _labelController.dispose();
    _delayController.dispose();
    _splitController.dispose();
    super.dispose();
  }

  WorkflowGraphNode? _currentNode(WorkflowDocument? workflow) {
    if (workflow == null) {
      return null;
    }
    for (final candidate in workflow.graph.nodes) {
      if (candidate.id == widget.node.id) {
        return candidate;
      }
    }
    return null;
  }

  Future<void> _saveAndClose() async {
    final delayRaw = _delayController.text.trim();
    final delayMs = int.tryParse(delayRaw);
    if (delayMs == null || delayMs <= 0) {
      return;
    }
    final label = _labelController.text.trim();
    await ref.read(activeWorkflowProvider.notifier).updateSelectedNode(
          widget.node.copyWith(
            label: label.isNotEmpty ? label : kLabelWorkflowDelay,
            delayMs: delayMs,
          ),
        );
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete node'),
        content: const Text(
          'Remove this delay from the workflow? Its connections will also be removed.',
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

  @override
  Widget build(BuildContext context) {
    final workflow = ref.watch(activeWorkflowProvider);
    final node = _currentNode(workflow);
    if (workflow == null || node == null) {
      return const Scaffold(
        body: Center(child: Text(kMsgWorkflowNotFound)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              node.label.isNotEmpty ? node.label : kLabelWorkflowDelay,
            ),
            Text(
              'Wait before continuing',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: kTooltipDelete,
            onPressed: _confirmDelete,
          ),
          FilledButton(
            onPressed: _saveAndClose,
            child: const Text(kLabelWorkflowDone),
          ),
          kHSpacer12,
        ],
      ),
      body: _LogicNodeEditorBody(
        nodeId: node.id,
        splitController: _splitController,
        config: _DelayConfigPanel(
          labelController: _labelController,
          delayController: _delayController,
          onPresetSelected: (value) => setState(() {
            _delayController.text = value;
          }),
        ),
        guide: const _DelayGuidePanel(),
      ),
    );
  }
}

class _LogicNodeEditorBody extends StatelessWidget {
  const _LogicNodeEditorBody({
    required this.nodeId,
    required this.splitController,
    required this.config,
    required this.guide,
  });

  final String nodeId;
  final MultiSplitViewController splitController;
  final Widget config;
  final Widget guide;

  @override
  Widget build(BuildContext context) {
    if (context.isMediumWindow) {
      return DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: kLabelConfiguration),
                Tab(text: kLabelWorkflowVariables),
                Tab(text: 'Guide'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  config,
                  WorkflowVariableBrowser(nodeId: nodeId),
                  guide,
                ],
              ),
            ),
          ],
        ),
      );
    }

    return MultiSplitViewTheme(
      data: MultiSplitViewThemeData(
        dividerThickness: 3,
        dividerPainter: DividerPainters.background(
          color: Theme.of(context).colorScheme.surfaceContainer,
          highlightedColor:
              Theme.of(context).colorScheme.surfaceContainerHighest,
          animationEnabled: false,
        ),
      ),
      child: MultiSplitView(
        controller: splitController,
        builder: (context, area) {
          return switch (area.id) {
            'variables' => WorkflowVariableBrowser(nodeId: nodeId),
            'guide' => guide,
            _ => config,
          };
        },
      ),
    );
  }
}

class _LoopConfigPanel extends StatelessWidget {
  const _LoopConfigPanel({
    required this.labelController,
    required this.listVarController,
    required this.itemFieldController,
    required this.itemAsController,
    required this.iterationsController,
    required this.loopMode,
    required this.onLoopModeChanged,
  });

  final TextEditingController labelController;
  final TextEditingController listVarController;
  final TextEditingController itemFieldController;
  final TextEditingController itemAsController;
  final TextEditingController iterationsController;
  final WorkflowLoopMode loopMode;
  final ValueChanged<WorkflowLoopMode> onLoopModeChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRepeat = loopMode == WorkflowLoopMode.repeat;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Loop configuration', style: theme.textTheme.titleMedium),
        const SizedBox(height: 16),
        SegmentedButton<WorkflowLoopMode>(
          segments: const [
            ButtonSegment(
              value: WorkflowLoopMode.forEach,
              label: Text(kLabelWorkflowLoopForEach),
              icon: Icon(Icons.list_rounded, size: 18),
            ),
            ButtonSegment(
              value: WorkflowLoopMode.repeat,
              label: Text(kLabelWorkflowLoopRepeat),
              icon: Icon(Icons.repeat_rounded, size: 18),
            ),
          ],
          selected: {loopMode},
          onSelectionChanged: (selection) {
            onLoopModeChanged(selection.first);
          },
        ),
        const SizedBox(height: 20),
        TextField(
          controller: labelController,
          decoration: const InputDecoration(
            labelText: 'Node label',
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
        const SizedBox(height: 16),
        if (isRepeat)
          _RepeatCountField(iterationsController: iterationsController)
        else ...[
          ListenableBuilder(
            listenable: listVarController,
            builder: (context, _) {
              final listEmpty =
                  parseLoopListVariableName(listVarController.text) == null;
              return TextField(
                controller: listVarController,
                decoration: InputDecoration(
                  labelText: 'List',
                  border: const OutlineInputBorder(),
                  isDense: true,
                  errorText: listEmpty
                      ? 'Required'
                      : null,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            kLabelWorkflowItemExtractions,
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: itemAsController,
                  decoration: const InputDecoration(
                    labelText: 'Variable',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: TextField(
                  controller: itemFieldController,
                  decoration: const InputDecoration(
                    labelText: 'Path',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
          ListenableBuilder(
            listenable: Listenable.merge([
              listVarController,
              itemFieldController,
            ]),
            builder: (context, _) {
              final preview = formatLoopItemExtractionPreview(
                listRaw: listVarController.text,
                pathRaw: itemFieldController.text,
              );
              if (preview == null) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Will be extracted from $preview',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: iterationsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Max items',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ],
      ],
    );
  }
}

class _RepeatCountField extends StatefulWidget {
  const _RepeatCountField({required this.iterationsController});

  final TextEditingController iterationsController;

  @override
  State<_RepeatCountField> createState() => _RepeatCountFieldState();
}

class _RepeatCountFieldState extends State<_RepeatCountField> {
  static const _custom = 'custom';
  late String _selection;

  @override
  void initState() {
    super.initState();
    _selection = _selectionFor(widget.iterationsController.text);
    if (_selection != _custom && widget.iterationsController.text.trim().isEmpty) {
      widget.iterationsController.text = _selection;
    }
  }

  String _selectionFor(String raw) {
    final n = int.tryParse(raw.trim());
    if (n != null && n >= 1 && n <= 10) {
      return '$n';
    }
    if (raw.trim().isNotEmpty) {
      return _custom;
    }
    return '5';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownMenu<String>(
          key: ValueKey('repeat-count-$_selection'),
          initialSelection: _selection,
          label: const Text('Times to repeat'),
          expandedInsets: EdgeInsets.zero,
          dropdownMenuEntries: [
            for (var i = 1; i <= 10; i++)
              DropdownMenuEntry(value: '$i', label: '$i'),
            const DropdownMenuEntry(value: _custom, label: 'Custom'),
          ],
          onSelected: (value) {
            if (value == null) {
              return;
            }
            setState(() => _selection = value);
            if (value == _custom) {
              final n = int.tryParse(widget.iterationsController.text.trim());
              if (n != null && n >= 1 && n <= 10) {
                widget.iterationsController.clear();
              }
            } else {
              widget.iterationsController.text = value;
            }
          },
        ),
        if (_selection == _custom) ...[
          const SizedBox(height: 12),
          TextField(
            controller: widget.iterationsController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Custom count',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ],
      ],
    );
  }
}

class _ConditionConfigPanel extends StatelessWidget {
  const _ConditionConfigPanel({
    required this.labelController,
    required this.expressionController,
    required this.presets,
    required this.onPresetSelected,
  });

  final TextEditingController labelController;
  final TextEditingController expressionController;
  final List<String> presets;
  final ValueChanged<String> onPresetSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Condition configuration', style: theme.textTheme.titleMedium),
        const SizedBox(height: 16),
        TextField(
          controller: labelController,
          decoration: const InputDecoration(
            labelText: 'Node label',
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: expressionController,
          decoration: const InputDecoration(
            labelText: 'Expression',
            hintText: 'status>=200',
            helperText:
                'Evaluated after the previous step. Wire True and False ports to branch.',
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
        const SizedBox(height: 16),
        Text('Quick presets', style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final preset in presets)
              ActionChip(
                label: Text(preset),
                onPressed: () => onPresetSelected(preset),
              ),
          ],
        ),
      ],
    );
  }
}

class _DelayConfigPanel extends StatelessWidget {
  const _DelayConfigPanel({
    required this.labelController,
    required this.delayController,
    required this.onPresetSelected,
  });

  final TextEditingController labelController;
  final TextEditingController delayController;
  final ValueChanged<String> onPresetSelected;

  static const _presets = ['500', '1000', '2000', '5000'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Delay configuration', style: theme.textTheme.titleMedium),
        const SizedBox(height: 16),
        TextField(
          controller: labelController,
          decoration: const InputDecoration(
            labelText: 'Node label',
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: delayController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: kLabelWorkflowDelayMs,
            hintText: '1000',
            helperText: 'Wait this many milliseconds, then continue via Next.',
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
        const SizedBox(height: 16),
        Text('Quick presets', style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final preset in _presets)
              ActionChip(
                label: Text('${preset}ms'),
                onPressed: () => onPresetSelected(preset),
              ),
          ],
        ),
      ],
    );
  }
}

class _LoopGuidePanel extends StatelessWidget {
  const _LoopGuidePanel();

  @override
  Widget build(BuildContext context) {
    return const _GuidePanel(
      title: 'How loops work',
      sections: [
        _GuideSection(
          title: 'For each',
          body:
              'List is a chained variable like {{users}}. Wire In from that step, Each to the body request, Done for what runs after.',
        ),
        _GuideSection(
          title: 'Item extraction',
          body:
              'Same as response extractions: Path is the field on each item, Variable is the name used downstream ({{userId}}).',
        ),
        _GuideSection(
          title: 'Repeat',
          body: 'Runs the Each branch a fixed number of times. No list needed.',
        ),
      ],
    );
  }
}

class _ConditionGuidePanel extends StatelessWidget {
  const _ConditionGuidePanel();

  @override
  Widget build(BuildContext context) {
    return const _GuidePanel(
      title: 'How conditions work',
      sections: [
        _GuideSection(
          title: 'Wiring',
          body:
              'Connect In after a request step. Wire True to the success path and False to the alternate path.',
        ),
        _GuideSection(
          title: 'Status checks',
          body:
              'Use status>=200, status<400, or status>=200&&status<300 to branch on the last response code.',
        ),
        _GuideSection(
          title: 'Variables',
          body:
              'Use var:token to branch when an environment or extracted variable is set and non-empty.',
        ),
      ],
    );
  }
}

class _DelayGuidePanel extends StatelessWidget {
  const _DelayGuidePanel();

  @override
  Widget build(BuildContext context) {
    return const _GuidePanel(
      title: 'How delays work',
      sections: [
        _GuideSection(
          title: 'Wiring',
          body:
              'Connect In from the previous step and Next to the step that should run after waiting.',
        ),
        _GuideSection(
          title: 'Wait time',
          body:
              'Set milliseconds to pause the workflow. Useful for rate limits, polling gaps, or giving a service time to settle.',
        ),
        _GuideSection(
          title: 'Stop',
          body:
              'Pressing Stop during a delay cancels the wait and ends the run.',
        ),
      ],
    );
  }
}

class _GuidePanel extends StatelessWidget {
  const _GuidePanel({
    required this.title,
    required this.sections,
  });

  final String title;
  final List<_GuideSection> sections;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(title, style: theme.textTheme.titleMedium),
        const SizedBox(height: 16),
        for (final section in sections) ...[
          Text(section.title, style: theme.textTheme.titleSmall),
          const SizedBox(height: 4),
          Text(
            section.body,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _GuideSection {
  const _GuideSection({required this.title, required this.body});

  final String title;
  final String body;
}
