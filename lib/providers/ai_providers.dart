import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_providers.dart';

/// Provider for per-provider AI credentials
/// Key: ModelAPIProvider enum name (e.g., "openai", "anthropic")
/// Value: AIRequestModel for that provider
final aiProviderCredentialsProvider =
    StateNotifierProvider<AICredentialsNotifier, Map<String, AIRequestModel>>(
        (ref) {
  return AICredentialsNotifier(ref);
});

class AICredentialsNotifier extends StateNotifier<Map<String, AIRequestModel>> {
  final Ref _ref;

  AICredentialsNotifier(this._ref) : super({}) {
    _loadFromSettings();
  }

  void _loadFromSettings() {
    final settings = _ref.read(settingsProvider);
    final credentialsMap = settings.aiProviderCredentials;
    if (credentialsMap != null) {
      final loaded = <String, AIRequestModel>{};
      for (var entry in credentialsMap.entries) {
        try {
          loaded[entry.key] = AIRequestModel.fromJson(
            Map<String, Object?>.from(entry.value),
          );
        } catch (e) {
          // Skip invalid entries
        }
      }
      state = loaded;
    }
  }

  AIRequestModel? getCredential(ModelAPIProvider provider) {
    return state[provider.name];
  }

  Future<void> updateCredential(
      ModelAPIProvider provider, AIRequestModel model) async {
    state = {...state, provider.name: model};
    await _persistToSettings();
  }

  Future<void> removeCredential(ModelAPIProvider provider) async {
    final newState = Map<String, AIRequestModel>.from(state);
    newState.remove(provider.name);
    state = newState;
    await _persistToSettings();
  }

  Future<void> _persistToSettings() async {
    final serialized = <String, Map<String, Object?>>{};
    for (var entry in state.entries) {
      serialized[entry.key] = entry.value.toJson();
    }
    await _ref.read(settingsProvider.notifier).update(
          aiProviderCredentials: serialized,
        );
  }
}
