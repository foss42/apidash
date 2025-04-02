import 'dart:developer';

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

  Stream<GenerateCompletionResponse> dashbotChat(
      {required String prompt}) async* {
    try {
      log("Came to chat: $prompt");
      final responseStream = _client.generateCompletionStream(
        request: GenerateCompletionRequest(
          model: "llama3.2:3b",
          prompt: prompt,
        ),
      );
      await for (final response in responseStream) {
        log(response.response.toString());
        yield response;
      }
    } catch (e) {
      log("Error in chatLocalRepository: $e");
    }
  }
}
