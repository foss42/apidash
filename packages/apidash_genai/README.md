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

### Directly Using a Model (eg: Gemini)
```dart
final LLMModel model = GeminiModel.gemini_20_flash;
final ModelController controller = getLLMModelControllerByProvider(model.provider);
final payload = controller.inputPayload;
payload.systemPrompt = 'Say YES or NO';
payload.userPrompt = 'The sun sets in the west';
payload.credential = 'AIza....';
final genAIRequest = controller.createRequest(model, payload);
final answer = await GenerativeAI.executeGenAIRequest(model, genAIRequest);
print(answer)
```

### Calling a GenAI Model using the provided helper
```dart
final geminiModel = GeminiModel.gemini_15_flash_8b;
GenerativeAI.callGenerativeModel(
    geminiModel,
    onAnswer: (x) {
        print(x);
    },
    systemPrompt: 'Give a 100 word summary of the provided word. Only give the answer',
    userPrompt: 'Pizza',
    credential: 'AIza.....',
);
```

### Calling a GenAI model (with Streaming)
```dart
final geminiModel = GeminiModel.gemini_15_flash_8b;
GenerativeAI.callGenerativeModel(
    geminiModel,
    onAnswer: (x) {
        stdout.write(x); //each word in the stream
    },
    systemPrompt: 'Give a 100 word summary of the provided word. Only give the answer',
    userPrompt: 'Pizza',
    credential: 'AIza.....',
    stream: true,
);
```