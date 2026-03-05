import '../../models/models.dart';
import '../consts.dart';
import 'openai.dart';

class MistralModel extends OpenAIModel {
  static final instance = MistralModel();

  @override
  AIRequestModel get defaultAIRequestModel => kDefaultAiRequestModel.copyWith(
    modelApiProvider: ModelAPIProvider.mistral,
    url: kMistralUrl,
  );
}
