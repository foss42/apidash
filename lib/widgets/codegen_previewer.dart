import 'package:flutter/material.dart';
import 'package:highlighter/highlighter.dart' show highlight;
import 'code_previewer.dart' show convert;

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
