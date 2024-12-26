import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

import '../models/oauth_config_model.dart';

class OAuthConfigNotifier extends StateNotifier<List<OAuthConfig>> {
  static const _configKey = 'oauth_configs';

  OAuthConfigNotifier() : super([]) {
    _loadConfigs();
  }

  Future<void> _loadConfigs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configsJson = prefs.getString(_configKey);
      if (configsJson != null) {
        final List<dynamic> configsList = jsonDecode(configsJson);
        state = configsList.map((json) => OAuthConfig.fromJson(json)).toList();
        print('[OAuth Config] Loaded configurations: ${state.length}');
        for (var config in state) {
          print('[OAuth Config] Config ID: ${config.id}, Name: ${config.name}');
        }
      } else {
        print('[OAuth Config] No configurations found in storage.');
      }
    } catch (e) {
      print('[OAuth Config] Error loading configurations: $e');
    }
  }

  Future<void> _saveConfigs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configsJson = jsonEncode(state.map((config) => config.toJson()).toList());
      await prefs.setString(_configKey, configsJson);
      print('[OAuth Config] Configurations saved successfully.');
    } catch (e) {
      print('[OAuth Config] Error saving OAuth configs: $e');
    }
  }

  Future<void> addConfig(OAuthConfig config) async {
    final configToAdd = config.id == null 
        ? config.copyWith(id: const Uuid().v4()) 
        : config;
    
    print('[OAuth Config] Config details:');
    print('[OAuth Config] ID: ${configToAdd.id}');
    print('[OAuth Config] Flow: ${configToAdd.flow}');
    print('[OAuth Config] Token Endpoint: ${configToAdd.tokenEndpoint}');
    
    state = [...state, configToAdd];
    await _saveConfigs();
    await _loadConfigs(); // Reload configs after saving
    print('[OAuth Config] Configuration added successfully');
  }

  Future<void> updateConfig(OAuthConfig config) async {
    print('\n[OAuth Config] Updating OAuth configuration');
    print('[OAuth Config] Config ID: ${config.id}');
    print('[OAuth Config] Updated details:');
    print('[OAuth Config] Flow: ${config.flow}');
    print('[OAuth Config] Token Endpoint: ${config.tokenEndpoint}');

    final updatedState = [
      for (final existingConfig in state)
        if (existingConfig.id == config.id) config else existingConfig
    ];

    if (!updatedState.contains(config)) {
      updatedState.add(config);
    }
    
    state = updatedState;
    await _saveConfigs();
    print('[OAuth Config] Configuration updated successfully');
  }

  Future<void> removeConfig(String configId) async {
    print('\n[OAuth Config] Removing OAuth configuration');
    print('[OAuth Config] Config ID to remove: $configId');
    
    final initialLength = state.length;
    state = state.where((config) => config.id != configId).toList();
    
    if (state.length < initialLength) {
      await _saveConfigs();
      print('[OAuth Config] Configuration removed successfully');
    } else {
      print('[OAuth Config] Configuration not found for removal');
    }
  }

  OAuthConfig? getConfigById(String configId) {
    print('\n[OAuth Config] Getting OAuth configuration by ID: $configId');
    try {
      final config = state.firstWhere(
        (config) => config.id == configId,
        orElse: () => throw StateError('No config found with ID: $configId'),
      );
      print('[OAuth Config] Configuration found:');
      print('[OAuth Config] Flow: ${config.flow}');
      return config;
    } catch (e) {
      print('[OAuth Config] Error getting configuration: $e');
      rethrow;
    }
  }

  Future<void> saveConfig(OAuthConfig config) async {
    if (config.id == null) {
      await addConfig(config);
    } else {
      await updateConfig(config);
    }
    await _loadConfigs(); // Reload configs after saving
  }

}

final oauthConfigProvider = StateNotifierProvider<OAuthConfigNotifier, List<OAuthConfig>>((ref) {
  print('[OAuth Config] Creating new OAuthConfigNotifier instance');
  return OAuthConfigNotifier();
});
