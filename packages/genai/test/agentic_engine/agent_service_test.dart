import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:genai/models/models.dart';
import 'package:genai/interface/consts.dart';
import 'package:genai/agentic_engine/agent_service.dart';
import 'package:genai/agentic_engine/blueprint.dart';

class MockAIAgent implements AIAgent {
  final bool failValidation;
  final bool throwException;

  MockAIAgent({this.failValidation = false, this.throwException = false});

  @override
  String get agentName => 'mock_agent';

  @override
  String getSystemPrompt() => 'Prompt with {{VAR}}';

  @override
  Future<dynamic> outputFormatter(String rawResponse) async => rawResponse.trim();

  @override
  Future<bool> validator(String response) async {
    if (throwException) throw Exception('validation error');
    return !failValidation;
  }
}

void main() {
  late HttpServer server;
  late String serverUrl;

  setUpAll(() async {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    serverUrl = 'http://${server.address.host}:${server.port}';

    server.listen((HttpRequest request) async {
      if (request.uri.path.contains('success')) {
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.json
          ..write(jsonEncode({
            "candidates": [
              {
                "content": {
                  "parts": [
                    {"text": "mock response "}
                  ]
                }
              }
            ]
          }))
          ..close();
      } else {
        request.response
          ..statusCode = HttpStatus.badRequest
          ..write('Error')
          ..close();
      }
    });
  });

  tearDownAll(() async {
    await server.close(force: true);
  });

  group('AIAgentService', () {
    test('callAgent returns formatted output on success', () async {
      var agent = MockAIAgent();
      var baseObject = AIRequestModel(
        modelApiProvider: ModelAPIProvider.gemini,
        model: 'gemini-2.0-flash',
        url: '$serverUrl/success',
        apiKey: 'fake_key',
      );

      final result = await AIAgentService.callAgent(
        agent,
        baseObject,
        query: 'query',
        variables: {'VAR': 'value'},
      );

      expect(result, 'mock response');
    });

    test('callAgent retries and returns null when validator fails', () async {
      var agent = MockAIAgent(failValidation: true);
      var baseObject = AIRequestModel(
        modelApiProvider: ModelAPIProvider.gemini,
        model: 'gemini-2.0-flash',
        url: '$serverUrl/success',
        apiKey: 'fake_key',
      );

      // Will retry 5 times and then return null
      final result = await AIAgentService.callAgent(
        agent,
        baseObject,
        query: 'query',
        variables: {'VAR': 'value'},
      );

      expect(result, isNull);
    });
    
    test('callAgent retries when exception occurs', () async {
      var agent = MockAIAgent(throwException: true);
      var baseObject = AIRequestModel(
        modelApiProvider: ModelAPIProvider.gemini,
        model: 'gemini-2.0-flash',
        url: '$serverUrl/success',
        apiKey: 'fake_key',
      );

      final result = await AIAgentService.callAgent(
        agent,
        baseObject,
        query: 'query',
      );

      expect(result, isNull);
    });
  });
}
