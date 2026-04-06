# genai

A **unified Dart/Flutter package** for working with multiple Generative AI providers (Google Gemini, OpenAI, Anthropic, Azure OpenAI, Ollama, etc.) using a **single request model**.

- ✅ Supports **normal & streaming** responses
- ✅ Unified `AIRequestModel` across providers
- ✅ Configurable parameters (temperature, top-p, max tokens, etc.)
- ✅ Simple request utilities (`executeGenAIRequest`, `streamGenAIRequest`)
- ✅ Extensible — add your own provider easily

---

## 🚀 Installation

Add `genai` to your `pubspec.yaml`:

```yaml
dependencies:
  genai: ^0.1.0
```

Then run:

```bash
flutter pub get
```

---

## ⚡ Quick Start

### 1. Import the package

```dart
import 'package:genai/genai.dart';
```

### 2. Create a request

```dart
final request = AIRequestModel(
  modelApiProvider: ModelAPIProvider.gemini, // or openai, anthropic, etc.
  model: "gemini-2.0-flash",
  apiKey: "<YOUR_API_KEY>",
  url: kGeminiUrl,
  systemPrompt: "You are a helpful assistant.",
  userPrompt: "Explain quantum entanglement simply.",
  stream: false, // set true for streaming
);
```

### 3. Run a non-streaming request

```dart
final answer = await executeGenAIRequest(request);
print("AI Answer: $answer");
```

### 4. Run a streaming request (SSE)

```dart
final stream = await streamGenAIRequest(request.copyWith(stream: true));
stream.listen((chunk) {
  print("AI Stream Chunk: $chunk");
}, onError: (err) {
  print("Stream Error: $err");
});
```

### 5. Auto-handle both (recommended)

```dart
await callGenerativeModel(
  request,
  onAnswer: (ans) => print("AI Output: $ans"),
  onError: (err) => print("Error: $err"),
);
```

---

## ⚙️ Configuration

Each request accepts `modelConfigs` to fine-tune output.

Available configs (defaults provided):

- `temperature` → controls randomness
- `top_p` / `topP` → nucleus sampling probability
- `max_tokens` / `maxOutputTokens` → maximum length of output
- `stream` → enables streaming

Example:

```dart
final request = request.copyWith(
  modelConfigs: [
    kDefaultModelConfigTemperature.copyWith(
      value: ConfigSliderValue(value: (0, 0.8, 1)),
    ),
    kDefaultGeminiModelConfigMaxTokens.copyWith(
      value: ConfigNumericValue(value: 2048),
    ),
  ],
);
```

---

## 📡 Supported Providers

| Provider     | Enum Value                     | Default URL                                               |
| ------------ | ------------------------------ | --------------------------------------------------------- |
| OpenAI       | `ModelAPIProvider.openai`      | `https://api.openai.com/v1/chat/completions`              |
| Gemini       | `ModelAPIProvider.gemini`      | `https://generativelanguage.googleapis.com/v1beta/models` |
| Anthropic    | `ModelAPIProvider.anthropic`   | `https://api.anthropic.com/v1/messages`                   |
| Azure OpenAI | `ModelAPIProvider.azureopenai` | Provided by Azure deployment                              |
| Ollama       | `ModelAPIProvider.ollama`      | `$kBaseOllamaUrl/v1/chat/completions`                     |

---

## 🛠️ Advanced Streaming (Word-by-Word)

```dart
final stream = await streamGenAIRequest(request.copyWith(stream: true));

processGenAIStreamOutput(
  stream,
  (word) => print("Word: $word"), // called for each word
  (err) => print("Error: $err"),
);
```

---

## 🔒 Authentication

- **OpenAI / Anthropic / Azure OpenAI** → API key passed as HTTP header.
- **Gemini** → API key passed as query param `?key=YOUR_API_KEY`.
- **Ollama** → local server, no key required.

Just set `apiKey` in your `AIRequestModel`.

---

## 📦 Extending with New Providers

Want to add a new AI provider?

1. Extend `ModelProvider`
2. Implement:

   - `defaultAIRequestModel`
   - `createRequest()`
   - `outputFormatter()`
   - `streamOutputFormatter()`

3. Register in `kModelProvidersMap`

That’s it — it plugs into the same unified request flow.

---

## ✅ Example: Gemini

```dart
final request = GeminiModel.instance.defaultAIRequestModel.copyWith(
  model: "gemini-pro",
  apiKey: "<YOUR_KEY>",
  userPrompt: "Write me a haiku about Flutter.",
);

final answer = await executeGenAIRequest(request);
print(answer);
```

---

## 🤝 Contributing

We welcome contributions to the `genai` package! If you'd like to contribute, please fork the repository and submit a pull request. For major changes or new features, it's a good idea to open an issue first to discuss your ideas.

## Maintainer(s)

- Ankit Mahato ([GitHub](https://github.com/animator), [LinkedIn](https://www.linkedin.com/in/ankitmahato/), [X](https://x.com/ankitmahato))
- Ashita Prasad ([GitHub](https://github.com/ashitaprasad), [LinkedIn](https://www.linkedin.com/in/ashitaprasad/), [X](https://x.com/ashitaprasad))
- Manas Hejmadi (contributor) ([GitHub](https://github.com/synapsecode))

## License

This project is licensed under the [Apache License 2.0](https://github.com/foss42/apidash/blob/main/packages/genai/LICENSE).
