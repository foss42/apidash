import '../../models/models.dart';
import '../consts.dart';
import 'openai.dart';

class OllamaModel extends OpenAIModel {
  static final instance = OllamaModel();

  @override
  ModelRequestData get defaultRequestData => kDefaultModelRequestData.copyWith(
    url: kOllamaUrl,
    modelConfigs: [kDefaultModelConfigTemperature, kDefaultModelConfigTopP],
  );
}
