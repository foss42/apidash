import 'package:apidash_genai/apidash_genai.dart';
import 'package:apidash_genai/providers/anthropic/models.dart';
import 'package:apidash_genai/providers/azureopenai/models.dart';
import 'package:apidash_genai/providers/gemini/models.dart';
import 'package:apidash_genai/providers/ollama/models.dart';
import 'package:apidash_genai/providers/providers.dart';

void main() async {
  // print('------------apidash_genai playground-------------');
  //Fetch LLMProvider Types
  // print("LLM Provider Types Available: ${LLMProviderType.values}");

  //--------LOCAL MODELS----------
  // print('------------local models-------------');
  // final localProviders = getLLMProvidersByType(LLMProviderType.local);
  // print(
  //   "LLMProviders available under (local): ${localProviders.map((x) => x.name).toList()}",
  // );
  // for (final lp in localProviders) {
  //   final lms = getLLMModelsByProvider(lp);
  //   print('\tModels available for ${lp.name}: ${lms.map((x) => x.identifier)}');
  //   if (lp == LLMProvider.ollama) {
  //     // TODO: Simulate Requests to AI here
  //     final sample_output = {
  //       'message': {'content': 'this was generated'},
  //     };
  //     for (final m in lms) {
  //       final ollamaM = getOllamaModelFromIdentifier(m.identifier);
  //       final ans = m.outputFormatter(sample_output);
  //       print('\t\tM: ${ollamaM.identifier} => $ans');
  //     }
  //   }
  // }

  // final ollama = LLMProvider.ollama;
  // final lms = getLLMModelsByProvider(ollama);

  //----Select the Model--------
  final provider = LLMProvider.gemini;
  final models = getLLMModelsByProvider(provider);
  final model = models.where((m) => m == GeminiModel.gemini_15_flash_8b).first;

  // -----Get the Payload-------
  final mC = getLLMModelControllerByProvider(provider);
  final model_input_payload = mC.inputPayload;

  // ------Fill in the Details-------
  model_input_payload.systemPrompt = 'Say YAY or NAY';
  model_input_payload.userPrompt = 'The sun sets in the west';
  model_input_payload.credential = 'AIzaSyAtmGxNxlbh_MokoDbMjHKDSW-gU6GCMOU';
  /////Adding MaxTokens/////
  // final mT = defaultLLMConfigurations[LLMModelConfigurationName.max_tokens]!
  //     .updateValue(LLMConfigNumericValue(value: 1));
  // model_input_payload.configMap[LLMModelConfigurationName.max_tokens.name] = mT;
  //////////////////////////

  // Create Model Request
  final modelRequest = mC.createRequest(model, model_input_payload);

  // Execute Model Request
  final ans = await executeGenAIRequest(model, modelRequest);
  print('ANSWER: $ans');

  // print('------------remote models-------------');
  // final remoteProviders = getLLMProvidersByType(LLMProviderType.remote);
  // print(
  //   "LLMProviders available under (remote): ${remoteProviders.map((x) => x)}",
  // );
  // for (final rp in remoteProviders) {
  //   final lms = getLLMModelsByProvider(rp);
  //   print('\tModels available for ${rp.name}: ${lms.map((x) => x.identifier)}');
  // }
}
