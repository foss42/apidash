// ignore_for_file: unnecessary_null_comparison

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

import '../../models/oauth_config_model.dart';

class OAuthConfigNotifier extends StateNotifier<List<OAuthConfig>> {
  static const _configKey = 'oauth_configs';
  OAuthConfigNotifier() : super(const []) {
    _loadConfigs();
  }

  Future<void> _loadConfigs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configsJson = prefs.getString(_configKey);
      if (configsJson != null) {
        final List<dynamic> configsList = jsonDecode(configsJson);
        state = configsList.map((json) => OAuthConfig.fromJson(json)).toList();
      } else {
        state = const [];
      }
    } catch (e) {
      // Removed print statement
    }
  }

  Future<void> _saveConfigs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configsJson = jsonEncode(state.map((config) => config.toJson()).toList());
      await prefs.setString(_configKey, configsJson);
    } catch (e) {
      // Removed print statement
    }
  }

  Future<void> addConfig(OAuthConfig config) async {
    final configToAdd = config.id == null 
        ? config.copyWith(id: const Uuid().v4()) 
        : config;
    
    state = [...state, configToAdd];
    await _saveConfigs();
    await _loadConfigs(); // Reload configs after saving
  }

  Future<void> updateConfig(OAuthConfig config) async {
    final updatedState = [
      for (final existingConfig in state)
        if (existingConfig.id == config.id) config else existingConfig
    ];
    if (!updatedState.contains(config)) {
      updatedState.add(config);
    }
    
    state = updatedState;
    await _saveConfigs();
  }

  Future<void> removeConfig(String configId) async {
    final initialLength = state.length;
    state = state.where((config) => config.id != configId).toList();
    
    if (state.length < initialLength) {
      await _saveConfigs();
    }
  }

  OAuthConfig? getConfigById(String configId) {
    try {
      return state.firstWhere(
        (config) => config.id == configId,
        orElse: () => throw StateError('No config found with ID: $configId'),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveConfig(OAuthConfig config) async {
    await updateConfig(config);
      await _loadConfigs(); // Reload configs after saving
  }
}

final oauthConfigProvider = StateNotifierProvider<OAuthConfigNotifier, List<OAuthConfig>>((ref) {
  return OAuthConfigNotifier();
});