import '../../models/models.dart';
import '../consts.dart';
import 'openai.dart';

class OllamaModel extends OpenAIModel {
  static final instance = OllamaModel();

  @override
  AIRequestModel get defaultAIRequestModel => kDefaultAiRequestModel.copyWith(
    modelApiProvider: ModelAPIProvider.ollama,
    url: kOllamaUrl,
    modelConfigs: [kDefaultModelConfigTemperature, kDefaultModelConfigTopP],
  );
}
