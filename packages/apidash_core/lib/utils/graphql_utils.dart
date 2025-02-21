import '../consts.dart';
import '../models/models.dart';

String? getGraphQLBody(HttpRequestModel httpRequestModel) {
  if (httpRequestModel.hasQuery) {
    final Map<String,dynamic> body = {
      "query": httpRequestModel.query,
    };

    if (httpRequestModel.isGraphqlVariablesEnabledList != null &&
        httpRequestModel.isGraphqlVariablesEnabledList!.isNotEmpty) {
        body["variables"] = httpRequestModel.enabledGraphqlVariablesMap;
    }

    return kJsonEncoder.convert(body);

  }
  return null;
}