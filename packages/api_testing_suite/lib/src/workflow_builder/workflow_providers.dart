import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/models.dart';
import 'widgets/logs_viewer.dart';
import 'models/workflow_model.dart';
import 'models/workflow_execution_state.dart';
import 'workflows_notifier.dart';

final workflowsNotifierProvider =
    StateNotifierProvider<WorkflowsNotifier, List<WorkflowModel>>((ref) {
  return WorkflowsNotifier();
});

final currentWorkflowProvider = StateProvider<String?>((ref) => null);

final selectedNodeIdProvider = StateProvider<String?>((ref) => null);

final activeWorkflowProvider = Provider<WorkflowModel?>((ref) {
  final currentWorkflowId = ref.watch(currentWorkflowProvider);
  final workflows = ref.watch(workflowsNotifierProvider);

  if (currentWorkflowId == null) return null;

  return workflows.firstWhere(
    (workflow) => workflow.id == currentWorkflowId,
    orElse: () => throw Exception('Workflow not found'),
  );
});

final workflowExecutionStateProvider =
    StateProvider<WorkflowExecutionState>((ref) {
  return const WorkflowExecutionState();
});

final connectionModeProvider = StateProvider<bool>((ref) => false);

final workflowLogsProvider = Provider.family<List<WorkflowLogEntry>, String>((ref, workflowId) {
  final workflows = ref.watch(workflowsNotifierProvider);
  final workflowModel = workflows.firstWhere(
    (workflow) => workflow.id == workflowId,
    orElse: () => throw Exception('Workflow not found'),
  );
  
  final executionState = ref.watch(workflowExecutionStateProvider);
  
  final logs = <WorkflowLogEntry>[];
  
  logs.add(
    WorkflowLogEntry(
      message: 'Workflow initialized',
      level: LogLevel.info,
      timestamp: workflowModel.createdAt,
    ),
  );
  
  if (executionState.startTime != null) {
    logs.add(
      WorkflowLogEntry(
        message: 'Execution started',
        level: LogLevel.info,
        timestamp: executionState.startTime,
      ),
    );
    
    for (final nodeId in executionState.executedNodeIds) {
      final node = workflowModel.nodes.firstWhere(
        (n) => n.id == nodeId,
        orElse: () => throw Exception('Node not found'),
      );
      
      final result = executionState.executionResults[nodeId];
      final success = result != null && result['status'] == 'success';
      
      logs.add(
        WorkflowLogEntry(
          message: success 
              ? 'Node execution completed successfully' 
              : 'Node execution failed',
          level: success ? LogLevel.success : LogLevel.error,
          nodeId: nodeId,
          details: node.nodeType == NodeType.request
              ? 'URL: ${node.requestModel?.url ?? "No URL"}\nMethod: ${node.requestModel?.method ?? "GET"}'
              : null,
        ),
      );
    }
    
    if (executionState.currentNodeId != null) {
      logs.add(
        WorkflowLogEntry(
          message: 'Node execution in progress',
          level: LogLevel.info,
          nodeId: executionState.currentNodeId,
        ),
      );
    }
    
    if (executionState.isCompleted && executionState.endTime != null) {
      logs.add(
        WorkflowLogEntry(
          message: 'Workflow execution completed',
          level: LogLevel.success,
          timestamp: executionState.endTime,
        ),
      );
    }
    
    if (executionState.isPaused) {
      logs.add(
        WorkflowLogEntry(
          message: 'Workflow execution paused',
          level: LogLevel.warning,
        ),
      );
    }
    
    if (executionState.hasError) {
      logs.add(
        WorkflowLogEntry(
          message: 'Workflow execution failed: ${executionState.errorMessage}',
          level: LogLevel.error,
        ),
      );
    }
  }
  
  return logs;
});

final workflowExecutionControlProvider =
    Provider<WorkflowExecutionControl>((ref) {
  final notifier = ref.watch(workflowsNotifierProvider.notifier);
  final currentId = ref.watch(currentWorkflowProvider);

  return WorkflowExecutionControl(
    startExecution: () {
      if (currentId != null) {
        notifier.startExecution(
            currentId,
            (state) => ref.read(workflowExecutionStateProvider.notifier).state =
                state);
      }
    },
    pauseExecution: () {
      if (currentId != null) {
        notifier.pauseExecution(currentId);
      }
    },
    resumeExecution: () {
      if (currentId != null) {
        notifier.resumeExecution(currentId);
      }
    },
    stopExecution: () {
      if (currentId != null) {
        notifier.stopExecution(currentId);
      }
    },
  );
});

class WorkflowExecutionControl {
  final VoidCallback startExecution;
  final VoidCallback pauseExecution;
  final VoidCallback resumeExecution;
  final VoidCallback stopExecution;

  const WorkflowExecutionControl({
    required this.startExecution,
    required this.pauseExecution,
    required this.resumeExecution,
    required this.stopExecution,
  });
}
