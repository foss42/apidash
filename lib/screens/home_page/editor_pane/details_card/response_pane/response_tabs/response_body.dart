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
    if (responseModel == null) {
      return const ErrorMessage(
          message: 'Error: No Response Data Found. $kRaiseIssue');
    }
    if (mediaType == null) {
      return ErrorMessage(
          message:
              'Unknown Response content type - ${responseModel.contentType}. $kRaiseIssue');
    }
    if (body == null) {
      return const ErrorMessage(
          message: 'Response body is empty. $kRaiseIssue');
    }
    var responseBodyView = getResponseBodyViewOptions(mediaType);
    print(responseBodyView);
    var options = responseBodyView.$0;
    var highlightLanguage = responseBodyView.$1;
    if (options == kNoBodyViewOptions) {
      return ErrorMessage(
          message:
              "Viewing response data of Content-Type\n'${mediaType.mimeType}' $kMimeTypeRaiseIssue");
    }
    return BodySuccess(
      mediaType: mediaType,
      options: options,
      bytes: responseModel.bodyBytes!,
      body: body,
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
      this.highlightLanguage});
  final MediaType mediaType;
  final List<ResponseBodyView> options;
  final String body;
  final Uint8List bytes;
  final String? highlightLanguage;
  @override
  State<BodySuccess> createState() => _BodySuccessState();
}

class _BodySuccessState extends State<BodySuccess> {
  int segmentIdx = 0;

  @override
  Widget build(BuildContext context) {
    var currentSeg = widget.options[segmentIdx];

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
                        selectedIcon: Icon(kResponseBodyViewIcons[currentSeg]),
                        segments: widget.options
                            .map<ButtonSegment<ResponseBodyView>>(
                              (e) => ButtonSegment<ResponseBodyView>(
                                value: e,
                                label: Text(capitalizeFirstLetter(e.name)),
                                icon: Icon(kResponseBodyViewIcons[e]),
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
          Expanded(
            child: currentSeg == ResponseBodyView.preview
                ? Previewer(
                    bytes: widget.bytes,
                    type: widget.mediaType.type,
                    subtype: widget.mediaType.subtype,
                  )
                : (currentSeg == ResponseBodyView.code
                    ? //SizedBox()
                    CodeHighlight(
                        input: widget.body,
                        language: widget.highlightLanguage,
                        textStyle: kCodeStyle,
                      )
                    : Container(
                        padding: kP8,
                        decoration: textContainerdecoration,
                        child: SingleChildScrollView(
                          child: SelectableText(
                            widget.body,
                            style: kCodeStyle,
                          ),
                        ),
                      )),
          ),
        ],
      ),
    );
  }
}
