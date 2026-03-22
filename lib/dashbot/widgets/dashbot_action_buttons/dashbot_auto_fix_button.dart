import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../dashbot_action.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
