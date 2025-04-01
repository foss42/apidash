import 'dart:developer';

import 'package:apidash/dashbot/features/home/repository/chat_local_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ollama_dart/ollama_dart.dart';
import 'dart:async';

part 'home_viewmodel.g.dart';

@riverpod
class HomeViewmodel extends _$HomeViewmodel {
  late ChatLocalRepository _chatLocalRepository;

  @override
  Stream<GenerateCompletionResponse> build() {
    _chatLocalRepository = ref.watch(chatLocalRepositoryProvider);
    _chatLocalRepository.init();
    return const Stream.empty();
  }

  Stream<GenerateCompletionResponse> sendMessage(String prompt) async* {
    log("Came to sendMessage: $prompt");
    yield* _chatLocalRepository.dashbotChat(prompt: prompt);
  }
}
