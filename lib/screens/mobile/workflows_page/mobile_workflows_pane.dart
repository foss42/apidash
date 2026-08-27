import 'package:apidash/consts.dart';
import 'package:apidash/workflow/providers/workflow_providers.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Mobile drawer list of workflows (view + select only).
class MobileWorkflowsPane extends ConsumerWidget {
  const MobileWorkflowsPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workflowsAsync = ref.watch(workflowCatalogProvider);
    final selectedId = ref.watch(selectedWorkflowIdStateProvider);

    return Padding(
      padding: kPt8l4 + kPb70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: kPh8,
            child: Text(
              kLabelWorkflows,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          kVSpacer10,
          Expanded(
            child: workflowsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text(error.toString())),
              data: (workflows) {
                if (workflows.isEmpty) {
                  return Center(
                    child: Text(
                      'No workflows',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.paddingOf(context).bottom,
                    right: 8,
                  ),
                  itemCount: workflows.length,
                  itemBuilder: (context, index) {
                    final workflow = workflows[index];
                    final selected = workflow.id == selectedId;
                    return ListTile(
                      selected: selected,
                      title: Text(
                        workflow.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${workflow.stepCount} steps',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      onTap: () async {
                        ref
                            .read(selectedWorkflowIdStateProvider.notifier)
                            .state = workflow.id;
                        await ref
                            .read(activeWorkflowProvider.notifier)
                            .load(workflow.id);
                        kWorkflowScaffoldKey.currentState?.closeDrawer();
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
