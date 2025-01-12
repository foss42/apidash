import '../consts.dart';
import '../models/models.dart';

String? getGraphQLBody(HttpRequestModel httpRequestModel) {
  if (httpRequestModel.hasQuery) {
    return kJsonEncoder.convert({
      "query": httpRequestModel.query,
    });
  }
  return null;
}
