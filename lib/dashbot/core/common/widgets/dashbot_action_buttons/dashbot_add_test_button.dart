import 'package:flutter/material.dart';

import '../../../../features/chat/models/chat_models.dart';
import '../../../../features/chat/viewmodel/chat_viewmodel.dart';
import '../dashbot_action.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
