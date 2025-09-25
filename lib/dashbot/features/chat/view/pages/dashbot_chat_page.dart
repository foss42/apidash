import 'package:apidash/dashbot/features/chat/view/widgets/dashbot_task_buttons.dart';
import 'package:apidash_design_system/apidash_design_system.dart';

import '../../../../core/constants/constants.dart';
import '../widgets/chat_bubble.dart';
import '../../viewmodel/chat_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final ChatMessageType? initialTask;
  const ChatScreen({super.key, this.initialTask});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _showTaskSuggestions = false;

  @override
  void initState() {
    super.initState();
    // Kick off task-specific prompt after first frame
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final task = widget.initialTask;
      if (task != null) {
        final vm = ref.read(chatViewmodelProvider.notifier);
        vm.sendTaskMessage(task);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(chatViewmodelProvider, (prev, next) {
      if (next.isGenerating) {
        _showTaskSuggestions = false;
      }
    });

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Consumer(
              builder: (context, ref, _) {
                final state = ref.watch(chatViewmodelProvider);
                final vm = ref.read(chatViewmodelProvider.notifier);
                final msgs = vm.currentMessages;
                if (msgs.isEmpty && !state.isGenerating) {
                  return const Center(child: Text('Ask me anything!'));
                }
                return ListView.builder(
                  itemCount: msgs.length + (state.isGenerating ? 1 : 0),
                  padding: const EdgeInsets.all(16.0),
                  itemBuilder: (context, index) {
                    if (state.isGenerating && index == msgs.length) {
                      return ChatBubble(
                        message: state.currentStreamingResponse,
                        role: MessageRole.system,
                      );
                    }
                    final message = msgs[index];
                    return ChatBubble(
                      message: message.content,
                      role: message.role,
                      actions: message.actions,
                    );
                  },
                );
              },
            ),
          ),
          Divider(
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            height: 5,
            thickness: 6,
          ),
          if (_showTaskSuggestions) DashbotTaskButtons(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ADIconButton(
                  icon: Icons.help_outline_rounded,
                  tooltip: 'Show tasks',
                  onPressed: ref.watch(chatViewmodelProvider).isGenerating
                      ? null
                      : () => setState(
                          () => _showTaskSuggestions = !_showTaskSuggestions),
                ),
                ADIconButton(
                  icon: Icons.clear_all_rounded,
                  tooltip: 'Clear chat',
                  onPressed: ref.watch(chatViewmodelProvider).isGenerating
                      ? null
                      : () {
                          ref
                              .read(chatViewmodelProvider.notifier)
                              .clearCurrentChat();
                        },
                ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: ref.watch(chatViewmodelProvider).isGenerating
                          ? 'Generating...'
                          : 'Ask anything',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                    enabled: !ref.watch(chatViewmodelProvider).isGenerating,
                    onSubmitted: (_) {
                      final vm = ref.read(chatViewmodelProvider.notifier);
                      if (!ref.read(chatViewmodelProvider).isGenerating) {
                        final text = _textController.text;
                        _textController.clear();
                        vm.sendMessage(
                          text: text,
                          type: ChatMessageType.general,
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send_rounded),
                  onPressed: ref.watch(chatViewmodelProvider).isGenerating
                      ? null
                      : () {
                          final vm = ref.read(chatViewmodelProvider.notifier);
                          final text = _textController.text;
                          _textController.clear();
                          vm.sendMessage(
                            text: text,
                            type: ChatMessageType.general,
                          );
                        },
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
