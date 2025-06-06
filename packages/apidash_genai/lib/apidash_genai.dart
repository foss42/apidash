import 'dart:convert';
import 'dart:io';
// import 'package:apidash_core/apidash_core.dart' as http;
import 'package:apidash_genai/llm_config.dart';
import 'package:apidash_genai/providers/providers.dart';
import 'package:http/http.dart' as http;
import 'package:apidash_genai/llm_request.dart';
import 'package:apidash_genai/providers/common.dart';

class GenerativeAI {
  static Future<String?> executeGenAIRequest(
    LLMModel model,
    LLMRequestDetails requestDetails,
  ) async {
    final mC = getLLMModelControllerByProvider(model.provider);
    final headers = requestDetails.headers;
    // print(jsonEncode(requestDetails.body));
    final response = await http.post(
      Uri.parse(requestDetails.endpoint),
      headers: {'Content-Type': 'application/json', ...headers},
      body: jsonEncode(requestDetails.body),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // print(data);
      return mC.outputFormatter(data);
    } else {
      print(requestDetails.endpoint);
      print(response.body);
      throw Exception(
        'LLM_EXCEPTION: ${response.statusCode}\n${response.body}',
      );
    }
  }

  static Stream<String?> streamGenAIRequest(
    LLMModel model,
    LLMRequestDetails requestDetails,
  ) async* {
    final modelController = getLLMModelControllerByProvider(model.provider);

    final uri = Uri.parse(requestDetails.endpoint);
    final headers = {
      'Content-Type': 'application/json',
      ...requestDetails.headers,
    };

    final request = http.Request('POST', uri)
      ..headers.addAll(headers)
      ..body = jsonEncode(requestDetails.body);

    final client = http.Client();
    http.StreamedResponse? streamedResponse;

    try {
      streamedResponse = await client.send(request);

      if (streamedResponse.statusCode != 200) {
        final errorText = await streamedResponse.stream.bytesToString();

        throw Exception(
          'LLM_STREAM_EXCEPTION: ${streamedResponse.statusCode}\n$errorText',
        );
      }

      final utf8Stream = streamedResponse.stream.transform(utf8.decoder);

      await for (final chunk in utf8Stream) {
        final lines = chunk.split('\n');

        for (final line in lines) {
          if (!line.startsWith('data: ') || line.contains('[DONE]')) continue;

          final jsonStr = line.substring(6); // Strip 'data: '

          try {
            final jsonData = jsonDecode(jsonStr);
            final output = modelController.streamOutputFormatter(jsonData);
            yield output;
          } catch (e, sT) {
            print('⚠️ Error parsing SSE JSON: $e');
          }
        }
      }
    } catch (e) {
      print('🚨 Error during streaming: $e');
      rethrow;
    } finally {
      client.close();
    }
  }

  static callGenerativeModel(
    LLMModel model, {
    required Function(String?) onAnswer,
    required String systemPrompt,
    required String userPrompt,
    String? credential,
    String? endpoint,
    Map<String, LLMModelConfiguration>? configurations,
    bool stream = false,
  }) async {
    final c = getLLMModelControllerByProvider(model.provider);
    final payload = c.inputPayload;
    payload.systemPrompt = systemPrompt;
    payload.userPrompt = userPrompt;
    if (credential != null) {
      payload.credential = credential;
    }
    if (configurations != null) {
      payload.configMap = configurations;
    }
    if (endpoint != null) {
      payload.endpoint = endpoint;
    }
    if (stream) {
      final streamRequest = c.createRequest(model, payload, stream: true);
      final answerStream = streamGenAIRequest(model, streamRequest);
      processGenAIStreamOutput(answerStream, (w) {
        onAnswer('$w ');
      });
    } else {
      final request = c.createRequest(model, payload);
      final answer = await executeGenAIRequest(model, request);
      onAnswer(answer);
    }
  }

  static void processGenAIStreamOutput(
    Stream<String?> stream,
    Function(String) onWord,
  ) {
    String buffer = '';
    stream.listen(
      (chunk) {
        if (chunk == null || chunk.isEmpty) return;
        buffer += chunk;
        // Split on spaces but preserve last partial word
        final parts = buffer.split(RegExp(r'\s+'));
        if (parts.length > 1) {
          // Keep the last part in buffer (it may be incomplete)
          buffer = parts.removeLast();
          for (final word in parts) {
            if (word.trim().isNotEmpty) {
              onWord(word);
            }
          }
        }
      },
      onDone: () {
        // Print any remaining word when stream is finished
        if (buffer.trim().isNotEmpty) {
          onWord(buffer);
        }
      },
    );
  }
}
