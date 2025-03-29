import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/dashbot_service.dart';

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

  static const _storageKey = 'chatMessages';

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messages = prefs.getString(_storageKey);
    if (messages != null) {
      state = List<Map<String, dynamic>>.from(json.decode(messages));
    }
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, json.encode(state));
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
