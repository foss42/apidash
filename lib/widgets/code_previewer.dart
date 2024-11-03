import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:highlighter/highlighter.dart' show highlight, Node;
import 'package:apidash/consts.dart';
import 'error_message.dart';

(String, bool) sanitize(String input) {
  bool limitedLines = false;
  int tabSize = 4;
  var lines = kSplitter.convert(input);
  if (lines.length > kCodePreviewLinesLimit) {
    lines = lines.sublist(0, kCodePreviewLinesLimit);
    limitedLines = true;
  }
  var replaced = lines.map((e) {
    if (e.startsWith("\t")) {
      return e.replaceAll('\t', ' ' * tabSize);
    } else {
      return e;
    }
  });
  return (replaced.join('\n'), limitedLines);
}

class CodePreviewer extends StatefulWidget {
  const CodePreviewer({
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
  State<CodePreviewer> createState() => _CodePreviewerState();
}

class _CodePreviewerState extends State<CodePreviewer> {
  late Future<List<TextSpan>> spans;
  static const _rootKey = 'root';
  static const _defaultFontColor = Color(0xff000000);
  late final (String, bool) processed;
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
    processed = sanitize(widget.code);
    spans = asyncGenerateSpans(
      processed.$1,
      widget.language,
      widget.theme,
      processed.$2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: FutureBuilder(
        future: spans,
        builder:
            (BuildContext context, AsyncSnapshot<List<TextSpan>> snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            var finalSpans = snapshot.data!;
            return Scrollbar(
              thickness: 10,
              thumbVisibility: true,
              controller: controllerV,
              child: Scrollbar(
                notificationPredicate: (notification) =>
                    notification.depth == 1,
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
                                  children: finalSpans,
                                  style: textStyle,
                                ),
                                softWrap: false,
                                //selectionRegistrar:
                                //    SelectionContainer.maybeOf(context),
                                //selectionColor: const Color(0xAF6694e8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            return ErrorMessage(message: snapshot.error.toString());
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

Future<List<TextSpan>> asyncGenerateSpans(String code, String? language,
    Map<String, TextStyle> theme, bool limitedLines) async {
  var parsed = highlight.parse(code, language: language);
  var spans = convert(parsed.nodes!, theme);
  if (limitedLines) {
    spans.add(const TextSpan(
        text:
            "\n... more.\nPreview ends here ($kCodePreviewLinesLimit lines).\nYou can check Raw for full result."));
  }
  return spans;
}

List<TextSpan> convert(List<Node> nodes, Map<String, TextStyle> theme) {
  final List<TextSpan> spans = [];
  var currentSpans = spans;
  final List<List<TextSpan>> stack = [];

  void traverse(Node node) {
    var val = node.value;
    final nodeChildren = node.children;
    final nodeStyle = theme[node.className];
    if (val != null) {
      currentSpans.add(TextSpan(text: val, style: nodeStyle));
    } else if (nodeChildren != null) {
      List<TextSpan> tmp = [];
      currentSpans.add(TextSpan(children: tmp, style: nodeStyle));
      stack.add(currentSpans);
      currentSpans = tmp;

      for (final n in nodeChildren) {
        traverse(n);
        if (n == nodeChildren.last) {
          currentSpans = stack.isEmpty ? spans : stack.removeLast();
        }
      }
    }
  }

  for (var node in nodes) {
    traverse(node);
  }
  return spans;
}
