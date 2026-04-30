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

    // Tracks the most recent SSE `event:` field so that `data:` lines can
    // be associated with their event type even across chunk boundaries.
    String? lastEventType;

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
          // Trim \r to handle both \n and \r\n line endings.
          final trimmedLine = line.trimRight();

          // An empty line signals the end of an SSE event block; reset the
          // tracked event type so it is not applied to the next block.
          if (trimmedLine.isEmpty) {
            lastEventType = null;
            continue;
          }

          // Capture the SSE event type for the current event block.
          if (trimmedLine.startsWith('event: ')) {
            lastEventType = trimmedLine.substring(7).trim();
            continue;
          }

          if (!trimmedLine.startsWith('data: ') ||
              trimmedLine.contains('[DONE]')) {
            continue;
          }

          final jsonStr = trimmedLine.substring(6).trim();
          try {
            final jsonData = jsonDecode(jsonStr);
            final formattedOutput = aiRequestModel?.getFormattedStreamOutput(
              jsonData,
              eventType: lastEventType,
            );
            // Only emit non-null, non-empty chunks to avoid polluting the
            // stream with unrelated SSE events (e.g. ping, message_start).
            if (formattedOutput != null && formattedOutput.isNotEmpty) {
              streamController.sink.add(formattedOutput);
            }
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
