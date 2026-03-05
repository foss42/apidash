import '../../models/models.dart';
import '../consts.dart';
import 'openai.dart';

class OpenRouterModel extends OpenAIModel {
  static final instance = OpenRouterModel();

  @override
  AIRequestModel get defaultAIRequestModel => kDefaultAiRequestModel.copyWith(
    modelApiProvider: ModelAPIProvider.openrouter,
    url: kOpenRouterUrl,
  );
}
