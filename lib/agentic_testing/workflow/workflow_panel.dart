import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import 'package:collection/collection.dart';
import 'models/workflow_run_result.dart';
import 'models/workflow_step.dart';
import 'workflow_provider.dart';

class WorkflowPanel extends ConsumerWidget {
  const WorkflowPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workflowProvider);
    final notifier = ref.read(workflowProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: Text(
                  'Workflow Runner',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              if (state.hasResults)
                TextButton.icon(
                  onPressed: () => notifier.clearResults(),
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Reset'),
                ),
              IconButton(
                onPressed: state.isRunning || state.isAiGenerating
                    ? null
                    : () => _showAiConfigSheet(context, ref, notifier),
                tooltip: 'Auto Configure Workflow (AI)',
                icon: state.isAiGenerating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.settings_outlined),
              ),
              const SizedBox(width: 8),
              if (state.workflow.steps.isNotEmpty)
                IconButton(
                  onPressed: state.isRunning || state.isAiGenerating
                      ? null
                      : () => _showAiTestSheet(context, ref, notifier),
                  tooltip: 'Generate E2E Test Scenarios (AI)',
                  icon: state.isAiGenerating
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.science_outlined),
                ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: state.isRunning || state.workflow.steps.isEmpty
                    ? null
                    : () => notifier.runWorkflow(ref),
                icon: state.isRunning
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.play_arrow, size: 16),
                label: Text(state.isRunning ? 'Running...' : 'Run Workflow'),
              ),
            ],
          ),

          // ── Error ────────────────────────────────────────────────
          if (state.error != null) ...[
            const SizedBox(height: 10),
            _ErrorBanner(message: state.error!),
          ],
          if (state.aiError != null) ...[
            const SizedBox(height: 10),
            _ErrorBanner(message: state.aiError!),
          ],

          const SizedBox(height: 12),

          // ── Steps header ──────────────────────────────────────────
          Row(
            children: [
              Text(
                'Steps (${state.workflow.steps.length})',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              _AddStepButton(notifier: notifier, ref: ref),
            ],
          ),
          const Divider(height: 8),

          // ── Empty state ──────────────────────────────────────────
          if (state.workflow.steps.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.account_tree_outlined,
                        size: 48,
                        color: colorScheme.onSurface.withOpacity(0.25)),
                    const SizedBox(height: 12),
                    Text('No steps yet.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                               color: colorScheme.onSurface.withOpacity(0.4),
                             )),
                    const SizedBox(height: 4),
                    Text(
                      'Click "+ Add Step" to pick a request from your collection.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.35),
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ReorderableListView.builder(
                buildDefaultDragHandles: true,
                onReorder: (oldIndex, newIndex) {
                  if (newIndex > oldIndex) newIndex--;
                  notifier.reorderSteps(oldIndex, newIndex);
                },
                itemCount: state.workflow.steps.length,
                itemBuilder: (context, index) {
                  final step = state.workflow.steps[index];
                  final result = state.currentResults?.firstWhereOrNull(
                    (r) => r.stepId == step.stepId,
                  );

                  return _StepCard(
                    key: ValueKey(step.stepId),
                    step: step,
                    index: index,
                    result: result,
                    notifier: notifier,
                    ref: ref,
                  );
                },
              ),
            ),
          // --- TEST SCENARIOS SECTION ---
          if (state.generatedCases.isNotEmpty) ...[
            _TestScenariosSection(
              state: state,
              notifier: notifier,
              ref: ref,
            ),
          ],
        ],
      ),
    );
  }

  void _showAiConfigSheet(
    BuildContext context,
    WidgetRef ref,
    WorkflowNotifier notifier,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AIWorkflowConfigSheet(
        title: 'Auto Configure Workflow',
        description: 'Explain how data should flow (e.g., "Pass login token to Step 2 header").',
        hint: 'e.g. Extract "token" from Step 1 and inject into Step 2 Authorization.',
        label: 'Apply AI Rules',
        notifier: notifier,
        ref: ref,
        onGenerate: (instructions) => notifier.generateWithAi(ref, instructions),
      ),
    );
  }

  void _showAiTestSheet(
    BuildContext context,
    WidgetRef ref,
    WorkflowNotifier notifier,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AIWorkflowConfigSheet(
        title: 'Generate E2E Scenarios',
        description: 'AI will suggest end-to-end test scenarios for this chain.',
        hint: 'Optional: "Test for expired tokens and invalid user IDs..."',
        label: 'Generate Tests',
        notifier: notifier,
        ref: ref,
        onGenerate: (instructions) => notifier.generateTestsWithAi(ref, instructions),
      ),
    );
  }
}

// ── Add Step Button ──────────────────────────────────────────────────────────
class _AddStepButton extends ConsumerWidget {
  final WorkflowNotifier notifier;
  final WidgetRef ref;

  const _AddStepButton({required this.notifier, required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef outerRef) {
    final collection = outerRef.watch(collectionStateNotifierProvider) ?? {};
    final sequence = outerRef.watch(requestSequenceProvider);

    return OutlinedButton.icon(
      onPressed: collection.isEmpty
          ? null
          : () => _showPicker(context, collection, sequence),
      icon: const Icon(Icons.add, size: 16),
      label: const Text('Add Step'),
    );
  }

  void _showPicker(BuildContext context, dynamic collection, List<String> sequence) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Select a Request'),
        content: SizedBox(
          width: 320,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: sequence.length,
            itemBuilder: (_, i) {
              final id = sequence[i];
              final model = collection[id];
              if (model == null) return const SizedBox.shrink();
              final name = (model.name as String?)?.isNotEmpty == true
                  ? model.name as String
                  : model.httpRequestModel?.url ?? id;
              final method =
                  model.httpRequestModel?.method.abbr.toUpperCase() ?? '';
              return ListTile(
                leading: _MethodBadge(method: method),
                title: Text(name, overflow: TextOverflow.ellipsis),
                subtitle: Text(
                  model.httpRequestModel?.url ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11),
                ),
                onTap: () {
                  notifier.addStep(id, name);
                  Navigator.pop(ctx);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

// ── Step Card ────────────────────────────────────────────────────────────────
class _StepCard extends StatelessWidget {
  final WorkflowStep step;
  final int index;
  final WorkflowRunResult? result;
  final WorkflowNotifier notifier;
  final WidgetRef ref;

  const _StepCard({
    super.key,
    required this.step,
    required this.index,
    required this.result,
    required this.notifier,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasResult = result != null;
    final passed = result?.passed ?? false;

    Color? borderColor;
    if (hasResult) {
      borderColor = passed ? Colors.green.shade400 : colorScheme.error;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: borderColor ?? colorScheme.outlineVariant,
          width: hasResult ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step title row
            Row(
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                        fontSize: 10, color: colorScheme.onPrimaryContainer),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(step.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis),
                ),
                if (hasResult)
                  Icon(
                    passed ? Icons.check_circle : Icons.cancel,
                    color: passed ? Colors.green.shade600 : colorScheme.error,
                    size: 18,
                  ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  tooltip: 'Edit extract/inject rules',
                  onPressed: () =>
                      _showEditSheet(context, step, notifier),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: Icon(Icons.delete_outline,
                      size: 18, color: colorScheme.error),
                  tooltip: 'Remove step',
                  onPressed: () => notifier.removeStep(step.stepId),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 32), // Padding for Reorderable drag handle
              ],
            ),

            // Extract/Inject summary chips
            if (step.extract.isNotEmpty || step.inject.isNotEmpty) ...[
              const SizedBox(height: 6),
              Wrap(spacing: 6, runSpacing: 4, children: [
                for (final e in step.extract.entries)
                  _RuleChip(
                    label: '${e.value.startsWith('header.') ? 'Header' : 'Body'} (${e.key}) ← ${e.value.split('.').last}',
                    color: Colors.teal,
                    icon: Icons.download_outlined,
                  ),
                for (final e in step.inject.entries)
                  _RuleChip(
                    label: '${e.key.startsWith('header.') ? 'Header (${e.key.substring(7)})' : (e.key == 'body' ? 'Body' : 'URL')} ← ${e.value}',
                    color: Colors.deepPurple,
                    icon: Icons.upload_outlined,
                  ),
              ]),
            ],

            // Result row
            if (hasResult) ...[
              const SizedBox(height: 6),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  _StatusPill(
                    label: result!.expectedStatusCode != null 
                      ? 'Got ${result!.statusCode} (Exp ${result!.expectedStatusCode})'
                      : 'HTTP ${result!.statusCode ?? "—"}',
                    passed: passed,
                  ),
                  const SizedBox(width: 8),
                  if (result!.duration != null)
                    Text(
                      '${result!.duration!.inMilliseconds}ms',
                      style: TextStyle(
                          fontSize: 11,
                          color: colorScheme.onSurface.withOpacity(0.5)),
                    ),
                  const SizedBox(width: 8),
                  if (result!.extractedValues.isNotEmpty)
                    Text(
                      '✓ extracted: ${result!.extractedValues.keys.join(', ')}',
                      style: TextStyle(
                          fontSize: 11, color: Colors.teal.shade700),
                    ),
                ]),
              ),
              if (result!.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(result!.error!,
                      style: TextStyle(
                          fontSize: 11, color: colorScheme.error)),
                ),
            ],
          ],
        ),
      ),
    );
  }

  void _showEditSheet(
      BuildContext context, WorkflowStep step, WorkflowNotifier notifier) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _EditStepSheet(step: step, notifier: notifier),
    );
  }
}

// ── Edit Step Sheet ──────────────────────────────────────────────────────────
class _EditStepSheet extends StatefulWidget {
  final WorkflowStep step;
  final WorkflowNotifier notifier;
  const _EditStepSheet({required this.step, required this.notifier});

  @override
  State<_EditStepSheet> createState() => _EditStepSheetState();
}

class _EditStepSheetState extends State<_EditStepSheet> {
  late List<_ExtractRuleController> _extractRows;
  late List<_InjectRuleController> _injectRows;

  @override
  void initState() {
    super.initState();
    _extractRows = widget.step.extract.entries.map((e) {
      final type = e.value.startsWith('header.') ? 'Header' : 'Body';
      final path = e.value.startsWith('header.')
          ? e.value.substring(7)
          : (e.value.startsWith('body.') ? e.value.substring(5) : e.value);
      return _ExtractRuleController(
        variable: TextEditingController(text: e.key),
        path: TextEditingController(text: path),
        type: type,
      );
    }).toList();

    _injectRows = widget.step.inject.entries.map((e) {
      String type = 'Header';
      String target = '';
      if (e.key.startsWith('header.')) {
        type = 'Header';
        target = e.key.substring(7);
      } else if (e.key == 'body') {
        type = 'Body';
      } else if (e.key == 'url') {
        type = 'URL';
      }
      return _InjectRuleController(
        target: TextEditingController(text: target),
        value: TextEditingController(text: e.value),
        type: type,
      );
    }).toList();
  }

  @override
  void dispose() {
    for (final r in _extractRows) {
      r.variable.dispose();
      r.path.dispose();
    }
    for (final r in _injectRows) {
      r.target.dispose();
      r.value.dispose();
    }
    super.dispose();
  }

  void _save() {
    final extract = <String, String>{};
    for (final r in _extractRows) {
      final k = r.variable.text.trim();
      final v = r.path.text.trim();
      if (k.isNotEmpty && v.isNotEmpty) {
        extract[k] = '${r.type.toLowerCase()}.$v';
      }
    }
    final inject = <String, String>{};
    for (final r in _injectRows) {
      final k = r.target.text.trim();
      final v = r.value.text.trim();
      if (v.isNotEmpty) {
        if (r.type == 'Header' && k.isNotEmpty) {
          inject['header.$k'] = v;
        } else if (r.type == 'Body') {
          inject['body'] = v;
        } else if (r.type == 'URL') {
          inject['url'] = v;
        }
      }
    }
    widget.notifier
        .updateStep(widget.step.copyWith(extract: extract, inject: inject));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit: ${widget.step.name}',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Extract section
            _SectionLabel(
              icon: Icons.download_outlined,
              label: 'Extract from Response',
              hint: 'Pull values to use in later steps',
              color: Colors.teal,
            ),
            const SizedBox(height: 8),
            for (int i = 0; i < _extractRows.length; i++)
              _ExtractRow(
                row: _extractRows[i],
                onRemove: () => setState(() => _extractRows.removeAt(i)),
              ),
            TextButton.icon(
              onPressed: () => setState(() => _extractRows.add(_ExtractRuleController(
                    variable: TextEditingController(),
                    path: TextEditingController(),
                  ))),
              icon: const Icon(Icons.add, size: 14),
              label: const Text('Add row', style: TextStyle(fontSize: 12)),
            ),

            const SizedBox(height: 16),

            // Inject section
            _SectionLabel(
              icon: Icons.upload_outlined,
              label: 'Inject into Request',
              hint: 'Use {{variableName}} from previous steps',
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 8),
            for (int i = 0; i < _injectRows.length; i++)
              _InjectRow(
                row: _injectRows[i],
                onRemove: () => setState(() => _injectRows.removeAt(i)),
              ),
            TextButton.icon(
              onPressed: () => setState(() => _injectRows.add(_InjectRuleController(
                    target: TextEditingController(),
                    value: TextEditingController(),
                  ))),
              icon: const Icon(Icons.add, size: 14),
              label: const Text('Add row', style: TextStyle(fontSize: 12)),
            ),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _save,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AIWorkflowConfigSheet extends StatefulWidget {
  final String title;
  final String description;
  final String hint;
  final String label;
  final WorkflowNotifier notifier;
  final WidgetRef ref;
  final Future<void> Function(String) onGenerate;

  const _AIWorkflowConfigSheet({
    required this.title,
    required this.description,
    required this.hint,
    required this.label,
    required this.notifier,
    required this.ref,
    required this.onGenerate,
  });

  @override
  State<_AIWorkflowConfigSheet> createState() =>
      _AIWorkflowConfigSheetState();
}

class _AIWorkflowConfigSheetState extends State<_AIWorkflowConfigSheet> {
  final _controller = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await widget.onGenerate(_controller.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('AI processing complete.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.toString().replaceFirst('Exception: ', '');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology_outlined, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                widget.title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            widget.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            minLines: 2,
            maxLines: 4,
            autofocus: true,
            decoration: InputDecoration(
              hintText: widget.hint,
              labelText: 'Instructions',
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            _ErrorBanner(message: _error!),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _loading ? null : _generate,
              icon: _loading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.auto_awesome, size: 16),
              label: Text(_loading ? 'Generating...' : widget.label),
            ),
          ),
        ],
      ),
    );
  }
}


class _ExtractRuleController {
  final TextEditingController variable;
  final TextEditingController path;
  String type;
  _ExtractRuleController({
    required this.variable,
    required this.path,
    this.type = 'Body',
  });
}

class _InjectRuleController {
  final TextEditingController target;
  final TextEditingController value;
  String type;
  _InjectRuleController({
    required this.target,
    required this.value,
    this.type = 'Header',
  });
}

class _ExtractRow extends StatelessWidget {
  final _ExtractRuleController row;
  final VoidCallback onRemove;

  const _ExtractRow({required this.row, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: row.type,
                isExpanded: true,
                style: const TextStyle(fontSize: 11, color: Colors.teal),
                items: ['Body', 'Header']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => (row.type = v!),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: row.variable,
              decoration: const InputDecoration(
                hintText: 'Var name',
                isDense: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              ),
              style: const TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(width: 8),
          const Text('←', style: TextStyle(color: Colors.grey)),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextField(
              controller: row.path,
              decoration: const InputDecoration(
                hintText: 'json.path or Header-Name',
                isDense: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              ),
              style: const TextStyle(fontSize: 12),
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.remove_circle_outline, size: 18),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

class _InjectRow extends StatefulWidget {
  final _InjectRuleController row;
  final VoidCallback onRemove;
  const _InjectRow({required this.row, required this.onRemove});

  @override
  State<_InjectRow> createState() => _InjectRowState();
}

class _InjectRowState extends State<_InjectRow> {
  @override
  Widget build(BuildContext context) {
    final showTarget = widget.row.type == 'Header';
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: widget.row.type,
                isExpanded: true,
                style: const TextStyle(fontSize: 11, color: Colors.deepPurple),
                items: ['Header', 'Body', 'URL']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => widget.row.type = v!),
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (showTarget) ...[
            Expanded(
              child: TextField(
                controller: widget.row.target,
                decoration: const InputDecoration(
                  hintText: 'Header Name',
                  isDense: true,
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                ),
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
          ],
          const Text('←', style: TextStyle(color: Colors.grey)),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextField(
              controller: widget.row.value,
              decoration: const InputDecoration(
                hintText: 'Value (supports {{var}})',
                isDense: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              ),
              style: const TextStyle(fontSize: 12),
            ),
          ),
          IconButton(
            onPressed: widget.onRemove,
            icon: const Icon(Icons.remove_circle_outline, size: 18),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

// ── Shared small widgets ─────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final String hint;
  final Color color;
  const _SectionLabel(
      {required this.icon,
      required this.label,
      required this.hint,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 14, color: color),
      const SizedBox(width: 4),
      Text(label,
          style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 13, color: color)),
      const SizedBox(width: 6),
      Text(hint,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              )),
    ]);
  }
}

class _MethodBadge extends StatelessWidget {
  final String method;
  const _MethodBadge({required this.method});

  Color _color() {
    switch (method) {
      case 'GET': return Colors.green.shade600;
      case 'POST': return Colors.blue.shade600;
      case 'PUT': return Colors.orange.shade700;
      case 'PATCH': return Colors.teal.shade600;
      case 'DELETE': return Colors.red.shade600;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _color().withOpacity(0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: _color().withOpacity(0.4)),
      ),
      child: Text(method,
          style: TextStyle(
              fontSize: 10, color: _color(), fontWeight: FontWeight.bold)),
    );
  }
}

class _RuleChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  const _RuleChip(
      {required this.label, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 10, color: color),
        const SizedBox(width: 3),
        Text(label,
            style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.w500)),
      ]),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final bool passed;
  const _StatusPill({required this.label, required this.passed});

  @override
  Widget build(BuildContext context) {
    final color =
        passed ? Colors.green.shade600 : Theme.of(context).colorScheme.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 10, color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(children: [
        Icon(Icons.error_outline,
            color: colorScheme.onErrorContainer, size: 16),
        const SizedBox(width: 8),
        Expanded(
            child: Text(message,
                style: TextStyle(color: colorScheme.onErrorContainer))),
      ]),
    );
  }
}

class _TestScenariosSection extends StatelessWidget {
  final WorkflowState state;
  final WorkflowNotifier notifier;
  final WidgetRef ref;

  const _TestScenariosSection({
    required this.state,
    required this.notifier,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            const Spacer(),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 150,
          child: ListView.separated(
            itemCount: state.generatedCases.length,
            separatorBuilder: (_, __) => const SizedBox(height: 4),
            itemBuilder: (context, index) {
              final tc = state.generatedCases[index];
              return _TestCaseTile(
                testCase: tc,
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _TestCaseTile extends StatelessWidget {
  final dynamic testCase;

  const _TestCaseTile({
    required this.testCase,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.description_outlined, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  testCase.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  testCase.description,
                  style: TextStyle(
                    fontSize: 11,
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (testCase.initialVariables.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Seeds: ${testCase.initialVariables.length}',
                style: TextStyle(
                  fontSize: 10,
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
