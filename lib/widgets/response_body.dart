import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';
import 'a2ui_renderer.dart';
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
          message: '$kNullResponseModelError $kUnexpectedRaiseIssue');
    }

    var body = responseModel.body;

    if (body == null) {
      return const ErrorMessage(
          message: '$kMsgNullBody $kUnexpectedRaiseIssue');
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

    var responseBodyView = _resolveViewOptions(
      body: body,
      mediaType: mediaType,
      apiType: selectedRequestModel?.apiType,
    );
    var options = responseBodyView.$1;
    var highlightLanguage = responseBodyView.$2;

    final isSSE = responseModel.sseOutput?.isNotEmpty ?? false;
    var formattedBody = isSSE
        ? responseModel.sseOutput!.join('\n')
        : responseModel.formattedBody;

    if (formattedBody == null) {
      options = [...options];
      options.remove(ResponseBodyView.code);
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
    );
  }

  static (List<ResponseBodyView>, String?) _resolveViewOptions({
    required String body,
    required MediaType mediaType,
    APIType? apiType,
  }) {
    if (mediaType.type == kTypeApplication &&
        mediaType.subtype == kSubTypeJson) {
      try {
        final json = jsonDecode(body);
        if (json is Map<String, dynamic>) {
          if (OpenResponsesResult.isOpenResponsesFormat(json)) {
            return (kStructuredRawBodyViewOptions, null);
          }
        }
      } catch (_) {}
    }

    if (A2UIParser.isA2UIPayload(body)) {
      return (kGenUIRawBodyViewOptions, null);
    }

    if (apiType == APIType.ai) {
      return (kAnswerRawBodyViewOptions, kSubTypePlain);
    }

    return getResponseBodyViewOptions(mediaType);
  }
}
