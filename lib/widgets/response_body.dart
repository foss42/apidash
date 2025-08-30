import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/utils/utils.dart';
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
          message: '$kNullResponseModelError $kUnexpectedRaiseIssue');
    }

    final isSSE = responseModel.sseOutput?.isNotEmpty ?? false;
    var body = responseModel.body;
    var formattedBody = responseModel.formattedBody;
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
    // Fix #415: Treat null Content-type as plain text instead of Error message
    // if (mediaType == null) {
    //   return ErrorMessage(
    //       message:
    //           '$kMsgUnknowContentType - ${responseModel.contentType}. $kUnexpectedRaiseIssue');
    // }

    var responseBodyView = selectedRequestModel?.apiType == APIType.ai
        ? (kAnswerRawBodyViewOptions, kSubTypePlain)
        : getResponseBodyViewOptions(mediaType);
    var options = responseBodyView.$1;
    var highlightLanguage = responseBodyView.$2;

    if (formattedBody == null) {
      options = [...options];
      options.remove(ResponseBodyView.code);
    }

    if (responseModel.sseOutput?.isNotEmpty ?? false) {
      return ResponseBodySuccess(
        key: Key("${selectedRequestModel!.id}-response"),
        mediaType: MediaType('text', 'event-stream'),
        options: [ResponseBodyView.sse, ResponseBodyView.raw],
        bytes: utf8.encode((responseModel.sseOutput!).toString()),
        body: jsonEncode(responseModel.sseOutput!),
        formattedBody: responseModel.sseOutput!.join('\n'),
        aiRequestModel: selectedRequestModel?.aiRequestModel,
        isPartOfHistory: isPartOfHistory,
        sseOutput: responseModel.sseOutput,
      );
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
}
