import 'package:better_networking/better_networking.dart';
import '../models/models.dart';

abstract class ModelProvider {
  AIRequestModel get defaultAIRequestModel => throw UnimplementedError();

  HttpRequestModel? createRequest(AIRequestModel? aiRequestModel) {
    throw UnimplementedError();
  }

  String? outputFormatter(Map x) {
    throw UnimplementedError();
  }

  String? streamOutputFormatter(Map x) {
    throw UnimplementedError();
  }
}
