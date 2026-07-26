import 'package:apidash/workflow/consts.dart';
import 'package:apidash/workflow/providers/workflow_providers.dart';
import 'package:apidash/workflow/utils/workflow_variable_utils.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkflowVariableBrowser extends ConsumerWidget {
  const WorkflowVariableBrowser({
    super.key,
    required this.nodeId,
  });

  final String nodeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workflow = ref.watch(activeWorkflowProvider);
    if (workflow == null) {
      return const SizedBox.shrink();
    }

    final chainedMap = upstreamExtractionVariables(workflow, nodeId);
    final chained = [
      for (final entry in chainedMap.entries)
        _VariableEntry(
          label: entry.key,
          reference: '{{${entry.key}}}',
          subtitle: entry.value,
        ),
    ];

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text(
          kLabelWorkflowVariables,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 4),
        Text(
          'Extractions from upstream steps appear here for chaining.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
        const SizedBox(height: 12),
        if (chained.isNotEmpty) ...[
          _SectionHeader(title: 'From upstream steps'),
          ...chained.map((entry) => _VariableTile(entry: entry)),
        ] else
          Padding(
            padding: kP12,
            child: Text(
              'No upstream extractions yet.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _VariableEntry {
  const _VariableEntry({
    required this.label,
    required this.reference,
    required this.subtitle,
  });

  final String label;
  final String reference;
  final String subtitle;
}

class _VariableTile extends StatelessWidget {
  const _VariableTile({required this.entry});

  final _VariableEntry entry;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(
        entry.reference,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
            ),
      ),
      subtitle: Text(entry.subtitle),
      trailing: IconButton(
        tooltip: 'Copy',
        icon: const Icon(Icons.copy_rounded, size: 18),
        onPressed: () async {
          await Clipboard.setData(ClipboardData(text: entry.reference));
        },
      ),
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: entry.reference));
      },
    );
  }
}
