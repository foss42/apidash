import 'package:flutter/material.dart';

import '../../../../features/chat/models/chat_action.dart';
import '../dashbot_action.dart';

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
