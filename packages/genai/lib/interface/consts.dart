import '../consts.dart';
import '../models/models.dart';
import 'model_providers/model_providers.dart';

enum ModelAPIProvider {
  openai,
  anthropic,
  gemini,
  azureopenai,
  ollama,
  openaiCompatible,
}

final kModelProvidersMap = {
  ModelAPIProvider.openai: OpenAIModel.instance,
  ModelAPIProvider.anthropic: AnthropicModel.instance,
  ModelAPIProvider.gemini: GeminiModel.instance,
  ModelAPIProvider.azureopenai: AzureOpenAIModel.instance,
  ModelAPIProvider.ollama: OllamaModel.instance,
  ModelAPIProvider.openaiCompatible: OpenAICompatibleModel.instance,
};

const kAnthropicUrl = 'https://api.anthropic.com/v1/messages';
const kGeminiUrl = 'https://generativelanguage.googleapis.com/v1beta/models';
const kOpenAIUrl = 'https://api.openai.com/v1/chat/completions';
const kOllamaUrl = '$kBaseOllamaUrl/v1/chat/completions';

final kDefaultAiRequestModel = AIRequestModel(
  url: '',
  model: '',
  apiKey: '',
  systemPrompt: '',
  userPrompt: '',
  modelConfigs: [
    kDefaultModelConfigTemperature,
    kDefaultModelConfigTopP,
    kDefaultModelConfigMaxTokens,
  ],
  stream: false,
);

final kDefaultModelConfigTemperature = ModelConfig(
  id: 'temperature',
  name: 'Temperature',
  description: 'The Temperature of the Model',
  type: ConfigType.slider,
  value: ConfigSliderValue(value: (0, 0.5, 1)),
);

final kDefaultModelConfigTopP = ModelConfig(
  id: 'top_p',
  name: 'Top P',
  description: 'The Top P of the Model',
  type: ConfigType.slider,
  value: ConfigSliderValue(value: (0, 0.95, 1)),
);

final kDefaultModelConfigMaxTokens = ModelConfig(
  id: 'max_tokens',
  name: 'Maximum Tokens',
  description: 'The maximum number of tokens allowed in the output',
  type: ConfigType.numeric,
  value: ConfigNumericValue(value: 1024),
);

final kDefaultModelConfigStream = ModelConfig(
  id: 'stream',
  name: 'Enable Streaming Mode',
  description: 'The LLM output will be sent in a stream instead of all at once',
  type: ConfigType.boolean,
  value: ConfigBooleanValue(value: false),
);

final kDefaultGeminiModelConfigTopP = kDefaultModelConfigTopP.copyWith(
  id: 'topP',
);

final kDefaultGeminiModelConfigMaxTokens = kDefaultModelConfigMaxTokens
    .copyWith(id: 'maxOutputTokens');
