import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_selector/file_selector.dart';
import '../../constants.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../dashbot_action.dart';

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
        if (action.field == 'openapi_spec') {
          await ref
              .read(chatViewmodelProvider.notifier)
              .handleOpenApiAttachment(att);
        } else {
          ref.read(chatViewmodelProvider.notifier).sendMessage(
                text:
                    'Attached file ${att.name} (id=${att.id}, mime=${att.mimeType}, size=${att.sizeBytes}). You can request its content if needed.',
                type: ChatMessageType.general,
              );
        }
      },
    );
  }
}
