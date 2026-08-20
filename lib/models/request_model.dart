import 'package:apidash_core/apidash_core.dart';
import 'ws_request_model.dart';
import 'grpc_request_model.dart';

part 'request_model.freezed.dart';

part 'request_model.g.dart';

@freezed
abstract class RequestModel with _$RequestModel {
  // Required by freezed so custom methods (e.g. getUrl) are mixed into the
  // generated _RequestModel. Looks "unused" to the linter but removing it
  // breaks codegen (_RequestModel stops implementing getUrl) — do not delete.
  const RequestModel._();

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
    HttpRequestModel? httpRequestModel,
    int? responseStatus,
    String? message,
    HttpResponseModel? httpResponseModel,
    @JsonKey(includeToJson: false) @Default(false) bool isWorking,
    @JsonKey(includeToJson: false) DateTime? sendingTime,
    @JsonKey(includeToJson: false) @Default(false) bool isStreaming,
    String? preRequestScript,
    String? postRequestScript,
    AIRequestModel? aiRequestModel,
    WebSocketRequestModel? wsRequestModel,
    GrpcRequestModel? grpcRequestModel,
  }) = _RequestModel;

  factory RequestModel.fromJson(Map<String, Object?> json) =>
      _$RequestModelFromJson(json);

  String? getUrl() {
    return switch (apiType) {
      APIType.rest => httpRequestModel?.url,
      APIType.graphql => httpRequestModel?.url,
      APIType.ai => aiRequestModel?.url,
      APIType.websocket => wsRequestModel?.url,
      APIType.grpc => grpcRequestModel?.url,
    };
  }
}
