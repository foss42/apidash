import 'package:apidash_core/apidash_core.dart';
import 'protocol_model.dart';

part 'request_model.freezed.dart';
part 'request_model.g.dart';

@freezed
abstract class RequestModel with _$RequestModel {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
  )
  const factory RequestModel({
    required String id,
    @Default(APIType.rest) APIType apiType,
    @Default("") String name,
    @Default("") String description,
    @JsonKey(includeToJson: false) @Default(0) requestTabIndex,
    int? responseStatus,
    String? message,
    @JsonKey(includeToJson: false) @Default(false) bool isWorking,
    @JsonKey(includeToJson: false) DateTime? sendingTime,
    @JsonKey(includeToJson: false) @Default(false) bool isStreaming,
    String? preRequestScript,
    String? postRequestScript,
    @Default(ProtocolModel.rest()) ProtocolModel protocolModel,
  }) = _RequestModel;

  factory RequestModel.fromJson(Map<String, Object?> json) =>
      _$RequestModelFromJson(json);
}

/// A backwards-compatibility shim to allow older UI/logic code to still access
/// [httpRequestModel] and others directly on [RequestModel].
/// 
/// TODO: Refactor the UI to use `requestModel.protocolModel.map(...)` or `switch` 
/// directly, and then delete this extension entirely. This avoids having to 
/// modify this file every time a new protocol (like MQTT) is added.
extension RequestModelProperties on RequestModel {
  HttpRequestModel? get httpRequestModel => protocolModel.mapOrNull(
        rest: (p) => p.httpRequestModel,
        graphql: (p) => p.httpRequestModel,
      );

  HttpResponseModel? get httpResponseModel => protocolModel.mapOrNull(
        rest: (p) => p.httpResponseModel,
        graphql: (p) => p.httpResponseModel,
      );

  AIRequestModel? get aiRequestModel => protocolModel.mapOrNull(
        ai: (p) => p.aiRequestModel,
      );
}
