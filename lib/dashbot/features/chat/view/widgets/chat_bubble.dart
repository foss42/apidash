import 'package:apidash/dashbot/core/utils/safe_parse_json_message.dart';
import 'package:apidash_design_system/tokens/tokens.dart';
import '../../../../core/utils/dashbot_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodel/chat_viewmodel.dart';
import '../../models/chat_models.dart';
import 'common_languages_picker.dart';

class ChatBubble extends ConsumerWidget {
  final String message;
  final MessageRole role;
  final String? promptOverride;
  final ChatAction? action;

  const ChatBubble({
    super.key,
    required this.message,
    required this.role,
    this.promptOverride,
    this.action,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (action != null) {
      debugPrint('[ChatBubble] Action received: ${action!.toJson()}');
    } else {
      final preview =
          message.length > 100 ? '${message.substring(0, 100)}...' : message;
      debugPrint('[ChatBubble] No action received for message: $preview');
    }
    if (promptOverride != null &&
        role == MessageRole.user &&
        message == promptOverride) {
      return SizedBox.shrink();
    }
    if (message.isEmpty) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            kVSpacer8,
            DashbotIcons.getDashbotIcon1(width: 42),
            kVSpacer8,
            CircularProgressIndicator.adaptive(),
          ],
        ),
      );
    }
    // Parse agent JSON when role is system and show only the "explnation" field.
    String renderedMessage = message;
    if (role == MessageRole.system) {
      try {
        final Map<String, dynamic> parsed = MessageJson.safeParse(message);
        if (parsed.containsKey('explnation')) {
          final exp = parsed['explnation'];
          if (exp is String && exp.isNotEmpty) {
            renderedMessage = exp;
          }
        }
      } catch (_) {
        // Fallback to raw message
      }
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
            DashbotIcons.getDashbotIcon1(width: 42),
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
              data: renderedMessage.isEmpty ? " " : renderedMessage,
              selectable: true,
              styleSheet: MarkdownStyleSheet.fromTheme(
                Theme.of(context),
              ).copyWith(
                p: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: role == MessageRole.user
                          ? Theme.of(context).colorScheme.surfaceBright
                          : Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ),
          ),
          if (role == MessageRole.system) ...[
            if (action != null) ...[
              const SizedBox(height: 4),
              _buildActionWidget(context, ref, action!),
            ],
            const SizedBox(height: 4),
            IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: message));
              },
              icon: Icon(
                Icons.copy_rounded,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionWidget(
      BuildContext context, WidgetRef ref, ChatAction action) {
    final isTestAction = action.action == 'other' && action.target == 'test';
    final isCodeResult = action.action == 'other' && action.target == 'code';
    if (isCodeResult) {
      final code = (action.value is String) ? action.value as String : '';
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: SelectableText(
              code.isEmpty ? '// No code returned' : code,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                  ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                },
                icon: const Icon(Icons.copy_rounded, size: 16),
                label: const Text('Copy code'),
              ),
            ],
          ),
        ],
      );
    }
    final isShowLanguages =
        action.action == 'show_languages' && action.target == 'codegen';

    if (isShowLanguages) {
      final dynamic val = action.value;
      final List<String> langs = val is List
          ? val.whereType<String>().toList()
          : const [
              'JavaScript (fetch)',
              'Python (requests)',
              'Dart (http)',
              'Go (net/http)',
              'cURL',
            ];
      return CommonLanguagesPicker(
        languages: langs,
        onSelected: (lang) {
          final vm = ref.read(chatViewmodelProvider.notifier);
          vm.sendMessage(
            text: 'Please generate code in $lang',
            type: ChatMessageType.generateCode,
          );
        },
      );
    }

    return ElevatedButton.icon(
      onPressed: () async {
        final chatViewmodel = ref.read(chatViewmodelProvider.notifier);
        await chatViewmodel.applyAutoFix(action);
        if (isTestAction) {
          debugPrint('Test added to post-request script successfully!');
        } else {
          debugPrint('Auto-fix applied successfully!');
        }
      },
      icon: Icon(isTestAction ? Icons.playlist_add_check : Icons.auto_fix_high,
          size: 16),
      label: Text(isTestAction ? 'Add Test' : 'Auto Fix'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        textStyle: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}
