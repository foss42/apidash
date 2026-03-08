import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:genai/interface/model_providers/azureopenai.dart';
import 'package:genai/models/ai_request_model.dart';
import 'package:genai/interface/consts.dart';

void main() {
  group('AzureOpenAIModel', () {
    test('should return default AIRequestModel with Azure configs', () {
      final defaultModel = AzureOpenAIModel.instance.defaultAIRequestModel;

      expect(defaultModel.modelApiProvider,
          equals(ModelAPIProvider.azureopenai));
    });

    test('should create correct HttpRequestModel', () {
      const req = AIRequestModel(
        modelApiProvider: ModelAPIProvider.azureopenai,
        url: 'https://my-resource.openai.azure.com/openai/deployments/gpt-4/chat/completions?api-version=2024-02-01',
        model: 'gpt-4',
        apiKey: 'azure-key',
        userPrompt: 'Hello',
        systemPrompt: 'You are helpful',
        stream: false,
      );

      final httpReq = AzureOpenAIModel.instance.createRequest(req)!;

      expect(httpReq.method.name, equals('post'));
      expect(httpReq.authModel?.type.name, equals('apiKey'));
      expect(httpReq.authModel?.apikey?.key, equals('azure-key'));
      expect(httpReq.authModel?.apikey?.name, equals('api-key'));
    });

    test('should throw exception when url is empty', () {
      const req = AIRequestModel(
        modelApiProvider: ModelAPIProvider.azureopenai,
        url: '',
        model: 'gpt-4',
        apiKey: 'azure-key',
        userPrompt: 'Hello',
        systemPrompt: 'Sys',
      );

      expect(
        () => AzureOpenAIModel.instance.createRequest(req),
        throwsException,
      );
    });

    test('should include stream flag when streaming is enabled', () {
      const req = AIRequestModel(
        modelApiProvider: ModelAPIProvider.azureopenai,
        url: 'https://test.openai.azure.com/endpoint',
        model: 'gpt-4',
        apiKey: 'azure-key',
        userPrompt: 'Hello',
        systemPrompt: 'Sys',
        stream: true,
      );

      final httpReq = AzureOpenAIModel.instance.createRequest(req)!;
      final body = jsonDecode(httpReq.body!) as Map<String, dynamic>;

      expect(body['stream'], true);
    });

    test('should use "Generate" as default user prompt when empty', () {
      const req = AIRequestModel(
        modelApiProvider: ModelAPIProvider.azureopenai,
        url: 'https://test.openai.azure.com/endpoint',
        model: 'gpt-4',
        apiKey: 'azure-key',
        userPrompt: '',
        systemPrompt: 'Sys',
      );

      final httpReq = AzureOpenAIModel.instance.createRequest(req)!;
      final body = jsonDecode(httpReq.body!) as Map<String, dynamic>;
      final messages = body['messages'] as List;
      final userMessage = messages.firstWhere((m) => m['role'] == 'user');

      expect(userMessage['content'], 'Generate');
    });

    test('should return null for null request', () {
      final result = AzureOpenAIModel.instance.createRequest(null);
      expect(result, isNull);
    });

    test('should format output correctly', () {
      final response = {
        'choices': [
          {
            'message': {'content': '  Azure response  '},
          },
        ],
      };
      final output = AzureOpenAIModel.instance.outputFormatter(response);
      expect(output, equals('Azure response'));
    });

    test('should format stream output correctly', () {
      final response = {
        'choices': [
          {
            'delta': {'content': 'azure stream'},
          },
        ],
      };
      final output = AzureOpenAIModel.instance.streamOutputFormatter(response);
      expect(output, equals('azure stream'));
    });

    test('should return null for malformed output', () {
      expect(AzureOpenAIModel.instance.outputFormatter({}), isNull);
      expect(AzureOpenAIModel.instance.streamOutputFormatter({}), isNull);
    });
  });
}
