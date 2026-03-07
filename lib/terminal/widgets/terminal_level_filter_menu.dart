import 'package:flutter/material.dart';
import '../enums.dart';

class TerminalLevelFilterMenu extends StatelessWidget {
  const TerminalLevelFilterMenu({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final Set<TerminalLevel> selected;
  final ValueChanged<Set<TerminalLevel>> onChanged;

  void _showFilterDialog(BuildContext context) {
    showDialog<Set<TerminalLevel>>(
      context: context,
      builder: (context) => _FilterDialog(selected: selected),
    ).then((result) {
      if (result != null) {
        onChanged(result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Filter',
      icon: const Icon(Icons.filter_alt),
      onPressed: () => _showFilterDialog(context),
    );
  }
}

const _levelMeta = <TerminalLevel, ({IconData icon, Color? color, String label})>{
  TerminalLevel.error: (icon: Icons.error_outline_rounded, color: Colors.red, label: 'Errors'),
  TerminalLevel.warn: (icon: Icons.warning_amber_outlined, color: Colors.amber, label: 'Warnings'),
  TerminalLevel.info: (icon: Icons.info_outline, color: Colors.blue, label: 'Info'),
  TerminalLevel.debug: (icon: Icons.bug_report_outlined, color: null, label: 'Debug'),
};

class _FilterDialog extends StatefulWidget {
  const _FilterDialog({required this.selected});

  final Set<TerminalLevel> selected;

  @override
  State<_FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<_FilterDialog> {
  late Set<TerminalLevel> _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected.toSet();
  }

  void _toggle(TerminalLevel level) {
    setState(() {
      if (_selected.contains(level)) {
        _selected.remove(level);
      } else {
        _selected.add(level);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Levels'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final entry in _levelMeta.entries)
            CheckboxListTile(
              value: _selected.contains(entry.key),
              onChanged: (_) => _toggle(entry.key),
              secondary: Icon(entry.value.icon, color: entry.value.color),
              title: Text(entry.value.label),
            ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => setState(() {
                  _selected = TerminalLevel.values.toSet();
                }),
                child: const Text('Select all'),
              ),
              TextButton(
                onPressed: () => setState(() {
                  _selected.clear();
                }),
                child: const Text('Clear selection'),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_selected),
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
