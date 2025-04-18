import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workflow_execution_state.dart';
import '../workflow_providers.dart';
import '../models/log_entry.dart';

class LogsViewer extends ConsumerWidget {
  final String workflowId;

  const LogsViewer({
    Key? key,
    required this.workflowId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final executionState = ref.watch(workflowExecutionStateProvider);
    final logs = ref.watch(workflowLogsProvider(workflowId));

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[800]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(executionState),
          const SizedBox(height: 8),
          Expanded(
            child: logs.isEmpty
                ? _buildEmptyState()
                : _buildLogsList(logs.cast<LogEntry>()),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(WorkflowExecutionState executionState) {
    return Row(
      children: [
        const Icon(
          Icons.history,
          color: Colors.blue,
          size: 20,
        ),
        const SizedBox(width: 8),
        const Text(
          'Execution Logs',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const Spacer(),
        if (executionState.isRunning)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.blue, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  'LIVE',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        if (executionState.isCompleted)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.green, width: 1),
            ),
            child: const Text(
              'COMPLETED',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 40,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            'No execution logs yet',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start the workflow execution to see logs',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogsList(List<LogEntry> logs) {
    return ListView.builder(
      itemCount: logs.length,
      reverse: true,
      itemBuilder: (context, index) {
        final log = logs[logs.length - 1 - index];
        return _buildLogItem(log);
      },
    );
  }

  Widget _buildLogItem(LogEntry log) {
    Color getLogColor() {
      switch (log.level) {
        case LogLevel.debug:
          return Colors.grey;
        case LogLevel.info:
          return Colors.blue;
        case LogLevel.success:
          return Colors.green;
        case LogLevel.warning:
          return Colors.orange;
        case LogLevel.error:
          return Colors.red;
      }
    }

    IconData getLogIcon() {
      switch (log.level) {
        case LogLevel.debug:
          return Icons.code;
        case LogLevel.info:
          return Icons.info_outline;
        case LogLevel.success:
          return Icons.check_circle_outline;
        case LogLevel.warning:
          return Icons.warning_amber_outlined;
        case LogLevel.error:
          return Icons.error_outline;
      }
    }

    final color = getLogColor();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              getLogIcon(),
              size: 16,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      log.nodeId != null
                          ? 'Node ${log.nodeId!.substring(0, 4)}'
                          : 'Workflow',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatTimestamp(log.timestamp),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  log.message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
                if (log.details != null) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Colors.grey[850]!,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      log.details!,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    if (now.difference(timestamp).inDays == 0) {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}';
    } else {
      return '${timestamp.month.toString().padLeft(2, '0')}/${timestamp.day.toString().padLeft(2, '0')} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}
