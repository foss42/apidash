import 'dart:io';

import 'package:apidash_genai/apidash_genai.dart';
import 'package:apidash_genai/llm_config.dart';
import 'package:apidash_genai/providers/anthropic/models.dart';
import 'package:apidash_genai/providers/azureopenai/models.dart';
import 'package:apidash_genai/providers/common.dart';
import 'package:apidash_genai/providers/gemini/models.dart';
import 'package:apidash_genai/providers/ollama/models.dart';
import 'package:apidash_genai/providers/providers.dart';

void main() async {
  // print("LLM Provider Types Available: ${LLMProviderType.values}");
  // final localProviders = getLLMProvidersByType(LLMProviderType.local);
  // final remoteProviders = getLLMProvidersByType(LLMProviderType.remote);

  // print(
  //   "LLMProviders available under (local): ${localProviders.map((x) => x.name).toList()}",
  // );
  // print(
  //   '\tModels available under Ollama: \n\t\t${getLLMModelsByProvider(LLMProvider.ollama).map((x) => x.modelName).join('\n\t\t')}',
  // );
  // print(
  //   "LLMProviders available under (remote): ${remoteProviders.map((x) => x.name).toList()}",
  // );
  // for (final p in remoteProviders) {
  //   print(
  //     '\tModels available under ${p.displayName}: \n\t\t${getLLMModelsByProvider(p).map((x) => x.modelName).join('\n\t\t')}',
  //   );
  // }

  const SYSPROMPT =
      'Give me 50 word sentence for the given word. Only give me the answer';
  const USERPROMPT = 'banana';

  // print('OLLAMA');
  // final ollamaModel = OllamaModel.gemma3;
  // GenerativeAI.callGenerativeModel(
  //   onAnswer: (x) {
  //     stdout.write(x);
  //   },
  //   ollamaModel,
  //   systemPrompt: SYSPROMPT,
  //   userPrompt: USERPROMPT,
  //   stream: true,
  // );

  // print('GEMINI');
  // final geminiModel = GeminiModel.gemini_15_flash_8b;
  // GenerativeAI.callGenerativeModel(
  //   geminiModel,
  //   onAnswer: (x) {
  //     stdout.write(x);
  //   },
  //   systemPrompt: SYSPROMPT,
  //   userPrompt: USERPROMPT,
  //   credential: 'AIzaSyAtmGxNxlbh_MokoDbMjHKDSW-gU6GCMOU',
  //   stream: true,
  // );

  // print('AZURE OPENAI');
  // final azoaModel = AzureOpenAIModel.custom;
  // GenerativeAI.callGenerativeModel(
  //   azoaModel,
  //   onAnswer: (x) {
  //     stdout.write(x);
  //   },
  //   systemPrompt: SYSPROMPT,
  //   userPrompt: USERPROMPT,
  //   endpoint:
  //       'XXXXX',
  //   credential: 'XXXXX',
  //   stream: true,
  // );

  //---------------------------------
}
