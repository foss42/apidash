import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';

@immutable
class MQTTResponseModel {
  const MQTTResponseModel({
    this.topic,
    this.mqttHeader,
    this.payload,
    this.lwRetain,
    this.time,
  });

  final String? topic;
  final MqttHeader? mqttHeader;
  final String? payload;
  final bool? lwRetain;
  final Duration? time;

  factory MQTTResponseModel.fromJson(Map<String, dynamic> data) {
    Duration? timeElapsed;
    final topic = data["topic"] as String?;
    final mqttHeader = data["mqttHeader"] as MqttHeader?;
    final payload = data["payload"] as String?;
    final lwRetain = data["lwRetain"] as bool?;
    final time = data["time"] as int?;

    if (time != null) {
      timeElapsed = Duration(microseconds: time);
    }
    return MQTTResponseModel(
      topic: topic,
      mqttHeader: mqttHeader,
      payload: payload,
      lwRetain: lwRetain,
      time: timeElapsed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "topic": topic,
      "mqttHeader": mqttHeader,
      "payload": payload,
      "lwRetain": lwRetain,
      "time": time?.inMicroseconds,
    };
  }

  @override
  String toString() {
    return [
      "Topic: $topic",
      "MQTT Header: $mqttHeader",
      "Payload: $payload",
      "Last Will Retain: $lwRetain",
      "Response Time: $time",
    ].join("\n");
  }

  @override
  bool operator ==(Object other) {
    return other is MQTTResponseModel &&
        other.runtimeType == runtimeType &&
        other.topic == topic &&
        other.mqttHeader == mqttHeader &&
        other.payload == payload &&
        other.lwRetain == lwRetain &&
        other.time == time;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      topic,
      mqttHeader,
      payload,
      lwRetain,
      time,
    );
  }
}
