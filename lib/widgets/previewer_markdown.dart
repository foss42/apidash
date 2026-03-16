import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:apidash_design_system/apidash_design_system.dart';

class MarkdownPreviewer extends StatelessWidget {
  const MarkdownPreviewer({
    super.key,
    required this.body,
  });

  final String body;

  @override
  Widget build(BuildContext context) {
    return Markdown(
      data: body,
      selectable: true,
      onTapLink: (text, href, title) {
        if (href != null) {
          launchUrl(Uri.parse(href));
        }
      },
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        code: kCodeStyle,
        codeblockDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
