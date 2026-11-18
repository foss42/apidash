import 'package:better_networking/better_networking.dart';
import '../models/models.dart';

abstract class ModelProvider {
  AIRequestModel get defaultAIRequestModel;

  HttpRequestModel? createRequest(AIRequestModel? aiRequestModel);

  String? outputFormatter(Map x);

  String? streamOutputFormatter(Map x);
}
