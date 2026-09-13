import 'package:apidash_core/apidash_core.dart';
import 'ws_request_model.dart';

part 'grpc_request_model.freezed.dart';
part 'grpc_request_model.g.dart';

enum GrpcStreamingType { unary, client, server, bidi }

@freezed
abstract class GrpcParameterModel with _$GrpcParameterModel {
  const factory GrpcParameterModel({
    required String name,
    int? tag,
    @Default("string") String type,
    @Default("") String value,
    @Default(true) bool enabled,
    List<String>? enumValues,
  }) = _GrpcParameterModel;

  factory GrpcParameterModel.fromJson(Map<String, dynamic> json) =>
      _$GrpcParameterModelFromJson(json);
}

@freezed
abstract class GrpcRequestModel with _$GrpcRequestModel {
  const GrpcRequestModel._();

  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
  )
  const factory GrpcRequestModel({
    @Default("") String url,
    String? service,
    String? method,
    String? protoFile,
    @Default(false) bool useTLS,
    @Default(false) bool allowInvalidCertificates,
    @Default(GrpcStreamingType.unary) GrpcStreamingType streamingType,
    @Default([]) List<WebSocketMessage> messageHistory,
    @Default("") String requestBody,
    @Default(false) bool useReflection,
    @Default([]) List<NameValueModel>? metadata,
    @Default([]) List<bool>? isMetadataEnabled,
    AuthModel? authModel,
    @Default([]) List<String> availableServices,
    @Default([]) List<String> availableMethods,
    @Default([]) List<GrpcParameterModel> parameters,
  }) = _GrpcRequestModel;

  Map<String, String> get metadataMap {
    if (metadata == null) return {};
    return {
      for (var m in (metadata!))
        if (m.name.isNotEmpty) m.name: m.value
    };
  }

  factory GrpcRequestModel.fromJson(Map<String, dynamic> json) =>
      _$GrpcRequestModelFromJson(json);
}
