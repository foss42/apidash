import 'dart:convert';

import 'package:apidash/apitoolgen/request_consolidator.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/widgets/ai_toolgen_widgets.dart';
import 'package:apidash/widgets/ai_ui_desginer_widgets.dart';

import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'package:genai/genai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'button_share.dart';

class ResponseBodySuccess extends ConsumerStatefulWidget {
  const ResponseBodySuccess({
    super.key,
    required this.mediaType,
    required this.body,
    required this.options,
    required this.bytes,
    this.formattedBody,
    this.highlightLanguage,
    this.selectedModel,
  });
  final MediaType mediaType;
  final List<ResponseBodyView> options;
  final String body;
  final Uint8List bytes;
  final String? formattedBody;
  final String? highlightLanguage;
  final LLMModel? selectedModel; //ONLY FOR AI-REQUESTS

  @override
  ConsumerState<ResponseBodySuccess> createState() =>
      _ResponseBodySuccessState();
}

class _ResponseBodySuccessState extends ConsumerState<ResponseBodySuccess> {
  int segmentIdx = 0;

  @override
  Widget build(BuildContext context) {
    var currentSeg = widget.options[segmentIdx];
    var codeTheme = Theme.of(context).brightness == Brightness.light
        ? kLightCodeTheme
        : kDarkCodeTheme;
    final textContainerdecoration = BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      border: Border.all(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      borderRadius: kBorderRadius8,
    );

    final isAIRequest = widget.options.contains(ResponseBodyView.answer);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        var showLabel = showButtonLabelsInBodySuccess(
          widget.options.length,
          constraints.maxWidth,
        );
        return Padding(
          padding: kP10,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton.tonalIcon(
                    style: FilledButton.styleFrom(
                      padding: kPh12,
                      minimumSize: const Size(44, 44),
                    ),
                    onPressed: () async {
                      final requestModel = ref.watch(
                          selectedRequestModelProvider
                              .select((value) => value?.httpRequestModel));
                      final responseModel = ref.watch(
                          selectedRequestModelProvider
                              .select((value) => value?.httpResponseModel));

                      if (requestModel == null) return;
                      if (responseModel == null) {
                        print("AA");
                        return;
                      }

                      String? bodyTXT;
                      Map? bodyJSON;
                      List<Map>? bodyFormData;

                      if (requestModel.bodyContentType ==
                          ContentType.formdata) {
                        bodyFormData = requestModel.formDataMapList;
                      } else if (requestModel.bodyContentType ==
                          ContentType.json) {
                        bodyJSON = jsonDecode(requestModel.body.toString());
                      } else {
                        bodyTXT = requestModel.body!;
                      }

                      final reqDesModel = APIDashRequestDescription(
                        endpoint: requestModel.url,
                        method: requestModel.method.name.toUpperCase(),
                        responseType: responseModel.contentType.toString(),
                        headers: requestModel.headersMap,
                        response: responseModel.body,
                        formData: bodyFormData,
                        bodyTXT: bodyTXT,
                        bodyJSON: bodyJSON,
                      );

                      print("GT2");
                      showCustomDialog(
                        context,
                        GenerateToolDialog(
                          requestDesc: reqDesModel,
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.token_outlined,
                    ),
                    label: const SizedBox(
                      child: Text(
                        "Generate Tool",
                      ),
                    ),
                  ),
                  kHSpacer10,
                  FilledButton.tonalIcon(
                    style: FilledButton.styleFrom(
                      padding: kPh12,
                      minimumSize: const Size(44, 44),
                    ),
                    onPressed: () {
                      final model = ref.watch(selectedRequestModelProvider
                          .select((value) => value?.httpResponseModel));
                      showCustomDialog(
                        context,
                        GenerateUIDialog(content: model?.formattedBody ?? ""),
                      );
                    },
                    icon: Icon(
                      Icons.generating_tokens,
                    ),
                    label: const SizedBox(
                      child: Text(
                        kLabelGenerateUI,
                      ),
                    ),
                  ),
                  kHSpacer10,
                ],
              ),
              kVSpacer10,
              Row(
                children: [
                  (widget.options == kRawBodyViewOptions)
                      ? const SizedBox()
                      : SegmentedButton<ResponseBodyView>(
                          style: SegmentedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          selectedIcon: Icon(currentSeg.icon),
                          segments: widget.options
                              .map<ButtonSegment<ResponseBodyView>>(
                                (e) => ButtonSegment<ResponseBodyView>(
                                  value: e,
                                  label: Text(e.label),
                                  icon: constraints.maxWidth >
                                          kMinWindowSize.width
                                      ? Icon(e.icon)
                                      : null,
                                ),
                              )
                              .toList(),
                          selected: {currentSeg},
                          onSelectionChanged: (newSelection) {
                            setState(() {
                              segmentIdx =
                                  widget.options.indexOf(newSelection.first);
                            });
                          },
                        ),
                  const Spacer(),
                  ((widget.options == kPreviewRawBodyViewOptions) ||
                          kCodeRawBodyViewOptions.contains(currentSeg) ||
                          isAIRequest)
                      ? CopyButton(
                          toCopy: (currentSeg == ResponseBodyView.answer)
                              ? widget.formattedBody!
                              : isAIRequest
                                  ? formatBody(widget.body, widget.mediaType)!
                                  : (widget.formattedBody ?? widget.body),
                          showLabel: showLabel,
                        )
                      : const SizedBox(),
                  kIsMobile
                      ? ShareButton(
                          toShare: (currentSeg == ResponseBodyView.answer)
                              ? widget.formattedBody!
                              : isAIRequest
                                  ? formatBody(widget.body, widget.mediaType)!
                                  : (widget.formattedBody ?? widget.body),
                          showLabel: showLabel,
                        )
                      : SaveInDownloadsButton(
                          content: (currentSeg == ResponseBodyView.answer)
                              ? utf8.encode(widget.formattedBody!)
                              : widget.bytes,
                          mimeType: (currentSeg == ResponseBodyView.answer)
                              ? 'text/plain'
                              : widget.mediaType.mimeType,
                          showLabel: showLabel,
                        ),
                ],
              ),
              kVSpacer10,
              switch (currentSeg) {
                ResponseBodyView.preview || ResponseBodyView.none => Expanded(
                    child: Container(
                      width: double.maxFinite,
                      padding: kP8,
                      decoration: textContainerdecoration,
                      child: Previewer(
                        bytes: widget.bytes,
                        body: widget.body,
                        type: widget.mediaType.type,
                        subtype: widget.mediaType.subtype,
                        hasRaw: widget.options.contains(ResponseBodyView.raw),
                      ),
                    ),
                  ),
                ResponseBodyView.code => Expanded(
                    child: Container(
                      width: double.maxFinite,
                      padding: kP8,
                      decoration: textContainerdecoration,
                      child: CodePreviewer(
                        code: widget.formattedBody ?? widget.body,
                        theme: codeTheme,
                        language: widget.highlightLanguage,
                        textStyle: kCodeStyle,
                      ),
                    ),
                  ),
                ResponseBodyView.raw => Expanded(
                    child: Container(
                      width: double.maxFinite,
                      padding: kP8,
                      decoration: textContainerdecoration,
                      child: SingleChildScrollView(
                        child: SelectableText(
                          widget.options.contains(ResponseBodyView.answer)
                              ? formatBody(
                                  widget.body,
                                  MediaType(kTypeApplication, kSubTypeJson),
                                )!
                              : (widget.formattedBody ?? widget.body),
                          style: kCodeStyle,
                        ),
                      ),
                    ),
                  ),
                ResponseBodyView.answer => Expanded(
                    child: Container(
                      width: double.maxFinite,
                      padding: kP8,
                      decoration: textContainerdecoration,
                      child: SingleChildScrollView(
                        child: SelectableText(
                          widget.formattedBody ?? widget.body,
                          style: kCodeStyle,
                        ),
                      ),
                    ),
                  ),
                ResponseBodyView.sse => Expanded(
                    child: Container(
                      width: double.maxFinite,
                      padding: kP8,
                      decoration: textContainerdecoration,
                      child: SSEDisplay(
                        sseOutput: widget.formattedBody?.split('\n') ?? [],
                        selectedLLModel: widget.selectedModel,
                      ),
                    ),
                  ),
              }
            ],
          ),
        );
      },
    );
  }
}
