import '../../models/models.dart';
import '../consts.dart';
import 'openai.dart';

class OpenAICompatibleModel extends OpenAIModel {
  static final instance = OpenAICompatibleModel();

  @override
  AIRequestModel get defaultAIRequestModel => kDefaultAiRequestModel.copyWith(
    modelApiProvider: ModelAPIProvider.openaiCompatible,
    modelConfigs: [kDefaultModelConfigTemperature, kDefaultModelConfigTopP],
  );
}
