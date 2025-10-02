import '../constants.dart';

class ChatAction {
  final String action;
  final String target;
  final String field;
  final String? path;
  final dynamic value;
  final ChatActionType actionType; // enum representation
  final ChatActionTarget targetType; // enum representation

  const ChatAction({
    required this.action,
    required this.target,
    this.field = '', // Default to empty string
    this.path,
    this.value,
    required this.actionType,
    required this.targetType,
  });

  factory ChatAction.fromJson(Map<String, dynamic> json) {
    final actionStr = json['action'] as String? ?? 'other';
    final targetStr = json['target'] as String? ?? 'httpRequestModel';
    return ChatAction(
      action: actionStr,
      target: targetStr,
      field: json['field'] as String? ?? '',
      path: json['path'] as String?,
      value: json['value'],
      actionType: chatActionTypeFromString(actionStr),
      targetType: chatActionTargetFromString(targetStr),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'target': target,
      'field': field,
      'path': path,
      'value': value,
      'action_type': actionType.text,
      'target_type': targetType.name,
    };
  }
}
