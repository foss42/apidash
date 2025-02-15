import 'package:example/src/models.dart';
import 'package:flutter/material.dart';
import 'dart:math' show Random;

import 'package:example/src/data.dart';

class ChatMessageTextField extends StatelessWidget {
  const ChatMessageTextField({
    Key? key,
    required this.focusNode,
    required this.controller,
    required this.onSend,
  }) : super(key: key);

  final FocusNode focusNode;
  final TextEditingController controller;
  final ValueSetter<ChatMessage> onSend;

  final _sender = const [sahil, avni, gaurav];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 4, 4, 4),
      decoration: const BoxDecoration(
        color: Color(0xFFF7F7F8),
        borderRadius: BorderRadius.all(Radius.circular(40.0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: focusNode,
              controller: controller,
              decoration: const InputDecoration.collapsed(
                hintText: "Type your message...",
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              final message = ChatMessage(
                text: controller.text,
                createdAt: DateTime.now(),
                sender: _sender[Random().nextInt(_sender.length)],
              );
              onSend(message);
            },
            padding: const EdgeInsets.all(4),
            icon: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF5B61B9),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
