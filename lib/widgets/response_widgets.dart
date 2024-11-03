import 'dart:async';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/consts.dart';

class NotSentWidget extends StatelessWidget {
  const NotSentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondary;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.north_east_rounded,
            size: 40,
            color: color,
          ),
          Text(
            kLabelNotSent,
            style:
                Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class SendingWidget extends StatefulWidget {
  final DateTime? startSendingTime;
  const SendingWidget({
    super.key,
    required this.startSendingTime,
  });

  @override
  State<SendingWidget> createState() => _SendingWidgetState();
}

class _SendingWidgetState extends State<SendingWidget> {
  int _millisecondsElapsed = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.startSendingTime != null) {
      _millisecondsElapsed =
          (DateTime.now().difference(widget.startSendingTime!).inMilliseconds ~/
                  100) *
              100;
      _timer = Timer.periodic(const Duration(milliseconds: 100), _updateTimer);
    }
  }

  void _updateTimer(Timer timer) {
    setState(() {
      _millisecondsElapsed += 100;
    });
  }

  @override
  void dispose() {
    if (_timer != null && _timer!.isActive) _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Lottie.asset(kAssetSendingLottie),
        ),
        Padding(
          padding: kPh20t40,
          child: Visibility(
            visible: _millisecondsElapsed >= 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.alarm,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Time elapsed: ${humanizeDuration(Duration(milliseconds: _millisecondsElapsed))}',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: kTextStyleButton.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ResponsePaneHeader extends StatelessWidget {
  const ResponsePaneHeader({
    super.key,
    this.responseStatus,
    this.message,
    this.time,
    this.onClearResponse,
  });

  final int? responseStatus;
  final String? message;
  final Duration? time;
  final VoidCallback? onClearResponse;

  @override
  Widget build(BuildContext context) {
    final bool showClearButton = onClearResponse != null;
    return Padding(
      padding: kPv8,
      child: SizedBox(
        height: kHeaderHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            kHSpacer10,
            Expanded(
              child: Text(
                "$responseStatus: ${message ?? '-'}",
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: kCodeStyle.fontFamily,
                      color: getResponseStatusCodeColor(
                        responseStatus,
                        brightness: Theme.of(context).brightness,
                      ),
                    ),
              ),
            ),
            kHSpacer10,
            Text(
              humanizeDuration(time),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: kCodeStyle.fontFamily,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
            kHSpacer10,
            showClearButton
                ? ClearResponseButton(
                    onPressed: onClearResponse,
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class ResponseTabView extends StatefulWidget {
  const ResponseTabView({
    super.key,
    this.selectedId,
    required this.children,
  });

  final String? selectedId;
  final List<Widget> children;
  @override
  State<ResponseTabView> createState() => _ResponseTabViewState();
}

class _ResponseTabViewState extends State<ResponseTabView>
    with TickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: 2,
      animationDuration: kTabAnimationDuration,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          key: Key(widget.selectedId!),
          controller: _controller,
          labelPadding: kPh2,
          overlayColor: kColorTransparentState,
          onTap: (index) {},
          tabs: const [
            TabLabel(
              text: kLabelResponseBody,
            ),
            TabLabel(
              text: kLabelHeaders,
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            children: widget.children,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ResponseHeadersHeader extends StatelessWidget {
  const ResponseHeadersHeader({
    super.key,
    required this.map,
    required this.name,
  });

  final Map map;
  final String name;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kHeaderHeight,
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$name (${map.length} $kLabelItems)",
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          if (map.isNotEmpty)
            CopyButton(
              toCopy: kJsonEncoder.convert(map),
            ),
        ],
      ),
    );
  }
}

class ResponseHeaders extends StatelessWidget {
  const ResponseHeaders({
    super.key,
    required this.responseHeaders,
    required this.requestHeaders,
  });

  final Map responseHeaders;
  final Map requestHeaders;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kPh20v5,
      child: ListView(
        children: [
          ResponseHeadersHeader(
            map: responseHeaders,
            name: kLabelResponseHeaders,
          ),
          if (responseHeaders.isNotEmpty) kVSpacer5,
          if (responseHeaders.isNotEmpty)
            MapTable(
              map: responseHeaders,
              colNames: kHeaderRow,
              firstColumnHeaderCase: true,
            ),
          kVSpacer10,
          ResponseHeadersHeader(
            map: requestHeaders,
            name: kLabelRequestHeaders,
          ),
          if (requestHeaders.isNotEmpty) kVSpacer5,
          if (requestHeaders.isNotEmpty)
            MapTable(
              map: requestHeaders,
              colNames: kHeaderRow,
              firstColumnHeaderCase: true,
            ),
        ],
      ),
    );
  }
}

class ResponseBody extends StatelessWidget {
  const ResponseBody({
    super.key,
    this.selectedRequestModel,
  });

  final RequestModel? selectedRequestModel;

  @override
  Widget build(BuildContext context) {
    final responseModel = selectedRequestModel?.httpResponseModel;
    if (responseModel == null) {
      return const ErrorMessage(
          message: '$kNullResponseModelError $kUnexpectedRaiseIssue');
    }

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

    var responseBodyView = getResponseBodyViewOptions(mediaType);
    var options = responseBodyView.$1;
    var highlightLanguage = responseBodyView.$2;

    if (formattedBody == null) {
      options = [...options];
      options.remove(ResponseBodyView.code);
    }

    return BodySuccess(
      key: Key("${selectedRequestModel!.id}-response"),
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
      color: Color.alphaBlend(
          (Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.primaryContainer)
              .withOpacity(kForegroundOpacity),
          Theme.of(context).colorScheme.surface),
      border: Border.all(
          color: Theme.of(context).colorScheme.surfaceContainerHighest),
      borderRadius: kBorderRadius8,
    );

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
                  kCodeRawBodyViewOptions.contains(currentSeg)
                      ? CopyButton(
                          toCopy: widget.formattedBody ?? widget.body,
                          showLabel: showLabel,
                        )
                      : const SizedBox(),
                  SaveInDownloadsButton(
                    content: widget.bytes,
                    mimeType: widget.mediaType.mimeType,
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
                          widget.formattedBody ?? widget.body,
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
