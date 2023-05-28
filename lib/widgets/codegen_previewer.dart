import 'package:apidash/widgets/dropdowns.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:highlighter/highlighter.dart' show highlight;
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart';
import '../providers/ui_providers.dart';
import 'code_previewer.dart' show convert;
import 'buttons.dart';

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
  });

  final String code;

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
            height: kHeaderHeight,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Code",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const DropdownButtonCodeCodegenLanguage(),
                CopyButton(toCopy: widget.code),
                SaveInDownloadsButton(
                  content: stringToBytes(widget.code),
                  mimeType: "application/vnd.dart",
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

class DropdownButtonCodeCodegenLanguage extends ConsumerStatefulWidget {
  const DropdownButtonCodeCodegenLanguage({
    super.key,
  });

  @override
  ConsumerState createState() => _DropdownButtonCodeCodegenLanguageState();
}

class _DropdownButtonCodeCodegenLanguageState
    extends ConsumerState<DropdownButtonCodeCodegenLanguage> {
  @override
  Widget build(BuildContext context) {
    final requestCodeLanguage = ref.watch(codegenLanguageStateProvider);
    return DropdownButtonCodegenLanguage(
      codegenLanguage: requestCodeLanguage,
      onChanged: (CodegenLanguage? value) {
        ref.read(codegenLanguageStateProvider.notifier).state = value!;
      },
    );
  }
}