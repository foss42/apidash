import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../dashbot_action.dart';

class DashbotApplyOpenApiButton extends ConsumerWidget with DashbotActionMixin {
  @override
  final ChatAction action;
  const DashbotApplyOpenApiButton({super.key, required this.action});

  String _labelForField(String? field) {
    switch (field) {
      case 'apply_to_selected':
        return 'Apply to Selected';
      case 'apply_to_new':
        return 'Create New Request';
      default:
        return 'Apply';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final label = _labelForField(action.field);
    return ElevatedButton(
      onPressed: () async {
        await ref.read(chatViewmodelProvider.notifier).applyAutoFix(action);
      },
      child: Text(label),
    );
  }
}
