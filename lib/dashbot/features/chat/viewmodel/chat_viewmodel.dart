import 'dart:developer';

import 'package:apidash/dashbot/features/chat/repository/chat_local_repository.dart'
    show ChatLocalRepository, chatLocalRepositoryProvider;
import 'package:apidash/dashbot/features/home/models/llm_provider.dart';
import 'package:apidash/providers/dashbot_llm_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ollama_dart/ollama_dart.dart';
import 'dart:async';

part 'chat_viewmodel.g.dart';

@riverpod
class ChatViewmodel extends _$ChatViewmodel {
  late ChatLocalRepository _chatLocalRepository;
  late String _modelName;

  @override
  Stream<GenerateCompletionResponse> build() async* {
    _chatLocalRepository = ref.watch(chatLocalRepositoryProvider);
    final LlmProvider selectedLlmProvider =
        ref.watch(llmProviderNotifierProvider.notifier).getSelectedProvider();
    if (selectedLlmProvider.type == LlmProviderType.local) {
      _modelName = selectedLlmProvider.localConfig!.modelName!;
    } else {
      _modelName = selectedLlmProvider.remoteConfig!.modelName!;
    }

    _chatLocalRepository.init();
    log("Model name: $_modelName");
    yield GenerateCompletionResponse(response: "Welcome to DashBot!");
  }

  Stream<GenerateCompletionResponse> sendMessage(
    String prompt,
    List<int>? context,
  ) async* {
    log("Came to sendMessage: $prompt");
    final chatStream = _chatLocalRepository.dashbotGenerateChat(
      prompt: prompt,
      model: _modelName,
      context: context,
    );
    yield* chatStream;
  }
}
