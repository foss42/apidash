import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';
import 'buttons.dart';

class CustomMarkdown extends StatelessWidget {
  const CustomMarkdown({
    super.key,
    required this.data,
    this.padding = const EdgeInsets.all(16.0),
    this.onTapLink,
  });

  final String data;
  final EdgeInsets padding;
  final void Function(String text, String? href, String title)? onTapLink;

  @override
  Widget build(BuildContext context) {
    final mdStyleSheet = MarkdownStyleSheet(
      h1: Theme.of(context).textTheme.headlineLarge,
      p: Theme.of(context).textTheme.titleMedium,
    );
    return Markdown(
      padding: padding,
      styleSheet: mdStyleSheet,
      data: data,
      selectable: true,
      extensionSet: md.ExtensionSet.gitHubFlavored,
      onTapLink: onTapLink ??
          (text, href, title) {
            launchUrl(Uri.parse(href ?? ""));
          },
      builders: {
        "inlineButton": InlineButton(),
      },
      inlineSyntaxes: [
        InlineButtonSyntax(),
      ],
      blockSyntaxes: const [
        SpacerSyntax(),
      ],
    );
  }
}

class InlineButtonSyntax extends md.InlineSyntax {
  InlineButtonSyntax({
    String pattern = r'~`(.*?)`~',
  }) : super(pattern);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final withoutDashes = match.group(0)!.replaceAll(RegExp(r'[~`]'), "");

    md.Element el = md.Element.text("inlineButton", withoutDashes);

    parser.addNode(el);
    return true;
  }
}

class InlineButton extends MarkdownElementBuilder {
  @override
  Widget visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    var txt = element.textContent;
    switch (txt.toLowerCase()) {
      case "star on github":
        return SizedBox(
          height: 24,
          child: RepoButton(
            text: txt,
            icon: Icons.star,
          ),
        );
      case "github repo":
        return SizedBox(
          height: 24,
          child: RepoButton(
            text: txt,
            icon: Icons.code_rounded,
          ),
        );
      case "discord server":
        return SizedBox(
          height: 24,
          child: DiscordButton(
            text: txt,
          ),
        );
      default:
        return const SizedBox();
    }
  }
}

final _spacerPattern = RegExp(r'^#br[ \x09\x0b\x0c]*$');

class SpacerSyntax extends md.BlockSyntax {
  @override
  RegExp get pattern => _spacerPattern;

  const SpacerSyntax();

  @override
  md.Node parse(md.BlockParser parser) {
    pattern.firstMatch(parser.current.content)!;
    parser.advance();
    return md.Element('p', [md.Element.empty('p')]);
  }
}
