import 'dart:convert';
import 'package:apidash/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/services.dart';

final dashBotMinimizedProvider = StateProvider<bool>((ref) {
  return true;
});

final chatMessagesProvider =
    StateNotifierProvider<ChatMessagesNotifier, List<Map<String, dynamic>>>(
  (ref) => ChatMessagesNotifier(),
);

final dashBotServiceProvider = Provider<DashBotService>((ref) {
  return DashBotService();
});

class ChatMessagesNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  ChatMessagesNotifier() : super([]) {
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final messages = await hiveHandler.getDashbotMessages();
    if (messages != null) {
      state = List<Map<String, dynamic>>.from(json.decode(messages));
    }
  }

  Future<void> _saveMessages() async {
    final messages = json.encode(state);
    await hiveHandler.saveDashbotMessages(messages);
  }

  void addMessage(Map<String, dynamic> message) {
    state = [...state, message];
    _saveMessages();
  }

  void clearMessages() {
    state = [];
    _saveMessages();
  }
}
