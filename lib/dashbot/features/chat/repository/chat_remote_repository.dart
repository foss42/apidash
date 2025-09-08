import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genai/genai.dart';

/// Repository for talking to the GenAI layer.
abstract class ChatRemoteRepository {
  /// Stream a chat completion with the provided AI request.
  Stream<String> streamChat({required AIRequestModel request});

  /// Execute a non-streaming chat completion.
  Future<String?> sendChat({required AIRequestModel request});
}

class ChatRemoteRepositoryImpl implements ChatRemoteRepository {
  ChatRemoteRepositoryImpl();

  @override
  Stream<String> streamChat({required AIRequestModel request}) async* {
    final stream = await streamGenAIRequest(request);
    await for (final chunk in stream) {
      if (chunk != null && chunk.isNotEmpty) yield chunk;
    }
  }

  @override
  Future<String?> sendChat({required AIRequestModel request}) async {
    final result = await executeGenAIRequest(request);
    if (result == null || result.isEmpty) return null;
    return result;
  }
}

/// Provider for the repository
final chatRepositoryProvider = Provider<ChatRemoteRepository>((ref) {
  return ChatRemoteRepositoryImpl();
});
