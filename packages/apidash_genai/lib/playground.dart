import 'package:apidash_genai/apidash_genai.dart';
import 'package:apidash_genai/providers/ollama/configs.dart';
import 'package:apidash_genai/providers/ollama/models.dart';
import 'package:apidash_genai/providers/ollama/ollama_request.dart';
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
  final model = OllamaModel.gemma3;
  final model_input_payload = BASE_OLLAMA_PAYLOAD.clone();
  model_input_payload.systemPrompt = 'Reverse the String';
  model_input_payload.userPrompt = 'hello';
  final modelRequest = createOllamaRequest(model, model_input_payload);
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
