import 'package:apidash_core/apidash_core.dart';
part 'protocol_model.freezed.dart';
part 'protocol_model.g.dart';

@Freezed(unionKey: 'type', unionValueCase: FreezedUnionCase.none)
sealed class ProtocolModel with _$ProtocolModel {
  @FreezedUnionValue('rest')
  @JsonSerializable(explicitToJson: true, anyMap: true)
  const factory ProtocolModel.rest({
    HttpRequestModel? httpRequestModel,
    HttpResponseModel? httpResponseModel,
  }) = _RestProtocolModel;

  @FreezedUnionValue('graphql')
  @JsonSerializable(explicitToJson: true, anyMap: true)
  const factory ProtocolModel.graphql({
    HttpRequestModel? httpRequestModel,
    HttpResponseModel? httpResponseModel,
  }) = _GraphqlProtocolModel;

  @FreezedUnionValue('ai')
  @JsonSerializable(explicitToJson: true, anyMap: true)
  const factory ProtocolModel.ai({
    AIRequestModel? aiRequestModel,
  }) = _AiProtocolModel;

  factory ProtocolModel.fromJson(Map<String, Object?> json) => _$ProtocolModelFromJson(json);
}

