import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:better_networking/better_networking.dart';
import 'llm_config.dart';
import 'llm_model.dart';
import 'llm_request.dart';

class GenerativeAI {
  static Future<String?> executeGenAIRequest(
    LLMModel model,
    LLMRequestDetails requestDetails,
  ) async {
    final mC = model.provider.modelController;
    final headers = requestDetails.headers;
    // print(jsonEncode(requestDetails.body));
    final (response, _, _) = await sendHttpRequest(
      (Random().nextDouble() * 9999999 + 1).toString(),
      APIType.rest,
      HttpRequestModel(
        method: HTTPVerb.post,
        headers: [
          ...headers.entries.map(
            (x) => NameValueModel.fromJson({x.key: x.value}),
          ),
        ],
        url: requestDetails.endpoint,
        bodyContentType: ContentType.json,
        body: jsonEncode(requestDetails.body),
      ),
    );
    if (response == null) return null;
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

  static Future<Stream<String?>> streamGenAIRequest(
    LLMModel model,
    LLMRequestDetails requestDetails,
  ) async {
    final modelController = model.provider.modelController;

    final headers = {
      'Content-Type': 'application/json',
      ...requestDetails.headers,
    };

    final httpStream = await streamHttpRequest(
      requestDetails.hashCode.toString(),
      APIType.rest,
      HttpRequestModel(
        method: HTTPVerb.post,
        headers: headers.entries
            .map((entry) => NameValueModel(name: entry.key, value: entry.value))
            .toList(),
        url: requestDetails.endpoint,
        bodyContentType: ContentType.json,
        body: jsonEncode(requestDetails.body),
      ),
    );

    final streamController = StreamController<String?>();

    final subscription = httpStream.listen(
      (dat) {
        if (dat == null) {
          streamController.addError('STREAMING ERROR: NULL DATA');
          return;
        }

        final chunk = dat.$2;
        final error = dat.$4;

        if (chunk == null) {
          streamController.addError(error ?? 'NULL ERROR');
          return;
        }

        final ans = chunk.body;

        final lines = ans.split('\n');
        for (final line in lines) {
          if (!line.startsWith('data: ') || line.contains('[DONE]')) continue;
          final jsonStr = line.substring(6).trim();
          try {
            final jsonData = jsonDecode(jsonStr);
            final formattedOutput = modelController.streamOutputFormatter(
              jsonData,
            );
            streamController.sink.add(formattedOutput);
          } catch (e) {
            print('⚠️ JSON decode error in SSE: $e\Sending as Regular Text');
            streamController.sink.add(jsonStr);
          }
        }
      },
      onError: (error) {
        streamController.addError('STREAM ERROR: $error');
        streamController.close();
      },
      onDone: () {
        streamController.close();
      },
      cancelOnError: true,
    );

    streamController.onCancel = () async {
      await subscription.cancel();
    };

    return streamController.stream;
  }

  static callGenerativeModel(
    LLMModel model, {
    required Function(String?) onAnswer,
    required Function(dynamic) onError,
    required String systemPrompt,
    required String userPrompt,
    String? credential,
    String? endpoint,
    Map<String, LLMModelConfiguration>? configurations,
    bool stream = false,
  }) async {
    final c = model.provider.modelController;
    final payload = c.inputPayload;
    payload.systemPrompt = systemPrompt;
    payload.userPrompt = userPrompt;
    if (credential != null) {
      payload.credential = credential;
    }
    if (configurations != null) {
      payload.configMap.addAll(configurations);
    }
    if (endpoint != null) {
      payload.endpoint = endpoint;
    }
    try {
      if (stream) {
        final streamRequest = c.createRequest(model, payload, stream: true);
        final answerStream = await streamGenAIRequest(model, streamRequest);
        processGenAIStreamOutput(answerStream, (w) {
          onAnswer('$w ');
        }, onError);
      } else {
        final request = c.createRequest(model, payload);
        final answer = await executeGenAIRequest(model, request);
        onAnswer(answer);
      }
    } catch (e) {
      onError(e);
    }
  }

  static void processGenAIStreamOutput(
    Stream<String?> stream,
    Function(String) onWord,
    Function(dynamic) onError,
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
      onError: (e) {
        onError(e);
      },
    );
  }
}
