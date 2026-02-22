import '../consts.dart';

class MqttMessageModel {
  final String topic;
  final String payload;
  final DateTime timestamp;
  final bool isPublished;
  final MqttQos qos;
  final bool retained;

  const MqttMessageModel({
    required this.topic,
    required this.payload,
    required this.timestamp,
    required this.isPublished,
    this.qos = MqttQos.atMostOnce,
    this.retained = false,
  });
}
