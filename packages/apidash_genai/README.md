# apidash_genai
This Package contains all the code related to generative AI capabilities and is a foundational feature that other APIDash parts can make use of.

### Getting LLM Provider by Type
```dart
final List<LLMProvider> localProviders = getLLMProvidersByType(LLMProviderType.local);
final List<LLMProvider> remoteProviders = getLLMProvidersByType(LLMProviderType.remote);
print(localProviders);
print(remoteProviders);
```

### Getting LLM Models for a given Provider
```dart
final List<LLMModel> ollamaModels = getLLMModelsByProvider(LLMProvider.ollama)
final List<LLMModel> geminiModels = getLLMModelsByProvider(LLMProvider.gemini)
```

### Using a Model (eg: Gemini)
```dart
final LLMModel model = GeminiModel.gemini_20_flash;
final ModelController controller = getLLMModelControllerByProvider(model.provider);
final payload = controller.inputPayload;
payload.systemPrompt = 'Say YES or NO';
payload.userPrompt = 'The sun sets in the west';
payload.credential = 'AIza....';
final genAIRequest = controller.createRequest(model, payload);
final answer = await executeGenAIRequest(model, genAIRequest);
print(answer)
```