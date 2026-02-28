import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/utils/utils.dart';
import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../dashbot_action.dart';

class DashbotDownloadDocButton extends ConsumerWidget with DashbotActionMixin {
  @override
  final ChatAction action;
  const DashbotDownloadDocButton({super.key, required this.action});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docContent = (action.value is String) ? action.value as String : '';
    final filename = action.path ?? 'api-documentation';

    return ElevatedButton.icon(
      icon: const Icon(Icons.download, size: 16),
      label: const Text('Download Documentation'),
      onPressed: docContent.isEmpty
          ? null
          : () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final contentBytes = Uint8List.fromList(docContent.codeUnits);

              await saveToDownloads(
                scaffoldMessenger,
                content: contentBytes,
                mimeType: 'text/markdown',
                ext: 'md',
                name: filename,
              );
            },
    );
  }
}
