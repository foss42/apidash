import 'dart:developer';

import 'package:apidash/dashbot/core/constants/dashbot_constants.dart'
    show kDashbotSystemPrompt;
import 'package:ollama_dart/ollama_dart.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_local_repository.g.dart';

@Riverpod(keepAlive: true)
ChatLocalRepository chatLocalRepository(Ref ref) {
  return ChatLocalRepository();
}

class ChatLocalRepository {
  late OllamaClient _client;

  void init() {
    _client = OllamaClient();
  }

  Stream<GenerateCompletionResponse> dashbotGenerateChat(
      {required String prompt}) async* {
    try {
      log("Came to chat: $prompt");
      final responseStream = _client.generateCompletionStream(
        request: GenerateCompletionRequest(
          model: "llama3.2:3b",
          prompt: prompt,
          system: kDashbotSystemPrompt,
        ),
      );
      await for (final response in responseStream) {
        log(response.context.toString());
        yield response;
      }
    } catch (e) {
      log("Error in chatLocalRepository: $e");
    }
  }
}
