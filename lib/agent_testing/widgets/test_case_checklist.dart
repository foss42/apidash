import 'package:flutter/material.dart';
import 'package:apidash_agent/apidash_agent.dart'; // TestCase, TestCategory

class TestCaseChecklist extends StatelessWidget {
  final List<TestCase> cases;
  final void Function(String id) onToggle;
  final void Function(bool selected) onSelectAll;

  const TestCaseChecklist({
    super.key,
    required this.cases,
    required this.onToggle,
    required this.onSelectAll,
  });

  @override
  Widget build(BuildContext context) {
    final allSelected = cases.every((c) => c.isSelected);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: allSelected,
              tristate: true,
              onChanged: (v) => onSelectAll(v ?? false),
            ),
            Text(
              '${cases.where((c) => c.isSelected).length}/${cases.length} selected',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const Divider(height: 1),
        ...cases.map((tc) {
          final color = _categoryColor(tc.category, Theme.of(context).colorScheme);
          return CheckboxListTile(
            value: tc.isSelected,
            onChanged: (_) => onToggle(tc.id),
            title: Text(tc.description, style: const TextStyle(fontSize: 13)),
            subtitle: Text(
              '${tc.method.toUpperCase()}  ${tc.url}',
              style: const TextStyle(fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
            secondary: _CategoryChip(label: tc.category.name, color: color),
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
          );
        }),
      ],
    );
  }

  Color _categoryColor(TestCategory cat, ColorScheme cs) {
    switch (cat) {
      case TestCategory.happyPath:
        return Colors.green;
      case TestCategory.edgeCase:
        return Colors.orange;
      case TestCategory.security:
        return cs.error;
      case TestCategory.performance:
        return Colors.blue;
    }
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final Color color;
  const _CategoryChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        // .withValues() is the modern replacement for .withOpacity()
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
            fontSize: 10, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}