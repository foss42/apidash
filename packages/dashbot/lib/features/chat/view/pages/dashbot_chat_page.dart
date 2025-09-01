import 'dart:developer';
import 'package:dashbot/features/chat/models/chat_models.dart';
import 'package:dashbot/features/chat/view/widgets/chat_bubble.dart';
import 'package:dashbot/features/chat/viewmodel/chat_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nanoid/nanoid.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String initialPrompt;
  const ChatScreen({super.key, required this.initialPrompt});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isGenerating = false;
  String _currentStreamingResponse = '';

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _sendMessage(promptOverride: widget.initialPrompt);
      }
    });
  }

  void _sendMessage({String? promptOverride}) async {
    final messageContent = promptOverride ?? _textController.text;

    if (messageContent.trim().isEmpty) return;

    final userChatMessage = ChatMessage(
      id: nanoid(),
      content: messageContent,
      role: MessageRole.user,
      timestamp: DateTime.now(),
      messageType: ChatMessageType.general,
    );

    if (promptOverride == null) {
      _textController.clear();
    }

    setState(() {
      _messages.add(userChatMessage);
      _isGenerating = true;
      _currentStreamingResponse = '';
    });

    log("Sending message: $messageContent");

    final stream = ref
        .read(chatViewmodelProvider.notifier)
        .sendMessage(messageContent, ChatMessageType.general);

    try {
      await for (final result in stream) {
        if (!mounted) return;

        result.fold(
          (failure) {
            log("Error: ${failure.message}");
            if (!mounted) return;
            final errorChatMessage = ChatMessage(
              id: nanoid(),
              content: "Error: ${failure.message}",
              role: MessageRole.system,
              timestamp: DateTime.now(),
              messageType: ChatMessageType.general,
            );
            setState(() {
              _messages.add(errorChatMessage);
              _isGenerating = false;
              _currentStreamingResponse = '';
            });
          },
          (response) {
            setState(() {
              _currentStreamingResponse += response.content;
            });
          },
        );
      }

      if (!mounted) return;

      if (_currentStreamingResponse.isNotEmpty) {
        final assistantChatMessage = ChatMessage(
          id: nanoid(),
          content: _currentStreamingResponse,
          role: MessageRole.system,
          timestamp: DateTime.now(),
          messageType: ChatMessageType.general,
        );
        _messages.add(assistantChatMessage);
      }

      setState(() {
        _isGenerating = false;
      });
    } catch (e) {
      log("Error receiving stream: $e");
      if (!mounted) return;
      final errorChatMessage = ChatMessage(
        id: nanoid(),
        content: "Error: $e",
        role: MessageRole.system,
        timestamp: DateTime.now(),
        messageType: ChatMessageType.general,
      );
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
            child:
                _messages.isEmpty && !_isGenerating
                    ? const Center(child: Text("Ask me anything!"))
                    : ListView.builder(
                      itemCount: _messages.length + (_isGenerating ? 1 : 0),
                      padding: const EdgeInsets.all(16.0),
                      reverse: false,
                      itemBuilder: (context, index) {
                        if (_isGenerating && index == _messages.length) {
                          return ChatBubble(
                            message: _currentStreamingResponse,
                            role: MessageRole.system,
                          );
                        }
                        final message = _messages[index];
                        return ChatBubble(
                          message: message.content,
                          role: message.role,
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
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                    enabled: !_isGenerating,
                    onSubmitted: (_) => _isGenerating ? null : _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send_rounded),
                  onPressed: _isGenerating ? null : _sendMessage,
                  tooltip: 'Send message',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
