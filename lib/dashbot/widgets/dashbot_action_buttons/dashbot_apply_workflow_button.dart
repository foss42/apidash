import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../dashbot_action.dart';

class DashbotApplyWorkflowButton extends ConsumerWidget with DashbotActionMixin {
  @override
  final ChatAction action;

  const DashbotApplyWorkflowButton({super.key, required this.action});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () async {
        await ref.read(chatViewmodelProvider.notifier).applyAutoFix(action);
      },
      icon: Icon(
        Icons.account_tree_rounded,
        color: Theme.of(context).colorScheme.error,
        size: 18,
      ),
      label: Text(
        'Apply (overwrite workflow)',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }
}

