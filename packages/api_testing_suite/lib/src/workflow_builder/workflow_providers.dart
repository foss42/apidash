import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workflow_model.dart';
import '../models/workflow_execution_state.dart';
import 'workflows_notifier.dart';

final workflowsNotifierProvider = StateNotifierProvider<WorkflowsNotifier, List<WorkflowModel>>((ref) {
  return WorkflowsNotifier();
});

final currentWorkflowProvider = StateProvider<String?>((ref) => null);

final workflowExecutionStateProvider = StateProvider<WorkflowExecutionState>((ref) {
  return const WorkflowExecutionState();
});
