import '../../models/models.dart';
import '../consts.dart';
import 'openai.dart';

class GroqModel extends OpenAIModel {
  static final instance = GroqModel();

  @override
  AIRequestModel get defaultAIRequestModel => kDefaultAiRequestModel.copyWith(
    modelApiProvider: ModelAPIProvider.groq,
    url: kGroqUrl,
  );
}
