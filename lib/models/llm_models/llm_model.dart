import 'package:apidash/models/llm_models/llm_config.dart';

abstract class LLMModel {
  abstract String providerIcon;
  abstract String provider;
  abstract String modelName;
  abstract LLMModelAuthorizationType authorizationType;
  abstract String authorizationCredential;
  abstract List<LLMModelConfiguration> configurations;
  abstract String jsonPayloadBody;
}

enum LLMModelAuthorizationType {
  bearerToken('Bearer Token'),
  apiKey('API Key');

  const LLMModelAuthorizationType(this.label);
  final String label;
}
