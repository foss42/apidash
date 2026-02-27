import 'dart:async';

import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Repository for talking to the GenAI layer.
abstract class ChatRemoteRepository {
  /// Execute a non-streaming chat completion.
  Future<String?> sendChat({required AIRequestModel request});

  /// Execute a streaming chat completion, yielding chunks as they arrive.
  Future<Stream<String?>> streamChat({required AIRequestModel request});
}

class ChatRemoteRepositoryImpl implements ChatRemoteRepository {
  ChatRemoteRepositoryImpl();

  @override
  Future<String?> sendChat({required AIRequestModel request}) async {
    final result = await executeGenAIRequest(request);
    if (result == null || result.isEmpty) return null;
    return result;
  }

  @override
  Future<Stream<String?>> streamChat({required AIRequestModel request}) {
    return streamGenAIRequest(request);
  }
}

/// Provider for the repository
final chatRepositoryProvider = Provider<ChatRemoteRepository>((ref) {
  return ChatRemoteRepositoryImpl();
});
