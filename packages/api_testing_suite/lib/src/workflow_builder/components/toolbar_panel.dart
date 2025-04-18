import 'package:api_testing_suite/src/workflow_builder/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/widgets/widgets.dart';
import '../models/workflow_execution_state.dart';
class ToolbarPanel extends ConsumerWidget {
  final bool connectionMode;
  final WorkflowExecutionState executionState;
  final WorkflowExecutionControl executionControl;
  final VoidCallback onConnectionModeToggle;

  const ToolbarPanel({
    super.key,
    required this.connectionMode,
    required this.executionState,
    required this.executionControl,
    required this.onConnectionModeToggle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 56,
      color: const Color(0xFF212121),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          ToggleActionButton(
            icon: Icons.cable,
            label: 'Connection Mode',
            isActive: connectionMode,
            onPressed: onConnectionModeToggle,
          ),
          const SizedBox(width: 16),
          Container(width: 1, height: 24, color: Colors.grey.shade700),
          const SizedBox(width: 16),
          ExecutionControls(
            executionState: executionState,
            executionControl: executionControl,
          ),
          const Spacer(),
          if (executionState.isRunning ||
              executionState.isPaused ||
              executionState.isCompleted)
            StatusIndicator(
              icon: StatusIndicatorUtils.getStatusIcon(executionState),
              color: StatusIndicatorUtils.getStatusColor(executionState),
              text: StatusIndicatorUtils.getStatusText(executionState),
            ),
        ],
      ),
    );
  }
}

class ExecutionControls extends StatelessWidget {
  final WorkflowExecutionState executionState;
  final WorkflowExecutionControl executionControl;


  const ExecutionControls({
    super.key,
    required this.executionState,
    required this.executionControl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!executionState.isRunning && !executionState.isPaused)
          IconButton(
            icon: const Icon(Icons.play_arrow),
            color: Colors.green,
            onPressed: () {
              executionControl.startExecution();
              },
            tooltip: 'Run Workflow',
          )
        else if (executionState.isRunning)
          IconButton(
            icon: const Icon(Icons.pause),
            color: Colors.amber,
            onPressed: executionControl.pauseExecution,
            tooltip: 'Pause Execution',
          )
        else if (executionState.isPaused)
          IconButton(
            icon: const Icon(Icons.play_arrow),
            color: Colors.green,
            onPressed: executionControl.resumeExecution,
            tooltip: 'Resume Execution',
          ),
        if (executionState.isRunning || executionState.isPaused)
          IconButton(
            icon: const Icon(Icons.stop),
            color: Colors.red,
            onPressed: executionControl.stopExecution,
            tooltip: 'Stop Execution',
          ),
        // if (executionState.isCompleted || executionState.hasError)
        //   IconButton(
        //     icon: const Icon(Icons.refresh),
        //     color: Colors.blue,
        //     onPressed: executionControl.rese,
        //     tooltip: 'Reset Workflow',
        //   ),
      ],
    );
  }
}

class StatusIndicatorUtils {
  static Color getStatusColor(WorkflowExecutionState state) {
    if (state.isRunning) return Colors.blue;
    if (state.isPaused) return Colors.amber;
    if (state.isCompleted) return Colors.green;
    if (state.hasError) return Colors.red;
    return Colors.grey;
  }

  static IconData getStatusIcon(WorkflowExecutionState state) {
    if (state.isRunning) return Icons.play_arrow;
    if (state.isPaused) return Icons.pause;
    if (state.isCompleted) return Icons.check_circle;
    if (state.hasError) return Icons.error;
    return Icons.circle_outlined;
  }

  static String getStatusText(WorkflowExecutionState state) {
    if (state.isRunning) return 'Running';
    if (state.isPaused) return 'Paused';
    if (state.isCompleted) return 'Completed';
    if (state.hasError) return 'Error';
    return 'Idle';
  }
}
