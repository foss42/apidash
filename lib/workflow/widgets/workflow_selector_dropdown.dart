import 'package:apidash/consts.dart';
import 'package:apidash/workflow/consts.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/workflow/providers/workflow_providers.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum _WorkflowMenuAction { rename, delete }

class WorkflowSelectorDropdown extends ConsumerWidget {
  const WorkflowSelectorDropdown({
    super.key,
    this.readOnly = false,
  });

  final bool readOnly;

  static const _newValue = '__new__';

  Future<void> _createWorkflow(WidgetRef ref) async {
    await ref.read(workflowCatalogProvider.notifier).createWorkflow();
  }

  Future<void> _renameWorkflow(
    BuildContext context,
    WidgetRef ref,
    WorkflowSummary workflow,
  ) async {
    showRenameDialog(
      context,
      kLabelRenameWorkflow,
      workflow.name,
      (newName) async {
        if (newName.isEmpty || newName == workflow.name) {
          return;
        }
        await ref
            .read(workflowCatalogProvider.notifier)
            .renameWorkflow(workflow.id, newName);
      },
    );
  }

  Future<void> _deleteWorkflow(
    BuildContext context,
    WidgetRef ref,
    WorkflowSummary workflow,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(kLabelDeleteWorkflow),
        content: Text('Delete "${workflow.name}"? This cannot be undone.'),
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
    if (confirmed != true) {
      return;
    }
    await ref
        .read(workflowCatalogProvider.notifier)
        .deleteWorkflow(workflow.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workflowsAsync = ref.watch(workflowCatalogProvider);
    final selectedId = ref.watch(selectedWorkflowIdStateProvider);

    return workflowsAsync.when(
      loading: () => const SizedBox(
        height: 40,
        child: Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (error, _) => Text(error.toString()),
      data: (workflows) {
        if (workflows.isEmpty) {
          if (readOnly) {
            return Text(
              'No workflows',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            );
          }
          return OutlinedButton.icon(
            onPressed: () => _createWorkflow(ref),
            icon: const Icon(Icons.add, size: 18),
            label: const Text(kLabelNewWorkflow),
          );
        }

        WorkflowSummary? selected;
        for (final workflow in workflows) {
          if (workflow.id == selectedId) {
            selected = workflow;
            break;
          }
        }
        selected ??= workflows.first;

        return Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                value: selected.id,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final workflow in workflows)
                    DropdownMenuItem(
                      value: workflow.id,
                      child: Text(
                        workflow.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  if (!readOnly)
                    const DropdownMenuItem(
                      value: _newValue,
                      child: Row(
                        children: [
                          Icon(Icons.add, size: 18),
                          SizedBox(width: 8),
                          Text(kLabelNewWorkflow),
                        ],
                      ),
                    ),
                ],
                onChanged: (value) async {
                  if (value == null) {
                    return;
                  }
                  if (value == _newValue) {
                    if (readOnly) {
                      return;
                    }
                    await _createWorkflow(ref);
                    return;
                  }
                  ref.read(selectedWorkflowIdStateProvider.notifier).state =
                      value;
                  await ref.read(activeWorkflowProvider.notifier).load(value);
                },
              ),
            ),
            if (!readOnly) ...[
              kHSpacer4,
              PopupMenuButton<_WorkflowMenuAction>(
                tooltip: 'Workflow options',
                icon: const Icon(Icons.more_vert),
                onSelected: (action) async {
                  switch (action) {
                    case _WorkflowMenuAction.rename:
                      await _renameWorkflow(context, ref, selected!);
                    case _WorkflowMenuAction.delete:
                      await _deleteWorkflow(context, ref, selected!);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: _WorkflowMenuAction.rename,
                    child: Text(kLabelRenameWorkflow),
                  ),
                  PopupMenuItem(
                    value: _WorkflowMenuAction.delete,
                    child: Text(kLabelDeleteWorkflow),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}
