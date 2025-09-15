import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/chat/models/chat_models.dart';
import '../../../features/chat/viewmodel/chat_viewmodel.dart';
import '../../../features/chat/providers/attachments_provider.dart';
import 'package:file_selector/file_selector.dart';

/// Base mixin for action widgets.
mixin DashbotActionMixin {
  ChatAction get action;
}

class DashbotUploadRequestButton extends ConsumerWidget
    with DashbotActionMixin {
  @override
  final ChatAction action;
  const DashbotUploadRequestButton({super.key, required this.action});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final label = action.value is Map && (action.value['purpose'] is String)
        ? 'Upload: ${action.value['purpose'] as String}'
        : 'Upload Attachment';
    return OutlinedButton.icon(
      icon: const Icon(Icons.upload_file, size: 16),
      label: Text(label, overflow: TextOverflow.ellipsis),
      onPressed: () async {
        final types = <XTypeGroup>[];
        if (action.value is Map && action.value['accepted_types'] is List) {
          final exts = (action.value['accepted_types'] as List)
              .whereType<String>()
              .map((e) => e.trim())
              .toList();
          if (exts.isNotEmpty) {
            types.add(XTypeGroup(label: 'Allowed', mimeTypes: exts));
          }
        }
        final file = await openFile(
            acceptedTypeGroups:
                types.isEmpty ? [const XTypeGroup(label: 'Any')] : types);
        if (file == null) return;
        final bytes = await file.readAsBytes();
        final att = ref.read(attachmentsProvider.notifier).add(
              name: file.name,
              mimeType: file.mimeType ?? 'application/octet-stream',
              data: bytes,
            );
        // Notify model via a user message to incorporate attachment context.
        ref.read(chatViewmodelProvider.notifier).sendMessage(
              text:
                  'Attached file ${att.name} (id=${att.id}, mime=${att.mimeType}, size=${att.sizeBytes}). You can request its content if needed.',
              type: ChatMessageType.general,
            );
      },
    );
  }
}

class DashbotAutoFixButton extends ConsumerWidget with DashbotActionMixin {
  @override
  final ChatAction action;
  const DashbotAutoFixButton({super.key, required this.action});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () async {
        await ref.read(chatViewmodelProvider.notifier).applyAutoFix(action);
      },
      icon: const Icon(Icons.auto_fix_high, size: 16),
      label: const Text('Auto Fix'),
    );
  }
}

class DashbotAddTestButton extends ConsumerWidget with DashbotActionMixin {
  @override
  final ChatAction action;
  const DashbotAddTestButton({super.key, required this.action});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () async {
        await ref.read(chatViewmodelProvider.notifier).applyAutoFix(action);
      },
      icon: const Icon(Icons.playlist_add_check, size: 16),
      label: const Text('Add Test'),
    );
  }
}

class DashbotGenerateLanguagePicker extends ConsumerWidget
    with DashbotActionMixin {
  @override
  final ChatAction action;
  const DashbotGenerateLanguagePicker({super.key, required this.action});

  List<String> _extractLanguages(dynamic value) {
    if (value is List) {
      return value.whereType<String>().toList();
    }
    return const [
      'JavaScript (fetch)',
      'Python (requests)',
      'Dart (http)',
      'Go (net/http)',
      'cURL',
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langs = _extractLanguages(action.value);
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final l in langs)
          OutlinedButton(
            onPressed: () {
              ref.read(chatViewmodelProvider.notifier).sendMessage(
                    text: 'Please generate code in $l',
                    type: ChatMessageType.generateCode,
                  );
            },
            child: Text(l, style: const TextStyle(fontSize: 12)),
          ),
      ],
    );
  }
}

class DashbotGeneratedCodeBlock extends StatelessWidget
    with DashbotActionMixin {
  @override
  final ChatAction action;
  const DashbotGeneratedCodeBlock({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    final code = (action.value is String) ? action.value as String : '';
    return Container(
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
    );
  }
}

/// Factory to map an action to a widget.
class DashbotActionWidgetFactory {
  static Widget? build(ChatAction action) {
    switch (action.actionType) {
      case ChatActionType.other:
        if (action.targetType == ChatActionTarget.test) {
          return DashbotAddTestButton(action: action);
        }
        if (action.targetType == ChatActionTarget.code) {
          return DashbotGeneratedCodeBlock(action: action);
        }
        break;
      case ChatActionType.showLanguages:
        if (action.targetType == ChatActionTarget.codegen) {
          return DashbotGenerateLanguagePicker(action: action);
        }
        break;
      case ChatActionType.updateField:
      case ChatActionType.addHeader:
      case ChatActionType.updateHeader:
      case ChatActionType.deleteHeader:
      case ChatActionType.updateBody:
      case ChatActionType.updateUrl:
      case ChatActionType.updateMethod:
        return DashbotAutoFixButton(action: action);
      case ChatActionType.noAction:
        return null;
      case ChatActionType.uploadAsset:
        if (action.targetType == ChatActionTarget.attachment) {
          return DashbotUploadRequestButton(action: action);
        }
        return null;
    }

    if (action.action == 'other' && action.target == 'test') {
      return DashbotAddTestButton(action: action);
    }
    if (action.action == 'other' && action.target == 'code') {
      return DashbotGeneratedCodeBlock(action: action);
    }
    if (action.action == 'show_languages' && action.target == 'codegen') {
      return DashbotGenerateLanguagePicker(action: action);
    }
    if (action.action.contains('update') ||
        action.action.contains('add') ||
        action.action.contains('delete')) {
      return DashbotAutoFixButton(action: action);
    }
    return null;
  }
}
