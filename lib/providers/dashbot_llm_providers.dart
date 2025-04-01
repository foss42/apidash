import 'package:apidash/dashbot/features/home/models/llm_provider.dart';
import 'package:apidash/services/shared_preferences_services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'dashbot_llm_providers.g.dart';

const String _selectedProviderKey = "selected_provider_index";

@riverpod
class LlmProviderNotifier extends _$LlmProviderNotifier {
  @override
  List<LlmProvider> build() {
    return [
      LlmProvider(
          type: LlmProviderType.local,
          name: 'Ollama',
          subtitle: 'Run LLMs locally on your machine',
          logo: 'assets/ollama_logo.png',
          localConfig: LocalLlmConfig(
            modelName: null,
            baseUrl: null,
          )),
      LlmProvider(
        type: LlmProviderType.remote,
        name: 'Gemini',
        subtitle: 'Google\'s largest and most capable AI model',
        logo: 'assets/gemini_logo.png',
        remoteConfig: RemoteLlmConfig(apiKey: "", modelName: "gemini-pro"),
      ),
      LlmProvider(
        type: LlmProviderType.remote,
        name: 'OpenAI',
        subtitle: 'The standard option for most use',
        logo: 'assets/openai_logo.png',
        remoteConfig: RemoteLlmConfig(apiKey: "", modelName: "gpt-4-turbo"),
      ),
      LlmProvider(
        type: LlmProviderType.remote,
        name: 'Anthropic',
        subtitle: 'A friendly AI assistant hosted by Anthropic',
        logo: 'assets/claude_logo.png',
        remoteConfig: RemoteLlmConfig(apiKey: "", modelName: "claude-3"),
      ),
    ];
  }

  Future<void> loadSelectedProvider() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_selectedProviderKey) ?? 0;
    if (index < state.length) {
      state = [...state];
    }
  }

  Future<void> setSelectedProvider(LlmProvider provider) async {
    setSelectedLlmProviderToSharedPrefs(provider);
    state = [...state];
  }

  LlmProvider getSelectedProvider() {
    final provider = getSelectedProviderFromSharedPrefs();
    if (provider != null) {
      return provider;
    }
    return state[0];
  }
}
