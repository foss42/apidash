import 'dart:developer';

import 'package:apidash/dashbot/features/home/view/widgets/chat_message.dart';
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
  String _currentStreamingResponse = '';

  void _sendMessage() async {
    if (_textController.text.trim().isEmpty) return;

    final userMessage = _textController.text;
    final userChatMessage = ChatMessage(text: userMessage, isUser: true);

    _textController.clear();

    setState(() {
      _messages.add(userChatMessage);
      _isGenerating = true;
      _currentStreamingResponse = '';
    });

    log("Sending message: $userMessage");

    final stream =
        ref.read(homeViewmodelProvider.notifier).sendMessage(userMessage);

    try {
      await for (final responseChunk in stream) {
        setState(() {
          _currentStreamingResponse += responseChunk.response ?? '';
          log("Stream chunk received: ${responseChunk.response}");
          log("Current streaming response: $_currentStreamingResponse");
        });
      }
      if (_currentStreamingResponse.isNotEmpty) {
        final assistantChatMessage =
            ChatMessage(text: _currentStreamingResponse, isUser: false);
        _messages.add(assistantChatMessage);
      }

      setState(() {
        _isGenerating = false;
      });
    } catch (e) {
      log("Error receiving stream: $e");
      final errorChatMessage = ChatMessage(text: "Error: $e", isUser: false);
      setState(() {
        _messages.add(errorChatMessage);
        _isGenerating = false;
        _currentStreamingResponse = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty && !_isGenerating
                ? const Center(child: Text("Ask me anything!"))
                : ListView.builder(
                    itemCount: _messages.length + (_isGenerating ? 1 : 0),
                    padding: const EdgeInsets.all(16.0),
                    reverse: false,
                    itemBuilder: (context, index) {
                      if (_isGenerating && index == _messages.length) {
                        return ChatBubble(
                          message: _currentStreamingResponse,
                          isUser: false,
                        );
                      }
                      final message = _messages[index];
                      return ChatBubble(
                        message: message.text,
                        isUser: message.isUser,
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
                    decoration: InputDecoration(
                      hintText:
                          _isGenerating ? 'Generating...' : 'Ask anything',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                    ),
                    enabled: !_isGenerating,
                    onSubmitted: (_) =>
                        _isGenerating ? null : _sendMessage(), // Send on enter
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.send),
                  onPressed: _isGenerating ? null : _sendMessage,
                  tooltip: 'Send message',
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom > 0 ? 10 : 20,
          ),
        ],
      ),
    );
  }
}
