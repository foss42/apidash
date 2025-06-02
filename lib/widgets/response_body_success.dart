import 'dart:convert';

import 'package:apidash/models/llm_models/llm_model.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'button_share.dart';

class ResponseBodySuccess extends ConsumerStatefulWidget {
  const ResponseBodySuccess(
      {super.key,
      required this.mediaType,
      required this.body,
      required this.options,
      required this.bytes,
      this.formattedBody,
      this.highlightLanguage});
  final MediaType mediaType;
  final List<ResponseBodyView> options;
  final String body;
  final Uint8List bytes;
  final String? formattedBody;
  final String? highlightLanguage;
  @override
  ConsumerState<ResponseBodySuccess> createState() =>
      _ResponseBodySuccessState();
}

class _ResponseBodySuccessState extends ConsumerState<ResponseBodySuccess> {
  int segmentIdx = 0;

  @override
  Widget build(BuildContext context) {
    final obj = ref.watch(collectionStateNotifierProvider
        .select((value) => value![ref.read(selectedIdStateProvider)!]))!;

    final options = [...widget.options];
    if (obj.apiType == APIType.ai) {
      options.remove(ResponseBodyView.preview);
      options.add(ResponseBodyView.answer);
    }
    options.sort((x, y) => x.label.compareTo(y.label));

    String outputAnswer;
    try {
      outputAnswer = (obj.extraDetails['model'] as LLMModel?)
              ?.specifics
              .outputFormatter(jsonDecode(widget.body)) ??
          'ERROR';
    } catch (e) {
      outputAnswer = '';
      options.remove(ResponseBodyView.answer);
    }

    var currentSeg = options[segmentIdx];
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

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        var showLabel = showButtonLabelsInBodySuccess(
          options.length,
          constraints.maxWidth,
        );
        return Padding(
          padding: kP10,
          child: Column(
            children: [
              Row(
                children: [
                  (options == kRawBodyViewOptions)
                      ? const SizedBox()
                      : SegmentedButton<ResponseBodyView>(
                          style: SegmentedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          selectedIcon: Icon(currentSeg.icon),
                          segments: options
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
                              segmentIdx = options.indexOf(newSelection.first);
                            });
                          },
                        ),
                  const Spacer(),
                  ((options == kPreviewRawBodyViewOptions) ||
                          kCodeRawBodyViewOptions.contains(currentSeg) ||
                          obj.apiType == APIType.ai)
                      ? CopyButton(
                          toCopy: (currentSeg == ResponseBodyView.answer)
                              ? outputAnswer!
                              : widget.formattedBody ?? widget.body,
                          showLabel: showLabel,
                        )
                      : const SizedBox(),
                  kIsMobile
                      ? ShareButton(
                          toShare: (currentSeg == ResponseBodyView.answer)
                              ? outputAnswer!
                              : widget.formattedBody ?? widget.body,
                          showLabel: showLabel,
                        )
                      : SaveInDownloadsButton(
                          content: (currentSeg == ResponseBodyView.answer)
                              ? utf8.encode(outputAnswer!)
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
                        hasRaw: options.contains(ResponseBodyView.raw),
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
                          widget.formattedBody ?? widget.body,
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
                          outputAnswer!,
                          style: kCodeStyle,
                        ),
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
