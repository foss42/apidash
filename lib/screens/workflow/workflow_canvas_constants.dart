import 'package:apidash/models/workflow_node_data.dart';
import 'package:intl/intl.dart';

const double kRequestNodeWidth = 310;
const double kRequestNodeHeight = 178;
const double kRequestPortSuccessY = 108;
const double kRequestPortSendY = 118;
const double kRequestPortFailY = 128;

final DateFormat kWorkflowRunTimeOnly = DateFormat('HH:mm:ss');

String workflowDefaultNodeLabel(WorkflowNodeType type) {
  switch (type) {
    case WorkflowNodeType.start:
      return 'Start';
    case WorkflowNodeType.request:
      return 'Request';
    case WorkflowNodeType.variable:
      return 'Variable';
    case WorkflowNodeType.end:
      return 'Stop';
    case WorkflowNodeType.condition:
      return 'Condition';
    case WorkflowNodeType.transform:
      return 'Transform';
    case WorkflowNodeType.delay:
      return 'Delay';
    case WorkflowNodeType.loop:
      return 'Loop';
  }
}
