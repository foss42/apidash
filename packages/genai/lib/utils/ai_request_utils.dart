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

        final lines = ans.split('\n');
        for (final line in lines) {
          if (!line.startsWith('data: ') || line.contains('[DONE]')) continue;
          final jsonStr = line.substring(6).trim();
          try {
            final jsonData = jsonDecode(jsonStr);
            final formattedOutput = aiRequestModel?.getFormattedStreamOutput(
              jsonData,
            );
            streamController.sink.add(formattedOutput);
          } catch (e) {
            debugPrint(
              '⚠️ JSON decode error in SSE: $e\nSending as Regular Text',
            );
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
