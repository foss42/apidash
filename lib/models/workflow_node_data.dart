/// Node type for workflow builder POC.
enum WorkflowNodeType {
  start,
  request,
  variable,
  condition,
  transform,
  delay,
  loop,
  end,
}

/// Data carried by each node in the workflow canvas.
class WorkflowNodeData {
  const WorkflowNodeData({
    required this.nodeType,
    this.label = '',
    this.linkedRequestId,
    this.linkedCollectionId,
    this.variableKey,
    this.variableValue,
    this.variableSource,
    this.requestVariableValues,
    this.conditionExpression,
    this.transformScript,
    this.delayMs,
    this.loopExpression,
  });

  final WorkflowNodeType nodeType;
  final String label;
  final String? linkedRequestId;
  final String? linkedCollectionId;
  final String? variableKey;
  final String? variableValue;
  final String? variableSource;
  final Map<String, String>? requestVariableValues;
  final String? conditionExpression;
  final String? transformScript;
  final int? delayMs;
  final String? loopExpression;

  Map<String, dynamic> toJson() => {
        'nodeType': nodeType.name,
        'label': label,
        if (linkedRequestId != null) 'linkedRequestId': linkedRequestId,
        if (linkedCollectionId != null) 'linkedCollectionId': linkedCollectionId,
        if (variableKey != null) 'variableKey': variableKey,
        if (variableValue != null) 'variableValue': variableValue,
        if (variableSource != null) 'variableSource': variableSource,
        if (requestVariableValues != null)
          'requestVariableValues': requestVariableValues,
        if (conditionExpression != null)
          'conditionExpression': conditionExpression,
        if (transformScript != null) 'transformScript': transformScript,
        if (delayMs != null) 'delayMs': delayMs,
        if (loopExpression != null) 'loopExpression': loopExpression,
      };

  factory WorkflowNodeData.fromJson(Map<String, dynamic> json) {
    final typeStr = json['nodeType'] as String? ?? 'start';
    WorkflowNodeType type;
    switch (typeStr) {
      case 'request':
        type = WorkflowNodeType.request;
        break;
      case 'end':
        type = WorkflowNodeType.end;
        break;
      case 'condition':
        type = WorkflowNodeType.condition;
        break;
      case 'variable':
        type = WorkflowNodeType.variable;
        break;
      case 'transform':
        type = WorkflowNodeType.transform;
        break;
      case 'delay':
        type = WorkflowNodeType.delay;
        break;
      case 'loop':
        type = WorkflowNodeType.loop;
        break;
      default:
        type = WorkflowNodeType.start;
    }
    return WorkflowNodeData(
      nodeType: type,
      label: json['label'] as String? ?? '',
      linkedRequestId: json['linkedRequestId'] as String?,
      linkedCollectionId: json['linkedCollectionId'] as String?,
      variableKey: json['variableKey'] as String?,
      variableValue: json['variableValue'] as String?,
      variableSource: json['variableSource'] as String?,
      requestVariableValues:
          (json['requestVariableValues'] as Map?)
              ?.map(
                (key, value) => MapEntry(
                  key.toString(),
                  value?.toString() ?? '',
                ),
              )
              .cast<String, String>(),
      conditionExpression: json['conditionExpression'] as String?,
      transformScript: json['transformScript'] as String?,
      delayMs: (json['delayMs'] as num?)?.toInt(),
      loopExpression: json['loopExpression'] as String?,
    );
  }

  WorkflowNodeData copyWith({
    WorkflowNodeType? nodeType,
    String? label,
    String? linkedRequestId,
    String? linkedCollectionId,
    String? variableKey,
    String? variableValue,
    String? variableSource,
    Map<String, String>? requestVariableValues,
    String? conditionExpression,
    String? transformScript,
    int? delayMs,
    String? loopExpression,
  }) =>
      WorkflowNodeData(
        nodeType: nodeType ?? this.nodeType,
        label: label ?? this.label,
        linkedRequestId: linkedRequestId ?? this.linkedRequestId,
        linkedCollectionId: linkedCollectionId ?? this.linkedCollectionId,
        variableKey: variableKey ?? this.variableKey,
        variableValue: variableValue ?? this.variableValue,
        variableSource: variableSource ?? this.variableSource,
        requestVariableValues: requestVariableValues ?? this.requestVariableValues,
        conditionExpression: conditionExpression ?? this.conditionExpression,
        transformScript: transformScript ?? this.transformScript,
        delayMs: delayMs ?? this.delayMs,
        loopExpression: loopExpression ?? this.loopExpression,
      );
}
