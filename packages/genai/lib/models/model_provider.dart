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

  /// Builds a request that lists the models available to the authenticated
  /// account, or `null` when the provider cannot list models (e.g. Azure
  /// OpenAI, where deployments are managed in the Azure portal).
  ///
  /// [aiRequestModel] carries the user's API key and endpoint; providers
  /// that require a key return `null` when it is missing.
  HttpRequestModel? createListModelsRequest(AIRequestModel? aiRequestModel) {
    return null;
  }

  /// Parses the body of a [createListModelsRequest] response into [Model]s,
  /// or `null` when the body cannot be understood.
  List<Model>? parseListModelsResponse(String body) {
    return null;
  }
}
