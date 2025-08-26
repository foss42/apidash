# genai

`genai` is a lightweight and extensible Dart package designed to simplify AI requests and agentic operations. It provides an easy to use and seamless interface for various AI Providers such as (openai, gemini, antrhopic etc).

## 🔧 Features

- **Unified request modeling** via `HttpRequestModel`
- **Consistent response handling** with `HttpResponseModel`
- **Streamed response support** (e.g., SSE)
- **Client management** with cancellation and lifecycle control
- **Built-in utilities** for parsing headers and content types
- **Support for both REST and GraphQL APIs**

## 📦 Installation

To install the `genai` package, add it to your `pubspec.yaml`:

```yaml
dependencies:
  genai: ^<latest-version>
```

Then run the following command in your terminal to fetch the package:

```bash
flutter pub get
```

## 🚀 Quick Start

### Response Mode (Callback Style)

```dart
final LLMModel geminiModel = LLMProvider.gemini.getLLMByIdentifier('gemini-2.0-flash');
GenerativeAI.callGenerativeModel(
    geminiModel,
    onAnswer: (x) {
        print(x);
    },
    onError: (e){...},
    systemPrompt: 'Give a 100 word summary of the provided word',
    userPrompt: 'Pizza',
    credential: 'AIza.....',
);
```

### Streaming Mode (Callback Style)

```dart
final LLMModel geminiModel = LLMProvider.gemini.getLLMByIdentifier('gemini-2.0-flash');
final ModelController controller = model.provider.modelController;
GenerativeAI.callGenerativeModel(
    geminiModel,
    onAnswer: (x) {
        stdout.write(x); //get each word in the stream
    },
    onError: (e){},
    systemPrompt: 'Give a 100 word summary of the provided word',
    userPrompt: 'Pizza',
    credential: 'AIza.....',
    stream: true, //pass this to enable streaming
);
```

### Procedural(Manual) Request Building

```dart
final LLMModel model = LLMProvider.gemini.getLLMByIdentifier('gemini-2.0-flash');
final ModelController controller = model.provider.modelController;

final payload = controller.inputPayload
  ..systemPrompt = 'Say YES or NO'
  ..userPrompt = 'The sun sets in the west'
  ..credential = 'AIza....';

final genAIRequest = controller.createRequest(model, payload);
final answer = await GenerativeAI.executeGenAIRequest(model, genAIRequest);

print(answer);
```

## 🤝 Contributing

We welcome contributions to the `genai` package! If you'd like to contribute, please fork the repository and submit a pull request. For major changes or new features, it's a good idea to open an issue first to discuss your ideas.

## Maintainer

- Ashita Prasad ([GitHub](https://github.com/ashitaprasad), [LinkedIn](https://www.linkedin.com/in/ashitaprasad/), [X](https://x.com/ashitaprasad))
- Manas Hejmadi (contributor) ([GitHub](https://github.com/synapsecode))

## License

This project is licensed under the [Apache License 2.0](https://github.com/foss42/apidash/blob/main/packages/genai/LICENSE).
