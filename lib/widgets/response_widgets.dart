import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:lottie/lottie.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/consts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotSentWidget extends StatelessWidget {
  const NotSentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
            l10n!.kLabelNotSent,
            style:
                Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class SendingWidget extends StatelessWidget {
  const SendingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset("assets/sending.json"),
        ],
      ),
    );
  }
}

class ResponsePaneHeader extends StatelessWidget {
  const ResponsePaneHeader({
    super.key,
    this.responseStatus,
    this.message,
    this.time,
  });

  final int? responseStatus;
  final String? message;
  final Duration? time;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: kPh20v10,
      child: SizedBox(
        height: kHeaderHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "${l10n!.kLabelResponse} (",
                  ),
                  TextSpan(
                    text: "$responseStatus",
                    style: TextStyle(
                      color: getResponseStatusCodeColor(
                        responseStatus,
                        brightness: Theme.of(context).brightness,
                      ),
                      fontFamily: kCodeStyle.fontFamily,
                    ),
                  ),
                  const TextSpan(
                    text: ")",
                  ),
                ],
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            kHSpacer20,
            Expanded(
              child: Text(
                message ?? "",
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontFamily: kCodeStyle.fontFamily,
                      color: getResponseStatusCodeColor(
                        responseStatus,
                        brightness: Theme.of(context).brightness,
                      ),
                    ),
              ),
            ),
            kHSpacer20,
            Text(
              humanizeDuration(time),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontFamily: kCodeStyle.fontFamily,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
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
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        TabBar(
          key: Key(widget.selectedId!),
          controller: _controller,
          overlayColor: kColorTransparentState,
          onTap: (index) {},
          tabs: [
            SizedBox(
              height: kTabHeight,
              child: Center(
                child: Text(
                  l10n!.kLabelBody,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: kTextStyleButton,
                ),
              ),
            ),
            SizedBox(
              height: kTabHeight,
              child: Center(
                child: Text(
                  l10n.kLabelHeaders,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  style: kTextStyleButton,
                ),
              ),
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
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      height: kHeaderHeight,
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$name (${map.length} ${l10n!.kLabelItems})",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          if (map.isNotEmpty)
            CopyButton(
              toCopy: kEncoder.convert(map),
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
    final l10n = AppLocalizations.of(context);
    final kHeaderRow = [l10n!.kLabelAPIHeaderName, l10n.kLabelAPIHeaderValue];
    return Padding(
      padding: kPh20v5,
      child: ListView(
        children: [
          ResponseHeadersHeader(
            map: responseHeaders,
            name: l10n.kLabelResponseHeaders,
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
            name: l10n.kLabelRequestHeaders,
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
    final l10n = AppLocalizations.of(context);
    final responseModel = selectedRequestModel?.responseModel;
    if (responseModel == null) {
      return ErrorMessage(
          message:
              '${l10n!.kLabelResponseBodyDoesntExist} ${l10n.kUnexpectedRaiseIssue}');
    }

    var body = responseModel.body;
    var formattedBody = responseModel.formattedBody;
    if (body == null) {
      return ErrorMessage(
          message:
              '${l10n!.kLabelResponseBodyNull} ${l10n.kUnexpectedRaiseIssue}');
    }
    if (body.isEmpty) {
      return ErrorMessage(
        message: l10n!.kLabelNoContent,
        showIcon: false,
        showIssueButton: false,
      );
    }

    var mediaType = responseModel.mediaType;
    if (mediaType == null) {
      return ErrorMessage(
          message:
              '${l10n!.kLabelResponseUnknownContentType} - ${responseModel.contentType}. ${l10n.kUnexpectedRaiseIssue}');
    }

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
      border: Border.all(color: Theme.of(context).colorScheme.surfaceVariant),
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
                          style: const ButtonStyle(
                            padding: MaterialStatePropertyAll(
                              EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                            ),
                          ),
                          selectedIcon: Icon(currentSeg.icon),
                          segments: widget.options
                              .map<ButtonSegment<ResponseBodyView>>(
                                (e) => ButtonSegment<ResponseBodyView>(
                                  value: e,
                                  label: Text(e.label),
                                  icon: Icon(e.icon),
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
