import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/models/protocols/base_protocol_model.dart';
import 'websocket_model.dart';

part 'grpc_model.freezed.dart';
part 'grpc_model.g.dart';

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
abstract class GrpcRequestModel
    with _$GrpcRequestModel
    implements ProtocolModel {
  const GrpcRequestModel._();

  const factory GrpcRequestModel({
    required String host,
    @Default(50051) int port,
    String? service,
    String? method,
    String? protoFile,
    @Default(false) bool useTLS,
    @Default(GrpcStreamingType.unary) GrpcStreamingType streamingType,
    @Default([]) List<WebSocketMessage> messageHistory,
    @Default("") String requestBody,
    @Default(false) bool useReflection,
    @Default([]) List<NameValueModel>? metadata,
    @Default([]) List<bool>? isMetadataEnabled,
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
