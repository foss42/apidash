import 'package:example/src/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatMessageList extends StatelessWidget {
  const ChatMessageList({
    Key? key,
    required this.messages,
  }) : super(key: key);

  final List<ChatMessage> messages;

  @override
  Widget build(BuildContext context) {
    final messages = this.messages.reversed.toList();
    return ListView.separated(
      reverse: true,
      itemCount: messages.length,
      padding: const EdgeInsets.all(8),
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (BuildContext context, int index) {
        final message = messages[index];
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFE9EAF4),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(32.0),
                    topLeft: Radius.circular(32.0),
                    bottomLeft: Radius.circular(32.0),
                  ),
                ),
                child: ParsedText(
                  text: message.text,
                  style: GoogleFonts.robotoMono(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF79708F),
                  ),
                  parse: <MatchText>[
                    MatchText(
                      pattern: r"@[A-Za-z0-9_.-]*",
                      style: const TextStyle(color: Colors.green),
                    ),
                    MatchText(
                      pattern: r"\B#+([\w]+)\b",
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundImage: NetworkImage(message.sender.avatar),
            ),
          ],
        );
      },
    );
  }
}
