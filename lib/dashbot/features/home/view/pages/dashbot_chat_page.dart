import 'dart:developer';

import 'package:apidash/dashbot/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isGenerating = false;
  String _currentGeneratedText = '';

  @override
  Widget build(BuildContext context) {
    ref.listen(homeViewmodelProvider, (previous, next) {
      next.whenData((response) {
        setState(() {
          if (_isGenerating) {
            _currentGeneratedText += response.response ?? '';
          }
        });
      });
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Dashbot Chat')),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty && !_isGenerating
                ? const Center(child: Text("Ask me anything!"))
                : ListView.builder(
                    itemCount: _messages.length + (_isGenerating ? 1 : 0),
                    padding: const EdgeInsets.all(16.0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length && _isGenerating) {
                        // Show currently generating response
                        return ChatBubble(
                          message: _currentGeneratedText,
                          isUser: false,
                        );
                      }
                      return ChatBubble(
                        message: _messages[index].text,
                        isUser: _messages[index].isUser,
                      );
                    },
                  ),
          ),
          Divider(
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            height: 5,
            thickness: 6,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(hintText: 'Ask anything'),
                    enabled: !_isGenerating,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _isGenerating ? null : _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    if (_textController.text.trim().isEmpty) return;

    final userMessage = _textController.text;
    setState(() {
      _messages.add(ChatMessage(text: userMessage, isUser: true));
      _isGenerating = true;
      _currentGeneratedText = '';
    });

    log("Sending message: $userMessage");

    // Start the stream
    final stream =
        ref.read(homeViewmodelProvider.notifier).sendMessage(userMessage);

    _textController.clear();

    // Listen for the stream completion
    try {
      await for (final _ in stream) {
        // We're already updating UI via the provider listener
      }
      // When stream completes, add the full message to history
      setState(() {
        _messages.add(ChatMessage(text: _currentGeneratedText, isUser: false));
        _isGenerating = false;
      });
    } catch (e) {
      log("Error in stream: $e");
      setState(() {
        _messages.add(ChatMessage(text: "Error: $e", isUser: false));
        _isGenerating = false;
      });
    }
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const ChatBubble({super.key, required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: const EdgeInsets.all(12.0),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(message),
      ),
    );
  }
}
