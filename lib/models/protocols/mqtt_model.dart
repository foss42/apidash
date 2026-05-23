import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/models/protocols/base_protocol_model.dart';
import 'websocket_model.dart';

part 'mqtt_model.freezed.dart';
part 'mqtt_model.g.dart';

@freezed
abstract class MQTTRequestModel
    with _$MQTTRequestModel
    implements ProtocolModel {
  const factory MQTTRequestModel({
    required String brokerUrl,
    @Default(1883) int port,
    String? clientId,
    String? username,
    String? password,
    @Default(MQTTVersion.v5) MQTTVersion version,
    @Default([]) List<NameValueModel> subscribedTopics,
    @Default([]) List<bool> isTopicEnabledList,
    @Default(false) bool useTLS,
    @Default(false) bool useWebSocket,
    @Default(0) int qos,
    @Default([]) List<WebSocketMessage> messageHistory,
    @Default("") String message,
    @Default("") String publishTopic,
  }) = _MQTTRequestModel;

  factory MQTTRequestModel.fromJson(Map<String, dynamic> json) =>
      _$MQTTRequestModelFromJson(json);
}

/// Enum for MQTT version support.
enum MQTTVersion { v3, v3_1_1, v5 }
