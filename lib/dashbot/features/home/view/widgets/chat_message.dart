import 'package:apidash_design_system/tokens/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ollama_dart/ollama_dart.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final MessageRole role;

  const ChatBubble({super.key, required this.message, required this.role});

  @override
  Widget build(BuildContext context) {
    if (message.isEmpty) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            kVSpacer8,
            Image.asset(
              "assets/dashbot_icon_1.png",
              width: 42,
            ),
            kVSpacer8,
            CircularProgressIndicator.adaptive(),
          ],
        ),
      );
    }
    return Align(
      alignment: role == MessageRole.user
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (role == MessageRole.system) ...[
            kVSpacer6,
            Image.asset(
              "assets/dashbot_icon_1.png",
              width: 42,
            ),
            kVSpacer8,
          ],
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            padding: const EdgeInsets.all(12.0),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: role == MessageRole.user
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: MarkdownBody(
              data: message.isEmpty ? " " : message,
              selectable: true,
              styleSheet:
                  MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                p: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: role == MessageRole.user
                          ? Theme.of(context).colorScheme.surfaceBright
                          : Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
