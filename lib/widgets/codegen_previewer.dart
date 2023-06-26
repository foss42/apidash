import 'package:flutter/material.dart';
import 'package:highlighter/highlighter.dart' show highlight;
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart';
import 'code_previewer.dart';
import 'widgets.dart'
    show CopyButton, DropdownButtonCodegenLanguage, SaveInDownloadsButton;

class CodeGenPreviewer extends StatefulWidget {
  const CodeGenPreviewer({
    super.key,
    required this.code,
    required this.theme,
    this.language,
    this.textStyle,
    this.padding = EdgeInsets.zero,
  });

  final String code;
  final String? language;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  final Map<String, TextStyle> theme;

  @override
  State<CodeGenPreviewer> createState() => _CodeGenPreviewerState();
}

class _CodeGenPreviewerState extends State<CodeGenPreviewer> {
  static const _rootKey = 'root';
  static const _defaultFontColor = Color(0xff000000);
  late TextStyle textStyle;
  final ScrollController controllerH = ScrollController();
  final ScrollController controllerV = ScrollController();

  @override
  void dispose() {
    controllerH.dispose();
    controllerV.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    textStyle = TextStyle(
      color: widget.theme[_rootKey]?.color ?? _defaultFontColor,
    );
    if (widget.textStyle != null) {
      textStyle = textStyle.merge(widget.textStyle);
    }
  }

  @override
  Widget build(BuildContext context) {
    final spans = generateSpans(widget.code, widget.language, widget.theme);
    return Padding(
      padding: widget.padding,
      child: Scrollbar(
        thickness: 10,
        thumbVisibility: true,
        controller: controllerV,
        child: Scrollbar(
          notificationPredicate: (notification) => notification.depth == 1,
          thickness: 10,
          thumbVisibility: true,
          controller: controllerH,
          child: SingleChildScrollView(
            controller: controllerV,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: controllerH,
              child: Column(
                children: [
                  Row(
                    children: [
                      SelectionArea(
                        child: Text.rich(
                          TextSpan(
                            children: spans,
                            style: textStyle,
                          ),
                          softWrap: false,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

List<TextSpan> generateSpans(
    String code, String? language, Map<String, TextStyle> theme) {
  var parsed = highlight.parse(code, language: language);
  var spans = convert(parsed.nodes!, theme);
  return spans;
}

class ViewCodePane extends StatefulWidget {
  const ViewCodePane({
    super.key,
    required this.code,
    required this.codegenLanguage,
    required this.onChangedCodegenLanguage,
  });

  final String code;
  final CodegenLanguage codegenLanguage;
  final Function(CodegenLanguage?) onChangedCodegenLanguage;

  @override
  State<ViewCodePane> createState() => _ViewCodePaneState();
}

class _ViewCodePaneState extends State<ViewCodePane> {
  @override
  Widget build(BuildContext context) {
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

    return Padding(
      padding: kP10,
      child: Column(
        children: [
          SizedBox(
            height: kHeaderHeight*2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  flex: 1,
                  child: Text(
                    "Code",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: DropdownButtonCodegenLanguage(
                    codegenLanguage: widget.codegenLanguage,
                    onChanged: widget.onChangedCodegenLanguage,
                  ),
                ),
                Flexible(
                  flex:  MediaQuery.of(context).size.width>1350?2:1,
                  child: CopyButton(
                    toCopy: widget.code,
                  ),
                ),
                Flexible(
                  flex: MediaQuery.of(context).size.width>1350?2:1,
                  child: SaveInDownloadsButton(
                    content: stringToBytes(widget.code),
                    mimeType: "application/vnd.dart",
                  ),
                )
              ],
            ),
          ),
          kVSpacer10,
          Expanded(
            child: Container(
              width: double.maxFinite,
              padding: kP8,
              decoration: textContainerdecoration,
              child: CodeGenPreviewer(
                code: widget.code,
                theme: codeTheme,
                language: 'dart',
                textStyle: kCodeStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
