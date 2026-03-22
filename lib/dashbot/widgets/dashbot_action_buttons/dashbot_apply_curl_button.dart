import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../dashbot_action.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashbotApplyCurlButton extends ConsumerWidget with DashbotActionMixin {
  @override
  final ChatAction action;
  const DashbotApplyCurlButton({super.key, required this.action});

  String _labelForField(String? field, String? path) {
    switch (field) {
      case 'apply_to_selected':
        return 'Apply to Selected';
      case 'apply_to_new':
        return 'Create New Request';
      case 'select_operation':
        return path == null || path.isEmpty ? 'Select Operation' : path;
      default:
        return 'Apply';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final label = _labelForField(action.field, action.path);
    final isDestructive = action.field == 'apply_to_selected';
    return ElevatedButton(
      onPressed: () async {
        await ref.read(chatViewmodelProvider.notifier).applyAutoFix(action);
      },
      child: Text(
        label,
        // Destructive action: highlight with error color
        style: isDestructive
            ? TextStyle(color: Theme.of(context).colorScheme.error)
            : null,
      ),
    );
  }
}
