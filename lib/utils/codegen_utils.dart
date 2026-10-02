import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/dashbot/constants.dart';

extension APITypeCodegen on APIType {
  /// Native code generation only exists for HTTP; every other type, current
  /// or future, is handed to DashBot.
  bool get hasNativeCodegen => this == APIType.rest;

  String get codegenViaDashbotMessage =>
      "Code for $label requests is generated with DashBot.";

  ChatMessageType get dashbotCodegenTask => switch (this) {
    APIType.websocket => ChatMessageType.generateWsCode,
    APIType.mqtt => ChatMessageType.generateMqttCode,
    _ => ChatMessageType.generateCode,
  };
}
