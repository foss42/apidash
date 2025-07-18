import 'package:freezed_annotation/freezed_annotation.dart';

part 'mqtt_request_model.freezed.dart';
part 'mqtt_request_model.g.dart';

@freezed
class MQTTRequestModel with _$MQTTRequestModel {
  const factory MQTTRequestModel({
    @Default("") String brokerUrl,
    @Default(1883) int port,
    @Default("") String clientId,
    @Default("") String username,
    @Default("") String password,
    @Default(60) int keepAlive,
    @Default(false) bool cleanSession,
    @Default(3) int connectTimeout,
    @Default([]) List<MQTTTopicModel> topics,
    @Default("") String publishTopic,
    @Default("") String publishPayload,
    @Default(0) int publishQos,
    @Default(false) bool publishRetain,
  }) = _MQTTRequestModel;

  factory MQTTRequestModel.fromJson(Map<String, Object?> json) =>
      _$MQTTRequestModelFromJson(json);
}

@freezed
class MQTTTopicModel with _$MQTTTopicModel {
  const factory MQTTTopicModel({
    required String topic,
    @Default(0) int qos,
    @Default(false) bool subscribe,
    @Default("") String description,
  }) = _MQTTTopicModel;

  factory MQTTTopicModel.fromJson(Map<String, Object?> json) =>
      _$MQTTTopicModelFromJson(json);
}

const kMQTTRequestEmptyModel = MQTTRequestModel();
const kMQTTTopicEmptyModel = MQTTTopicModel(topic: ""); 