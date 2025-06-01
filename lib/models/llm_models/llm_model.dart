import 'dart:convert';

import 'package:apidash/models/llm_models/llm_config.dart';
import 'package:apidash_core/apidash_core.dart' as http;

abstract class LLMModel {
  abstract String providerIcon;
  abstract String provider;
  abstract String modelIdentifier;
  abstract String modelName;
  abstract LLMModelAuthorizationType authorizationType;
  abstract Map<String, LLMModelConfiguration> configurations;
  abstract LLMModelSpecifics specifics;
  Map getRequestPayload({
    required String systemPrompt,
    required String userPrompt,
    required String credential,
  });
  loadConfigurations(Map configMap);
}

extension LLMModelExtensions on LLMModel {
  Future<String?> call({
    required String systemPrompt,
    required String userPrompt,
    required String credential,
  }) async {
    final reqData = getRequestPayload(
      systemPrompt: systemPrompt,
      userPrompt: userPrompt,
      credential: credential,
    );
    print('calling => ${reqData['url']}');
    final headers = reqData['headers'] ?? specifics.headers;
    final response = await http.post(
      Uri.parse(reqData['url']),
      headers: {'Content-Type': 'application/json', ...headers},
      body: jsonEncode(reqData['payload']),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return specifics.outputFormatter(data);
    } else {
      print(reqData['url']);
      print(response.body);
      throw Exception(
        'LLM_EXCEPTION: ${response.statusCode}\n${response.body}',
      );
    }
  }
}

enum LLMModelAuthorizationType {
  bearerToken('Bearer Token'),
  apiKey('API Key'),
  none('No Authorization');

  const LLMModelAuthorizationType(this.label);
  final String label;
}

class LLMModelSpecifics {
  final String endpoint;
  final String method;
  final Map<String, dynamic> headers;
  final String? Function(Map?) outputFormatter;

  LLMModelSpecifics({
    required this.endpoint,
    required this.method,
    required this.headers,
    required this.outputFormatter,
  });
}
