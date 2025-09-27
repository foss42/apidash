import 'package:flutter/material.dart';

import '../../../../features/chat/models/chat_action.dart';
import '../../../../features/chat/viewmodel/chat_viewmodel.dart';
import '../dashbot_action.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashbotSelectOperationButton extends ConsumerWidget
    with DashbotActionMixin {
  @override
  final ChatAction action;
  const DashbotSelectOperationButton({super.key, required this.action});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final operationName = action.path ?? 'Unknown';
    return OutlinedButton(
      onPressed: () async {
        await ref.read(chatViewmodelProvider.notifier).applyAutoFix(action);
      },
      child: Text(operationName, style: const TextStyle(fontSize: 12)),
    );
  }
}
