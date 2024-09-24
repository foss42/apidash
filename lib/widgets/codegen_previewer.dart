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
    this.scaleFactor = 1.0,
  });

  final String code;
  final String? language;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  final Map<String, TextStyle> theme;
  final double scaleFactor;

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
  Widget build(BuildContext context) {
    final spans = generateSpans(widget.code, widget.language, widget.theme);
    textStyle = TextStyle(
      color: widget.theme[_rootKey]?.color ?? _defaultFontColor,
    );
    if (widget.textStyle != null) {
      textStyle = textStyle.merge(widget.textStyle);
    }
    return Padding(
      padding: widget.padding,
      child: Scrollbar(
        thickness: 10 * widget.scaleFactor,
        thumbVisibility: true,
        controller: controllerV,
        child: Scrollbar(
          notificationPredicate: (notification) => notification.depth == 1,
          thickness: 10 * widget.scaleFactor,
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
                            style: textStyle.copyWith(
                              fontSize: (textStyle.fontSize ?? 14.0) *
                                  widget.scaleFactor,
                            ),
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

class ViewCodePane extends StatelessWidget {
  const ViewCodePane({
    super.key,
    required this.code,
    required this.codegenLanguage,
    required this.onChangedCodegenLanguage,
    this.scaleFactor = 1.0,
  });

  final String code;
  final CodegenLanguage codegenLanguage;
  final Function(CodegenLanguage?) onChangedCodegenLanguage;
  final double scaleFactor;

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
      border: Border.all(
          color: Theme.of(context).colorScheme.surfaceContainerHighest),
      borderRadius: BorderRadius.circular(8 * scaleFactor),
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        var showLabel = showButtonLabelsInViewCodePane(
          constraints.maxWidth,
        );
        return Padding(
          padding: EdgeInsets.all(10 * scaleFactor),
          child: Column(
            children: [
              SizedBox(
                height: kHeaderHeight * scaleFactor,
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonCodegenLanguage(
                        codegenLanguage: codegenLanguage,
                        onChanged: onChangedCodegenLanguage,
                        scaleFactor: scaleFactor,
                      ),
                    ),
                    CopyButton(
                      toCopy: code,
                      showLabel: showLabel,
                      scaleFactor: scaleFactor,
                    ),
                    SaveInDownloadsButton(
                      content: stringToBytes(code),
                      ext: codegenLanguage.ext,
                      showLabel: showLabel,
                      scaleFactor: scaleFactor,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10 * scaleFactor),
              Expanded(
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.all(8 * scaleFactor),
                  decoration: textContainerdecoration,
                  child: CodeGenPreviewer(
                    code: code,
                    theme: codeTheme,
                    language: codegenLanguage.codeHighlightLang,
                    textStyle: kCodeStyle.copyWith(
                      fontSize: 14 * scaleFactor,
                    ),
                    scaleFactor: scaleFactor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
