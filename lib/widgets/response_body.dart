import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/utils/openresponses_adapter.dart';
import 'package:apidash/utils/llm_json_extract.dart';
import 'package:apidash/consts.dart';

import 'error_message.dart';
import 'response_body_success.dart';

class ResponseBody extends StatelessWidget {
  const ResponseBody({
    super.key,
    this.selectedRequestModel,
    this.isPartOfHistory = false,
  });

  final RequestModel? selectedRequestModel;
  final bool isPartOfHistory;

  @override
  Widget build(BuildContext context) {
    final responseModel = selectedRequestModel?.httpResponseModel;
    if (responseModel == null) {
      return const ErrorMessage(
        message: '$kNullResponseModelError $kUnexpectedRaiseIssue',
      );
    }

    final body = responseModel.body;
    if (body == null) {
      return const ErrorMessage(
        message: '$kMsgNullBody $kUnexpectedRaiseIssue',
      );
    }
    if (body.isEmpty) {
      return const ErrorMessage(
        message: kMsgNoContent,
        showIcon: false,
        showIssueButton: false,
      );
    }

    final mediaType =
        responseModel.mediaType ?? MediaType(kTypeText, kSubTypePlain);

    // Choose view options (AI responses default to raw/plain)
    final responseBodyView = selectedRequestModel?.apiType == APIType.ai
        ? (kAnswerRawBodyViewOptions, kSubTypePlain)
        : getResponseBodyViewOptions(mediaType);
    var options = responseBodyView.$1;
    final highlightLanguage = responseBodyView.$2;

    final isSSE = responseModel.sseOutput?.isNotEmpty ?? false;
    final formattedBody = isSSE
        ? responseModel.sseOutput!.join('\n')
        : responseModel.formattedBody;

    if (formattedBody == null) {
      options = [...options];
      options.remove(ResponseBodyView.code);
    }

    Map<String, dynamic>? openResponsesRoot;

    // Detect OpenResponses payloads for JSON media types
    if (mediaType.type == kTypeApplication &&
        mediaType.subtype.contains(kSubTypeJson)) {
      try {
        dynamic decoded;
        if (selectedRequestModel?.apiType == APIType.ai) {
          final extracted = LlmJsonExtract.tryExtractJson(body);
          try {
            decoded = jsonDecode(extracted ?? body);
          } catch (_) {
            decoded = jsonDecode(body);
          }

          if (decoded is Map) {
            String? embedded;
            final choices = decoded['choices'];
            if (choices is List && choices.isNotEmpty) {
              final first = choices.first;
              if (first is Map) {
                final msg = first['message'];
                if (msg is Map) {
                  final content = msg['content'];
                  if (content is String) embedded = content;
                }
              }
            }

            if (embedded != null && embedded.isNotEmpty) {
              final extractedEmbedded = LlmJsonExtract.tryExtractJson(embedded);
              if (extractedEmbedded != null) {
                try {
                  decoded = jsonDecode(extractedEmbedded);
                } catch (_) {
                  // ignore and keep original decoded
                }
              }
            }
          }
        } else {
          decoded = jsonDecode(body);
        }

        // If AI, allow adapter to convert; otherwise use decoded directly
        final dynamic source = selectedRequestModel?.apiType == APIType.ai
            ? (OpenResponsesAdapter.tryConvert(decoded) ?? decoded)
            : decoded;

        if (source is Map<String, dynamic>) {
          final output = source['output'];

          final isValidOpenResponses =
              output is List &&
              output.isNotEmpty &&
              output.every((e) => e is Map && e.containsKey('type'));

          if (isValidOpenResponses) {
            openResponsesRoot = source;
            if (!options.contains(ResponseBodyView.structured)) {
              options = [...options, ResponseBodyView.structured];
            }
          }
        }
      } catch (_) {
        // Ignore JSON parse errors for OpenResponses detection
      }
    }

    return ResponseBodySuccess(
      key: Key("${selectedRequestModel!.id}-response"),
      mediaType: mediaType,
      options: options,
      bytes: responseModel.bodyBytes!,
      body: body,
      formattedBody: formattedBody,
      highlightLanguage: highlightLanguage,
      sseOutput: responseModel.sseOutput,
      isAIResponse: selectedRequestModel?.apiType == APIType.ai,
      aiRequestModel: selectedRequestModel?.aiRequestModel,
      isPartOfHistory: isPartOfHistory,
      openResponsesRoot: openResponsesRoot,
    );
  }
}
