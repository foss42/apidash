import 'package:apidash/dashbot/models/models.dart';
import 'package:apidash/dashbot/providers/providers.dart';
import 'package:apidash/dashbot/widgets/dashbot_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashbotApplyWorkflowButton extends ConsumerWidget with DashbotActionMixin {
  @override
  final ChatAction action;

  const DashbotApplyWorkflowButton({super.key, required this.action});

  String get _workflowName {
    final value = action.value;
    if (value is Map) {
      final name = value['name']?.toString().trim();
      if (name != null && name.isNotEmpty) return name;
    }
    return 'Workflow';
  }

  int get _nodeCount {
    final value = action.value;
    if (value is Map) {
      final nodes = value['nodes'];
      if (nodes is List) return nodes.length;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtitle =
        _nodeCount > 0 ? '$_workflowName · $_nodeCount nodes' : _workflowName;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          subtitle,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 6),
        ElevatedButton(
          onPressed: () async {
            await ref.read(chatViewmodelProvider.notifier).applyAutoFix(action);
          },
          child: const Text('Create Workflow'),
        ),
      ],
    );
  }
}
