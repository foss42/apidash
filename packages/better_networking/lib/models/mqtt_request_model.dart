import 'package:json_annotation/json_annotation.dart';
import '../consts.dart';

part 'mqtt_request_model.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class MqttTopicModel {
  final String topic;
  final MqttQos qos;
  final String description;

  const MqttTopicModel({
    this.topic = "",
    this.qos = MqttQos.atMostOnce,
    this.description = "",
  });

  factory MqttTopicModel.fromJson(Map<String, dynamic> json) =>
      _$MqttTopicModelFromJson(json);

  Map<String, dynamic> toJson() => _$MqttTopicModelToJson(this);

  MqttTopicModel copyWith({
    String? topic,
    MqttQos? qos,
    String? description,
  }) {
    return MqttTopicModel(
      topic: topic ?? this.topic,
      qos: qos ?? this.qos,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MqttTopicModel &&
          runtimeType == other.runtimeType &&
          topic == other.topic &&
          qos == other.qos &&
          description == other.description;

  @override
  int get hashCode => Object.hash(topic, qos, description);

  @override
  String toString() =>
      'MqttTopicModel(topic: $topic, qos: $qos, description: $description)';
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class MqttRequestModel {
  final String url;
  final int port;
  final String clientId;
  final MqttVersion mqttVersion;
  final String? username;
  final String? password;
  final int keepAlive;
  final bool cleanSession;
  final String? lastWillTopic;
  final String? lastWillMessage;
  final MqttQos lastWillQos;
  final bool lastWillRetain;
  final List<MqttTopicModel> topics;

  const MqttRequestModel({
    this.url = "",
    this.port = 1883,
    this.clientId = "",
    this.mqttVersion = MqttVersion.v311,
    this.username,
    this.password,
    this.keepAlive = 60,
    this.cleanSession = true,
    this.lastWillTopic,
    this.lastWillMessage,
    this.lastWillQos = MqttQos.atMostOnce,
    this.lastWillRetain = false,
    this.topics = const <MqttTopicModel>[],
  });

  factory MqttRequestModel.fromJson(Map<String, dynamic> json) =>
      _$MqttRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$MqttRequestModelToJson(this);

  bool get hasAuth =>
      username != null &&
      username!.isNotEmpty &&
      password != null &&
      password!.isNotEmpty;

  bool get hasLastWill =>
      lastWillTopic != null && lastWillTopic!.isNotEmpty;

  bool get hasTopics => topics.isNotEmpty;

  String get hostPort => port != 1883 ? "$url:$port" : url;

  MqttRequestModel copyWith({
    String? url,
    int? port,
    String? clientId,
    MqttVersion? mqttVersion,
    Object? username = _sentinel,
    Object? password = _sentinel,
    int? keepAlive,
    bool? cleanSession,
    Object? lastWillTopic = _sentinel,
    Object? lastWillMessage = _sentinel,
    MqttQos? lastWillQos,
    bool? lastWillRetain,
    List<MqttTopicModel>? topics,
  }) {
    return MqttRequestModel(
      url: url ?? this.url,
      port: port ?? this.port,
      clientId: clientId ?? this.clientId,
      mqttVersion: mqttVersion ?? this.mqttVersion,
      username:
          identical(username, _sentinel) ? this.username : username as String?,
      password:
          identical(password, _sentinel) ? this.password : password as String?,
      keepAlive: keepAlive ?? this.keepAlive,
      cleanSession: cleanSession ?? this.cleanSession,
      lastWillTopic: identical(lastWillTopic, _sentinel)
          ? this.lastWillTopic
          : lastWillTopic as String?,
      lastWillMessage: identical(lastWillMessage, _sentinel)
          ? this.lastWillMessage
          : lastWillMessage as String?,
      lastWillQos: lastWillQos ?? this.lastWillQos,
      lastWillRetain: lastWillRetain ?? this.lastWillRetain,
      topics: topics ?? this.topics,
    );
  }

  static const _sentinel = Object();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MqttRequestModel &&
          runtimeType == other.runtimeType &&
          url == other.url &&
          port == other.port &&
          clientId == other.clientId &&
          mqttVersion == other.mqttVersion &&
          username == other.username &&
          password == other.password &&
          keepAlive == other.keepAlive &&
          cleanSession == other.cleanSession &&
          lastWillTopic == other.lastWillTopic &&
          lastWillMessage == other.lastWillMessage &&
          lastWillQos == other.lastWillQos &&
          lastWillRetain == other.lastWillRetain &&
          _listEquals(topics, other.topics);

  @override
  int get hashCode => Object.hash(
        url,
        port,
        clientId,
        mqttVersion,
        username,
        password,
        keepAlive,
        cleanSession,
        lastWillTopic,
        lastWillMessage,
        lastWillQos,
        lastWillRetain,
        Object.hashAll(topics),
      );

  @override
  String toString() => 'MqttRequestModel(url: $url, port: $port, '
      'clientId: $clientId, mqttVersion: $mqttVersion)';

  static bool _listEquals<T>(List<T> a, List<T> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

const kMqttTopicEmptyModel = MqttTopicModel();
