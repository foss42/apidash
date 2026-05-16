import 'package:apidash_core/apidash_core.dart';
import 'websocket_model.dart';
import 'mqtt_model.dart';
import 'grpc_model.dart';

/// Abstract base class for all protocol-specific request models.
abstract class ProtocolModel {}

/// Polymorphic converter for [ProtocolModel] to handle JSON serialization.
class ProtocolModelConverter implements JsonConverter<ProtocolModel?, dynamic> {
  const ProtocolModelConverter();

  @override
  ProtocolModel? fromJson(dynamic jsonInput) {
    if (jsonInput == null || jsonInput is! Map) return null;
    final json = Map<String, dynamic>.from(jsonInput);
    final typeStr = json['type'] as String?;
    if (typeStr == APIType.websocket.name) {
      return WebSocketRequestModel.fromJson(json);
    } else if (typeStr == APIType.mqtt.name) {
      return MQTTRequestModel.fromJson(json);
    } else if (typeStr == APIType.grpc.name) {
      return GrpcRequestModel.fromJson(json);
    }

    // Fallback
    if (json.containsKey('brokerUrl')) {
      return MQTTRequestModel.fromJson(json);
    }
    if (json.containsKey('url') && json.containsKey('autoReconnect')) {
      return WebSocketRequestModel.fromJson(json);
    }
    if (json.containsKey('host') &&
        json.containsKey('port') &&
        !json.containsKey('brokerUrl')) {
      return GrpcRequestModel.fromJson(json);
    }

    return null;
  }

  @override
  Map<String, dynamic>? toJson(ProtocolModel? object) {
    if (object == null) return null;
    Map<String, dynamic>? json;
    String? type;

    if (object is WebSocketRequestModel) {
      json = object.toJson();
      type = APIType.websocket.name;
    } else if (object is MQTTRequestModel) {
      json = object.toJson();
      type = APIType.mqtt.name;
    } else if (object is GrpcRequestModel) {
      json = object.toJson();
      type = APIType.grpc.name;
    }

    if (json != null && type != null) {
      return {...json, 'type': type};
    }

    return json;
  }
}
