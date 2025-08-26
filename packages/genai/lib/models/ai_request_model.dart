import 'package:better_networking/better_networking.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../interface/interface.dart';
import 'model_request_data.dart';
part 'ai_request_model.freezed.dart';
part 'ai_request_model.g.dart';

@freezed
class AIRequestModel with _$AIRequestModel {
  const AIRequestModel._();

  @JsonSerializable(explicitToJson: true, anyMap: true)
  const factory AIRequestModel({
    ModelAPIProvider? modelProvider,
    ModelRequestData? modelRequestData,
  }) = _AIRequestModel;

  factory AIRequestModel.fromJson(Map<String, Object?> json) =>
      _$AIRequestModelFromJson(json);

  HttpRequestModel? get httpRequestModel =>
      kModelProvidersMap[modelProvider]?.createRequest(modelRequestData);

  String? getFormattedOutput(Map x) =>
      kModelProvidersMap[modelProvider]?.outputFormatter(x);

  String? getFormattedStreamOutput(Map x) =>
      kModelProvidersMap[modelProvider]?.streamOutputFormatter(x);
}
