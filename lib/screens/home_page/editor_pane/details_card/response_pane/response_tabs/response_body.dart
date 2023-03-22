import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';

class ResponseBody extends ConsumerStatefulWidget {
  const ResponseBody({super.key});

  @override
  ConsumerState<ResponseBody> createState() => _ResponseBodyState();
}

class _ResponseBodyState extends ConsumerState<ResponseBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(activeIdStateProvider);
    final collection = ref.watch(collectionStateNotifierProvider);
    final idIdx = collection.indexWhere((m) => m.id == activeId);
    final responseModel = collection[idIdx].responseModel;
    var mediaType = responseModel?.mediaType;
    var body = responseModel?.body;
    var formattedBody = responseModel?.formattedBody;
    if (responseModel == null) {
      return const ErrorMessage(
          message: 'Error: No Response Data Found. $kUnexpectedRaiseIssue');
    }
    if (mediaType == null) {
      return ErrorMessage(
          message:
              'Unknown Response content type - ${responseModel.contentType}. $kUnexpectedRaiseIssue');
    }
    if (body == null) {
      return const ErrorMessage(
          message: 'Response body is empty. $kUnexpectedRaiseIssue');
    }
    var responseBodyView = getResponseBodyViewOptions(mediaType);
    //print(responseBodyView);
    var options = responseBodyView.$0;
    var highlightLanguage = responseBodyView.$1;
    if (options == kNoBodyViewOptions) {
      return ErrorMessage(
          message:
              "Viewing response data of Content-Type\n'${mediaType.mimeType}' $kMimeTypeRaiseIssue");
    }

    if (formattedBody == null) {
      options = [...options];
      options.remove(ResponseBodyView.code);
    }

    return BodySuccess(
      key: Key("$activeId-response"),
      mediaType: mediaType,
      options: options,
      bytes: responseModel.bodyBytes!,
      body: body,
      formattedBody: formattedBody,
      highlightLanguage: highlightLanguage,
    );
  }
}

class BodySuccess extends StatefulWidget {
  const BodySuccess(
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
  State<BodySuccess> createState() => _BodySuccessState();
}

class _BodySuccessState extends State<BodySuccess> {
  int segmentIdx = 0;

  @override
  Widget build(BuildContext context) {
    var currentSeg = widget.options[segmentIdx];
    var codeTheme = Theme.of(context).brightness == Brightness.light
        ? kLightCodeTheme
        : kDarkCodeTheme;
    final textContainerdecoration = BoxDecoration(
      color: Theme.of(context).brightness == Brightness.dark
          ? Color.alphaBlend(
              Theme.of(context).colorScheme.surface.withOpacity(0.8),
              Colors.black)
          : Color.alphaBlend(
              Theme.of(context).colorScheme.surface.withOpacity(0.2),
              Colors.white),
      border: Border.all(color: Theme.of(context).colorScheme.surfaceVariant),
      borderRadius: kBorderRadius8,
    );

    return Padding(
      padding: kP10,
      child: Column(
        children: [
          SizedBox(
            height: kHeaderHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (widget.options == kRawBodyViewOptions)
                    ? const SizedBox()
                    : SegmentedButton<ResponseBodyView>(
                        selectedIcon:
                            Icon(kResponseBodyViewIcons[currentSeg]![kKeyIcon]),
                        segments: widget.options
                            .map<ButtonSegment<ResponseBodyView>>(
                              (e) => ButtonSegment<ResponseBodyView>(
                                value: e,
                                label:
                                    Text(kResponseBodyViewIcons[e]![kKeyName]),
                                icon:
                                    Icon(kResponseBodyViewIcons[e]![kKeyIcon]),
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
                kCodeRawBodyViewOptions.contains(currentSeg)
                    ? CopyButton(toCopy: widget.body)
                    : const SizedBox(),
              ],
            ),
          ),
          kVSpacer10,
          Visibility(
            visible: currentSeg == ResponseBodyView.preview,
            child: Expanded(
              child: Previewer(
                bytes: widget.bytes,
                type: widget.mediaType.type,
                subtype: widget.mediaType.subtype,
              ),
            ),
          ),
          if (widget.formattedBody != null)
            Visibility(
              visible: currentSeg == ResponseBodyView.code,
              child: Expanded(
                child: Container(
                  width: double.maxFinite,
                  padding: kP8,
                  decoration: textContainerdecoration,
                  child: CodePreviewer(
                    code: widget.formattedBody!,
                    theme: codeTheme,
                    language: widget.highlightLanguage,
                    textStyle: kCodeStyle,
                  ),
                ),
              ),
            ),
          Visibility(
            visible: currentSeg == ResponseBodyView.raw,
            child: Expanded(
              child: Container(
                width: double.maxFinite,
                padding: kP8,
                decoration: textContainerdecoration,
                child: SingleChildScrollView(
                  child: SelectableText(
                    widget.body,
                    style: kCodeStyle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
