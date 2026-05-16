import 'package:apidash/services/workflow_execution_service.dart';

class WorkflowRunDelegateBridge implements WorkflowExecutionDelegate {
  const WorkflowRunDelegateBridge({
    required this.runRequestById,
  });

  final Future<WorkflowRequestResult> Function({
    required String nodeId,
    required String requestId,
    required WorkflowExecutionContext context,
  }) runRequestById;

  @override
  Future<WorkflowRequestResult> runRequest({
    required String nodeId,
    required String requestId,
    required WorkflowExecutionContext context,
  }) =>
      runRequestById(
        nodeId: nodeId,
        requestId: requestId,
        context: context,
      );
}
