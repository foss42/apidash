import '../llm_input_payload.dart';
import '../llm_request.dart';
import 'providers.dart';

abstract class LLMModel {
  const LLMModel(this.identifier, this.modelName, this.provider);
  final String identifier;
  final String modelName;
  final LLMProvider provider;

  static Map toJson(LLMModel m) {
    return {'identifier': m.identifier, 'provider': m.provider.name};
  }

  static LLMModel fromJson(Map json) {
    return LLMProvider.fromName(
      json['provider'],
    ).getLLMByIdentifier(json['identifier']);
  }
}

abstract class ModelController {
  LLMInputPayload get inputPayload => throw UnimplementedError();

  LLMRequestDetails createRequest(
    LLMModel model,
    LLMInputPayload inputPayload, {
    bool stream = false,
  }) {
    throw UnimplementedError();
  }

  String? outputFormatter(Map x) {
    throw UnimplementedError();
  }

  String? streamOutputFormatter(Map x) {
    throw UnimplementedError();
  }
}
