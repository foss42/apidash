import 'dart:convert';
import '../consts.dart';
import '../models/models.dart';

String? getGraphQLBody(HttpRequestModel httpRequestModel) {
  if (httpRequestModel.hasQuery) {
    final Map<String, dynamic> graphqlBody = {"query": httpRequestModel.query};
    if (httpRequestModel.hasVariables) {
      try {
        graphqlBody["variables"] = jsonDecode(httpRequestModel.variables!);
      } catch (_) {
        // Keep the raw text if it isn't valid JSON so nothing is lost.
        graphqlBody["variables"] = httpRequestModel.variables;
      }
    }
    return kJsonEncoder.convert(graphqlBody);
  }
  return null;
}
