import 'package:apidash_design_system/ui/design_system_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../dashbot_action.dart';

class DashbotSelectOperationButton extends ConsumerWidget
    with DashbotActionMixin {
  @override
  final ChatAction action;
  const DashbotSelectOperationButton({super.key, required this.action});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ds = DesignSystemProvider.of(context);
    final operationName = action.path ?? 'Unknown';
    return OutlinedButton(
      onPressed: () async {
        await ref.read(chatViewmodelProvider.notifier).applyAutoFix(action);
      },
      child: Text(operationName, style: TextStyle(fontSize: 12*ds.scaleFactor)),
    );
  }
}
