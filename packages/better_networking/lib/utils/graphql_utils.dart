import 'dart:convert';

import '../consts.dart';
import '../models/models.dart';

String? getGraphQLBody(HttpRequestModel httpRequestModel) {
  if (!httpRequestModel.hasQuery) {
    return null;
  }

  final payload = <String, dynamic>{"query": httpRequestModel.query};
  final variablesText = httpRequestModel.variables?.trim();
  if (variablesText != null && variablesText.isNotEmpty) {
    try {
      final decoded = json.decode(variablesText);
      if (decoded is Map) {
        payload["variables"] = decoded;
      }
    } catch (_) {
      // Invalid JSON is omitted so the POST body stays valid JSON.
    }
  }
  return kJsonEncoder.convert(payload);
}
