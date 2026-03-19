import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';

class OpenApiIO {
  List<HttpRequestModel>? getHttpRequestModelList(String content) {
    final Map<String, dynamic> data = jsonDecode(content);

    final paths = data['paths'] as Map<String, dynamic>?;

    if (paths == null) return null;

    List<HttpRequestModel> requests = [];

    paths.forEach((path, methods) {
      (methods as Map<String, dynamic>).forEach((method, details) {
        requests.add(
          HttpRequestModel(
            method: method.toUpperCase(),
            url: path,
          ),
        );
      });
    });

    return requests;
  }
}
