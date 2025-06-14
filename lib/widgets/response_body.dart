import 'package:flutter/material.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';
import 'package:genai/models/ai_response_model.dart';
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
    HttpResponseModel? httpResponseModel;
    AIResponseModel? aiResponseModel;

    httpResponseModel = selectedRequestModel?.httpResponseModel;
    aiResponseModel = selectedRequestModel?.aiResponseModel;

    if (aiResponseModel == null && httpResponseModel == null) {
      return const ErrorMessage(
          message: '$kNullResponseModelError $kUnexpectedRaiseIssue');
    }

    var body = aiResponseModel?.body ?? httpResponseModel!.body;
    var formattedBody = aiResponseModel?.formattedBody ??
        httpResponseModel?.formattedBody ??
        body; //LAST OPTION IS TO SHOW UNFORMATTED BODY

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

    final mediaType = aiResponseModel?.mediaType ??
        httpResponseModel?.mediaType ??
        MediaType(kTypeText, kSubTypePlain);

    // Fix #415: Treat null Content-type as plain text instead of Error message
    // if (mediaType == null) {
    //   return ErrorMessage(
    //       message:
    //           '$kMsgUnknowContentType - ${responseModel.contentType}. $kUnexpectedRaiseIssue');
    // }

    var responseBodyView = aiResponseModel != null
        ? ([ResponseBodyView.answer, ResponseBodyView.raw], 'text')
        : getResponseBodyViewOptions(mediaType);
    var options = responseBodyView.$1;
    var highlightLanguage = responseBodyView.$2;

    if (formattedBody == null) {
      options = [...options];
      options.remove(ResponseBodyView.code);
    }

    return ResponseBodySuccess(
      key: Key("${selectedRequestModel!.id}-response"),
      mediaType: mediaType,
      options: options,
      bytes: aiResponseModel?.bodyBytes ?? httpResponseModel!.bodyBytes!,
      body: body,
      formattedBody: formattedBody,
      highlightLanguage: highlightLanguage,
    );
  }
}
