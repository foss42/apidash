import 'dart:io';
import 'package:genai/genai.dart';
import 'package:genai/providers/ollama/models.dart';

void main() async {
  const SYSPROMPT =
      'Give me 50 word sentence for the given word. Only give me the answer';
  const USERPROMPT = 'banana';

  print('OLLAMA');
  final ollamaModel = OllamaModel.gemma3;
  GenerativeAI.callGenerativeModel(
    onAnswer: (x) {
      stdout.write(x);
    },
    ollamaModel,
    systemPrompt: SYSPROMPT,
    userPrompt: USERPROMPT,
    stream: true,
    // configurations: {
    //   LLMConfigName.max_tokens.name:
    //       defaultLLMConfigurations[LLMConfigName.max_tokens]!.updateValue(
    //         LLMConfigNumericValue(value: 1),
    //       ),
    // },
  );

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
