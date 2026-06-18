import 'dart:async';
import 'dart:convert';
import 'package:better_networking/better_networking.dart';
import 'package:flutter/foundation.dart';
import 'package:nanoid/nanoid.dart';
import '../models/models.dart';

Future<String?> executeGenAIRequest(AIRequestModel? aiRequestModel) async {
  final httpRequestModel = aiRequestModel?.httpRequestModel;
  if (httpRequestModel == null) {
    debugPrint("executeGenAIRequest -> httpRequestModel is null");
    return null;
  }
  final (response, _, _) = await sendHttpRequest(
    nanoid(),
    APIType.rest,
    httpRequestModel,
  );
  if (response == null) return null;
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return aiRequestModel?.getFormattedOutput(data);
  } else {
    debugPrint('LLM_EXCEPTION: ${response.statusCode}\n${response.body}');
    return null;
  }
}

Future<Stream<String?>> streamGenAIRequest(
  AIRequestModel? aiRequestModel,
) async {
  final httpRequestModel = aiRequestModel?.httpRequestModel;
  final streamController = StreamController<String?>();
  if (httpRequestModel == null) {
    debugPrint("streamGenAIRequest -> httpRequestModel is null");
  } else {
    final httpStream = await streamHttpRequest(
      nanoid(),
      APIType.rest,
      httpRequestModel,
    );

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

        // 1. Standard SSE Parsing (OpenAI, etc.)
        if (ans.contains('data: ')) {
          final lines = ans.split('\n');
          for (final line in lines) {
            if (!line.startsWith('data: ') || line.contains('[DONE]')) continue;
            final jsonStr = line.substring(6).trim();
            try {
              final jsonData = jsonDecode(jsonStr);
              final formattedOutput = aiRequestModel?.getFormattedStreamOutput(jsonData);
              streamController.sink.add(formattedOutput);
            } catch (e) {
              streamController.sink.add(jsonStr);
            }
          }
          return;
        }

        // 2. Catch API Errors (like 429 Quota Exceeded)
        if (ans.contains('"error"') && ans.contains('"code"')) {
          streamController.addError('API Error: $ans');
          return;
        }

        // 3. Non-SSE JSON Stream (Gemini)
        // Surgically extract the "text" values from partial JSON chunks
        final regex = RegExp(r'"text"\s*:\s*"((?:\\.|[^"\\])*)"');
        final matches = regex.allMatches(ans);

        for (final match in matches) {
          final extracted = match.group(1);
          if (extracted != null) {
            try {
              // Unescape the raw JSON string
              final unescaped = jsonDecode('"$extracted"') as String;
              streamController.sink.add(unescaped);
            } catch (_) {
              // Fallback if decoding fails
              streamController.sink.add(extracted);
            }
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
  }
  return streamController.stream;
}

Future<void> callGenerativeModel(
  AIRequestModel? aiRequestModel, {
  required Function(String?) onAnswer,
  required Function(dynamic) onError,
}) async {
  if (aiRequestModel != null) {
    try {
      if (aiRequestModel.stream ?? false) {
        final answerStream = await streamGenAIRequest(aiRequestModel);
        processGenAIStreamOutput(answerStream, (w) {
          onAnswer('$w ');
        }, onError);
      } else {
        final answer = await executeGenAIRequest(aiRequestModel);
        onAnswer(answer);
      }
    } catch (e) {
      onError(e);
    }
  }
}

void processGenAIStreamOutput(
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
