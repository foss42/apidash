import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'mqtt_topic_model.freezed.dart';

part 'mqtt_topic_model.g.dart';

@freezed
class MQTTTopicModel with _$MQTTTopicModel {
  const factory MQTTTopicModel({
    required String name,
    required int qos,
    required bool subscribe,
    required String description,
  }) = _MQTTTopicModel;

  factory MQTTTopicModel.fromJson(Map<String, dynamic> json) =>
      _$MQTTTopicModelFromJson(json);
}

const kMQTTTopicEmptyModel =
    MQTTTopicModel(name: "", qos: 0, subscribe: false, description: "");
