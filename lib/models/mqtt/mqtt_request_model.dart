import 'package:flutter/foundation.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';

@immutable
class MQTTRequestModel {
  const MQTTRequestModel({
    this.username,
    this.password,
    this.keepAlive,
    this.lwTopic,
    this.lwMessage,
    required this.lwQos,
    required this.lwRetain,
    required this.id,
    required this.clientId,
    this.url = "",
    this.name = "",
    this.description = "",
    this.requestTabIndex = 0,
    this.responseStatus,
    this.message,
    this.responseModel,
  });

  final String id;
  final String clientId;
  final String url;
  final String name;
  final String description;
  final int requestTabIndex;
  final int? responseStatus;
  final String? message;
  final String? username;
  final String? password;
  final int? keepAlive;
  final String? lwTopic;
  final String? lwMessage;
  final int lwQos;
  final bool lwRetain;

  final MQTTResponseModel? responseModel;

  MQTTRequestModel duplicate({
    required String id,
  }) {
    return MQTTRequestModel(
      id: id,
      url: "",
      name: "$name (copy)",
      description: "",
      requestTabIndex: 0,
      responseStatus: null,
      message: null,
      username: null,
      password: null,
      keepAlive: null,
      lwTopic: null,
      lwMessage: null,
      lwQos: 0,
      lwRetain: false,
      responseModel: null,
      clientId: "",
    );
  }

  MQTTRequestModel copyWith({
    String? id,
    HTTPVerb? method,
    String? url,
    String? name,
    String? description,
    int? requestTabIndex,
    int? responseStatus,
    String? message,
    MQTTResponseModel? responseModel,
    String? username,
    String? password,
    int? keepAlive,
    String? lwTopic,
    String? lwMessage,
    int? lwQos,
    bool? lwRetain,
    String? clientId,
  }) {
    return MQTTRequestModel(
      id: id ?? this.id,
      url: url ?? this.url,
      name: name ?? this.name,
      description: description ?? this.description,
      requestTabIndex: requestTabIndex ?? this.requestTabIndex,
      responseStatus: responseStatus ?? this.responseStatus,
      message: message ?? this.message,
      responseModel: responseModel ?? this.responseModel,
      username: username ?? this.username,
      password: password ?? this.password,
      keepAlive: keepAlive ?? this.keepAlive,
      lwTopic: lwTopic ?? this.lwTopic,
      lwMessage: lwMessage ?? this.lwMessage,
      lwQos: lwQos ?? this.lwQos,
      lwRetain: lwRetain ?? this.lwRetain,
      clientId: clientId ?? this.clientId,
    );
  }

  factory MQTTRequestModel.fromJson(Map<String, dynamic> data) {
    MQTTResponseModel? responseModel;

    final id = data["id"] as String;
    final url = data["url"] as String;
    final name = data["name"] as String?;
    final description = data["description"] as String?;
    final username = data["username"] as String?;
    final password = data["password"] as String?;
    final keepAlive = data["keepAlive"] as int?;
    final lwTopic = data["lwTopic"] as String?;
    final lwMessage = data["lwMessage"] as String?;
    final lwQos = data["lwQos"] as int;
    final lwRetain = data["lwRetain"] as bool;
    final responseStatus = data["responseStatus"] as int?;
    final message = data["message"] as String?;
    final clientId = data["clientId"] as String;
    final responseModelJson = data["responseModel"];

    if (responseModelJson != null) {
      responseModel = MQTTResponseModel.fromJson(
          Map<String, dynamic>.from(responseModelJson));
    } else {
      responseModel = null;
    }

    return MQTTRequestModel(
      id: id,
      url: url,
      clientId: clientId,
      name: name ?? "",
      description: description ?? "",
      requestTabIndex: 0,
      responseStatus: responseStatus,
      message: message,
      username: username ?? "",
      password: password ?? "",
      keepAlive: keepAlive,
      lwTopic: lwTopic,
      lwMessage: lwMessage,
      lwQos: lwQos,
      lwRetain: lwRetain,
      responseModel: responseModel,
    );
  }

  Map<String, dynamic> toJson({bool includeResponse = true}) {
    return {
      "id": id,
      "url": url,
      "name": name,
      "description": description,
      "clientId": clientId,
      "username": username,
      "password": password,
      "keepAlive": keepAlive,
      "lwTopic": lwTopic,
      "lwMessage": lwMessage,
      "lwQos": lwQos,
      "lwRetain": lwRetain,
      "responseStatus": includeResponse ? responseStatus : null,
      "message": includeResponse ? message : null,
      "responseModel": includeResponse ? responseModel?.toJson() : null,
    };
  }

  @override
  String toString() {
    return [
      "Request Id: $id",
      "Request URL: $url",
      "Request Name: $name",
      "Request Description: $description",
      "Client ID: $clientId",
      "Username: $username",
      "Password: $password",
      "Keep Alive: ${keepAlive.toString()}",
      "Last Will Topic: $lwTopic",
      "Last Will Message: $lwMessage",
      "Last Will QoS: ${lwQos.toString()}",
      "Last Will Retain: $lwRetain",
      "Request Tab Index: ${requestTabIndex.toString()}",
      "Response Status: $responseStatus",
      "Response Message: $message",
      "Response: ${responseModel.toString()}"
    ].join("\n");
  }

  @override
  bool operator ==(Object other) {
    return other is MQTTRequestModel &&
        other.runtimeType == runtimeType &&
        other.id == id &&
        other.url == url &&
        clientId == other.clientId &&
        other.name == name &&
        other.description == description &&
        other.username == username &&
        other.password == password &&
        other.keepAlive == keepAlive &&
        other.lwTopic == lwTopic &&
        other.lwMessage == lwMessage &&
        other.lwQos == lwQos &&
        other.lwRetain == lwRetain &&
        other.requestTabIndex == requestTabIndex &&
        other.responseStatus == responseStatus &&
        other.message == message &&
        other.responseModel == responseModel;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      id,
      url,
      clientId,
      name,
      description,
      username,
      password,
      keepAlive,
      lwTopic,
      lwMessage,
      lwQos,
      lwRetain,
      requestTabIndex,
      responseStatus,
      message,
      responseModel,
    );
  }
}
