import 'package:apidash_genai/llm_config.dart';
import 'package:apidash_genai/llm_input_payload.dart';
import 'package:apidash_genai/llm_request.dart';
import 'package:apidash_genai/providers/providers.dart';

abstract class LLMModel {
  const LLMModel(this.identifier, this.modelName, this.provider);
  final String identifier;
  final String modelName;
  final LLMProvider provider;
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
