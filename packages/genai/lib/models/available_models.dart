// To parse this JSON data, do
//
//     final availableModels = availableModelsFromJson(jsonString);

import 'dart:convert';
import 'package:better_networking/better_networking.dart';
import '../interface/interface.dart';
import 'ai_request_model.dart';

part 'available_models.freezed.dart';
part 'available_models.g.dart';

AvailableModels availableModelsFromJson(String str) =>
    AvailableModels.fromJson(json.decode(str));

String availableModelsToJson(AvailableModels data) =>
    json.encode(data.toJson());

@freezed
abstract class AvailableModels with _$AvailableModels {
  const AvailableModels._();
  const factory AvailableModels({
    @JsonKey(name: "version") required double version,
    @JsonKey(name: "model_providers")
    required List<AIModelProvider> modelProviders,
  }) = _AvailableModels;

  factory AvailableModels.fromJson(Map<String, dynamic> json) =>
      _$AvailableModelsFromJson(json);

  Map<ModelAPIProvider, AIModelProvider> get map =>
      modelProviders.asMap().map<ModelAPIProvider, AIModelProvider>(
        (i, d) => MapEntry(d.providerId!, d),
      );
}

@freezed
abstract class AIModelProvider with _$AIModelProvider {
  const AIModelProvider._();

  const factory AIModelProvider({
    @JsonKey(name: "provider_id") ModelAPIProvider? providerId,
    @JsonKey(name: "provider_name") String? providerName,
    @JsonKey(name: "source_url") String? sourceUrl,
    @JsonKey(name: "models") List<Model>? models,
  }) = _AIModelProvider;

  factory AIModelProvider.fromJson(Map<String, dynamic> json) =>
      _$AIModelProviderFromJson(json);

  AIRequestModel? toAiRequestModel({Model? model}) {
    var aiRequest = kModelProvidersMap[providerId]?.defaultAIRequestModel;
    if (model != null) {
      aiRequest = aiRequest?.copyWith(model: model.id);
    }
    return aiRequest;
  }
}

@freezed
abstract class Model with _$Model {
  const factory Model({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "name") String? name,
  }) = _Model;

  factory Model.fromJson(Map<String, dynamic> json) => _$ModelFromJson(json);
}
