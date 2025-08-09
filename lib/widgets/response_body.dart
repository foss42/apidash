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
  });

  final RequestModel? selectedRequestModel;

  @override
  Widget build(BuildContext context) {
    HttpResponseModel? httpResponseModel =
        selectedRequestModel?.httpResponseModel;

    if (httpResponseModel == null) {
      return const ErrorMessage(
          message: '$kNullResponseModelError $kUnexpectedRaiseIssue');
    }

    final isSSE = httpResponseModel.sseOutput?.isNotEmpty ?? false;
    var body = httpResponseModel.body;
    var formattedBody = httpResponseModel.formattedBody;

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
    if (isSSE) {
      body = httpResponseModel.sseOutput!.join();
    }

    final mediaType =
        httpResponseModel.mediaType ?? MediaType(kTypeText, kSubTypePlain);

    // Fix #415: Treat null Content-type as plain text instead of Error message
    // if (mediaType == null) {
    //   return ErrorMessage(
    //       message:
    //           '$kMsgUnknowContentType - ${responseModel.contentType}. $kUnexpectedRaiseIssue');
    // }

    var responseBodyView = selectedRequestModel?.apiType == APIType.ai
        ? ([ResponseBodyView.answer, ResponseBodyView.raw], 'text')
        : getResponseBodyViewOptions(mediaType);
    var options = responseBodyView.$1;
    var highlightLanguage = responseBodyView.$2;

    if (formattedBody == null) {
      options = [...options];
      options.remove(ResponseBodyView.code);
    }

    if (httpResponseModel.sseOutput?.isNotEmpty ?? false) {
      return ResponseBodySuccess(
        key: Key("${selectedRequestModel!.id}-response"),
        mediaType: MediaType('text', 'event-stream'),
        options: [ResponseBodyView.sse, ResponseBodyView.raw],
        bytes: utf8.encode((httpResponseModel.sseOutput!).toString()),
        body: jsonEncode(httpResponseModel.sseOutput!),
        formattedBody: httpResponseModel.sseOutput!.join('\n'),
        selectedModel: selectedRequestModel?.aiRequestModel?.model,
      );
    }

    return ResponseBodySuccess(
      key: Key("${selectedRequestModel!.id}-response"),
      mediaType: mediaType,
      options: options,
      bytes: httpResponseModel.bodyBytes!,
      body: body,
      formattedBody: formattedBody,
      highlightLanguage: highlightLanguage,
      selectedModel: selectedRequestModel?.aiRequestModel?.model,
    );
  }
}
