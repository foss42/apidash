import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../consts.dart';
import '../services/dashbot_service.dart';

// Chat Messages Provider
final chatMessagesProvider =
StateNotifierProvider<ChatMessagesNotifier, List<Map<String, dynamic>>>(
        (ref) => ChatMessagesNotifier());


final selectedLLMProvider =
StateNotifierProvider<SelectedLLMNotifier, LLMProvider>(
        (ref) => SelectedLLMNotifier());

class ChatMessagesNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  ChatMessagesNotifier() : super([]) {
    _loadMessages();
  }

  static const _storageKey = 'chatMessages';

  Future<void> _loadMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messages = prefs.getString(_storageKey);
      if (messages != null) {
        state = List<Map<String, dynamic>>.from(json.decode(messages));
      }
    } catch (e) {
      print("Error loading messages: $e");
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

class SelectedLLMNotifier extends StateNotifier<LLMProvider> {
  SelectedLLMNotifier() : super(LLMProvider.ollama) {
    _loadSelectedLLM();
  }

  static const _storageKey = 'selectedLLM';

  Future<void> _loadSelectedLLM() async {
    final prefs = await SharedPreferences.getInstance();
    final savedValue = prefs.getString(_storageKey);
    if (savedValue != null) {
      state = LLMProvider.values.firstWhere(
            (e) => e.toString() == savedValue,
        orElse: () => LLMProvider.ollama,
      );
    }
  }

  Future<void> setSelectedLLM(LLMProvider provider) async {
    state = provider;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, provider.toString());
  }
}
final selectedLLMModelProvider = StateNotifierProvider<SelectedLLMModelNotifier, String>(
      (ref) => SelectedLLMModelNotifier(),
);

class SelectedLLMModelNotifier extends StateNotifier<String> {
  SelectedLLMModelNotifier() : super("mistral") {
    _loadSelectedLLMModel();
  }

  static const _storageKey = 'selectedLLMModel';

  Future<void> _loadSelectedLLMModel() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(_storageKey) ?? "mistral";
  }

  Future<void> setSelectedLLMModel(String model) async {
    state = model;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, model);
  }
}


