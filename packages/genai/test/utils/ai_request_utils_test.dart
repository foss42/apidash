import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:genai/models/ai_request_model.dart';
import 'package:genai/interface/consts.dart';
import 'package:genai/utils/ai_request_utils.dart';

void main() {
  late HttpServer server;
  late String serverUrl;

  setUpAll(() async {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    serverUrl = 'http://${server.address.host}:${server.port}';

    server.listen((HttpRequest request) async {
      final path = request.uri.path;
      if (path.contains('success')) {
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.json
          ..write(
            jsonEncode({
              "candidates": [
                {
                  "content": {
                    "parts": [
                      {"text": "mock response"},
                    ],
                  },
                },
              ],
            }),
          )
          ..close();
      } else if (path.contains('error') && !path.contains('stream')) {
        request.response
          ..statusCode = HttpStatus.badRequest
          ..write('Error')
          ..close();
      } else if (path.contains('stream_error')) {
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType('text', 'event-stream')
          ..write('data: invalid_json\n\n')
          ..close();
      } else if (path.contains('stream')) {
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType('text', 'event-stream')
          ..write(
            'data: {"candidates":[{"content":{"parts":[{"text":"mock "}]}}]}\n\n',
          )
          ..write(
            'data: {"candidates":[{"content":{"parts":[{"text":"stream"}]}}]}\n\n',
          )
          ..write('data: [DONE]\n\n')
          ..close();
      } else {
        request.response
          ..statusCode = HttpStatus.notFound
          ..close();
      }
    });
  });

  tearDownAll(() async {
    await server.close(force: true);
  });

  group('ai_request_utils', () {
    test(
      'executeGenAIRequest should return formatted output on success',
      () async {
        var model = AIRequestModel(
          modelApiProvider: ModelAPIProvider.gemini,
          model: 'gemini-2.0-flash',
          url: '$serverUrl/success',
          userPrompt: 'Convert the Given Number into Binary',
          systemPrompt: '1',
          apiKey: 'fake_key',
        );
        final result = await executeGenAIRequest(model);
        expect(result, 'mock response');
      },
    );

    test('executeGenAIRequest returns null on error', () async {
      var model = AIRequestModel(
        modelApiProvider: ModelAPIProvider.gemini,
        url: '$serverUrl/error',
        apiKey: 'fake_key',
      );
      final result = await executeGenAIRequest(model);
      expect(result, isNull);
    });

    test('executeGenAIRequest returns null when model is null', () async {
      final result = await executeGenAIRequest(null);
      expect(result, isNull);
    });

    test('streamGenAIRequest works correctly', () async {
      var model = AIRequestModel(
        modelApiProvider: ModelAPIProvider.gemini,
        url: '$serverUrl/stream',
        apiKey: 'fake_key',
      );
      final stream = await streamGenAIRequest(model);
      final results = await stream.toList();
      expect(results, ['mock ', 'stream']);
    });

    test('streamGenAIRequest fallback to plain string on json error', () async {
      var model = AIRequestModel(
        modelApiProvider: ModelAPIProvider.gemini,
        url: '$serverUrl/stream_error',
        apiKey: 'fake_key',
      );
      final stream = await streamGenAIRequest(model);
      final results = await stream.toList();
      expect(results, ['invalid_json']);
    });

    test('streamGenAIRequest with null model', () async {
      final stream = await streamGenAIRequest(null);
      final results = await stream.toList();
      expect(results, isEmpty);
    });

    test('callGenerativeModel calls onAnswer correctly', () async {
      var model = AIRequestModel(
        modelApiProvider: ModelAPIProvider.gemini,
        url: '$serverUrl/success',
        apiKey: 'fake_key',
        stream: false,
      );
      String? ans;
      await callGenerativeModel(
        model,
        onAnswer: (val) => ans = val,
        onError: (e) {},
      );
      expect(ans, 'mock response');
    });

    test('callGenerativeModel calls onAnswer for stream correctly', () async {
      var model = AIRequestModel(
        modelApiProvider: ModelAPIProvider.gemini,
        url: '$serverUrl/stream',
        apiKey: 'fake_key',
        stream: true,
      );
      List<String?> answers = [];
      await callGenerativeModel(
        model,
        onAnswer: (val) => answers.add(val),
        onError: (e) {},
      );
      // Let stream finish
      await Future.delayed(const Duration(milliseconds: 100));
      expect(answers, ['mock ', 'stream ']);
    });

    test('processGenAIStreamOutput handles words correctly', () async {
      final controller = StreamController<String?>();
      List<String> words = [];
      processGenAIStreamOutput(controller.stream, (w) => words.add(w), (e) {});

      controller.add("hello ");
      controller.add("world ");
      controller.add("this is a test");
      await controller.close();

      await Future.delayed(const Duration(milliseconds: 50));
      expect(words, ['hello', 'world', 'this', 'is', 'a', 'test']);
    });

    test('processGenAIStreamOutput handles errors', () async {
      final controller = StreamController<String?>();
      bool hasError = false;
      processGenAIStreamOutput(controller.stream, (w) {}, (e) {
        hasError = true;
      });

      controller.addError(Exception("stream error"));
      await Future.delayed(const Duration(milliseconds: 50));
      expect(hasError, isTrue);
    });

    test('callGenerativeModel catches error', () async {
      var model = AIRequestModel(
        modelApiProvider: ModelAPIProvider.gemini,
        url: 'invalid://url',
        apiKey: 'fake_key',
        stream: false,
      );
      bool hasError = false;
      await callGenerativeModel(
        model,
        onAnswer: (val) {},
        onError: (e) {
          hasError = true;
        },
      );
      expect(hasError, isTrue);
    });
  });
}
