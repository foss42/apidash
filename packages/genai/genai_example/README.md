# GenAI Example

This project is a simple demonstration of how to use the GenAI package

### Fetch all available Remote LLMs
```dart
await LLMManager.fetchAvailableLLMs();
```

### Getting LLM Models for a given Provider
```dart
final List<LLMModel> models = LLMProvider.gemini.models;
```

### Calling a GenAI Model using the provided helper
```dart
final LLMModel geminiModel = LLMProvider.gemini.getLLMByIdentifier('gemini-2.0-flash');
final ModelController controller = model.provider.modelController;
GenerativeAI.callGenerativeModel(
    geminiModel,
    onAnswer: (x) {
        print(x);
    },
    onError: (e){},
    systemPrompt: 'Give a 100 word summary of the provided word. Only give the answer',
    userPrompt: 'Pizza',
    credential: 'AIza.....',
);
```

### Calling a GenAI model (with Streaming)
```dart
final LLMModel geminiModel = LLMProvider.gemini.getLLMByIdentifier('gemini-2.0-flash');
final ModelController controller = model.provider.modelController;
GenerativeAI.callGenerativeModel(
    geminiModel,
    onAnswer: (x) {
        stdout.write(x); //each word in the stream
    },
    onError: (e){},
    systemPrompt: 'Give a 100 word summary of the provided word. Only give the answer',
    userPrompt: 'Pizza',
    credential: 'AIza.....',
    stream: true,
);
```

### Directly Using a Model (eg: Gemini)
```dart
final LLMModel model = LLMProvider.gemini.getLLMByIdentifier('gemini-2.0-flash');
final ModelController controller = model.provider.modelController;
final payload = controller.inputPayload;
payload.systemPrompt = 'Say YES or NO';
payload.userPrompt = 'The sun sets in the west';
payload.credential = 'AIza....';
final genAIRequest = controller.createRequest(model, payload);
final answer = await GenerativeAI.executeGenAIRequest(model, genAIRequest);
print(answer)
```