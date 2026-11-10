import 'dart:async';

import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../error/chat_failure.dart';

/// Repository for talking to the GenAI layer.
abstract class ChatRemoteRepository {
  /// Execute a non-streaming chat completion.
  Future<String?> sendChat({required AIRequestModel request});
}

class ChatRemoteRepositoryImpl implements ChatRemoteRepository {
  final Future<String?> Function(AIRequestModel? request) _executeRequest;

  ChatRemoteRepositoryImpl({
    Future<String?> Function(AIRequestModel? request)? executeRequest,
  }) : _executeRequest = executeRequest ?? executeGenAIRequest;

  @override
  Future<String?> sendChat({required AIRequestModel request}) async {
    try {
      final result = await _executeRequest(request);
      if (result == null || result.isEmpty) return null;
      return result;
    } on GenAIException catch (e) {
      throw ChatFailure(
        e.message,
        code: e.statusCode?.toString(),
      );
    }
  }
}

/// Provider for the repository
final chatRepositoryProvider = Provider<ChatRemoteRepository>((ref) {
  return ChatRemoteRepositoryImpl();
});
