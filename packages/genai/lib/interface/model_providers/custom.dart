import '../../models/models.dart';
import '../consts.dart';
import 'openai.dart';

class CustomModel extends OpenAIModel {
  static final instance = CustomModel();

  @override
  AIRequestModel get defaultAIRequestModel => kDefaultAiRequestModel.copyWith(
    modelApiProvider: ModelAPIProvider.custom,
    url: '',
  );
}
