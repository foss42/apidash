import 'package:flutter/material.dart';
import '../consts.dart';

class TerminalLevelFilterMenu extends StatelessWidget {
  const TerminalLevelFilterMenu({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final Set<TerminalLevel> selected;
  final ValueChanged<Set<TerminalLevel>> onChanged;

  void _toggleLevel(TerminalLevel level) {
    final next = selected.contains(level)
        ? (selected.toSet()..remove(level))
        : (selected.toSet()..add(level));
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final all = TerminalLevel.values.toSet();
    return PopupMenuButton<_MenuAction>(
      tooltip: 'Filter',
      icon: const Icon(Icons.filter_alt),
      onSelected: (action) {
        switch (action) {
          case _MenuAction.toggleDebug:
            _toggleLevel(TerminalLevel.debug);
            break;
          case _MenuAction.toggleInfo:
            _toggleLevel(TerminalLevel.info);
            break;
          case _MenuAction.toggleWarn:
            _toggleLevel(TerminalLevel.warn);
            break;
          case _MenuAction.toggleError:
            _toggleLevel(TerminalLevel.error);
            break;
          case _MenuAction.selectAll:
            onChanged(all);
            break;
          case _MenuAction.clearAll:
            onChanged(<TerminalLevel>{});
            break;
        }
      },
      itemBuilder: (context) => [
        CheckedPopupMenuItem<_MenuAction>(
          value: _MenuAction.toggleError,
          checked: selected.contains(TerminalLevel.error),
          child: const ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.error_outline_rounded, color: Colors.red),
            title: Text('Errors'),
          ),
        ),
        CheckedPopupMenuItem<_MenuAction>(
          value: _MenuAction.toggleWarn,
          checked: selected.contains(TerminalLevel.warn),
          child: const ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.warning_amber_outlined, color: Colors.amber),
            title: Text('Warnings'),
          ),
        ),
        CheckedPopupMenuItem<_MenuAction>(
          value: _MenuAction.toggleInfo,
          checked: selected.contains(TerminalLevel.info),
          child: const ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.info_outline, color: Colors.blue),
            title: Text('Info'),
          ),
        ),
        CheckedPopupMenuItem<_MenuAction>(
          value: _MenuAction.toggleDebug,
          checked: selected.contains(TerminalLevel.debug),
          child: const ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.bug_report_outlined),
            title: Text('Debug'),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<_MenuAction>(
          value: _MenuAction.selectAll,
          child: const ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.select_all),
            title: Text('Select all'),
          ),
        ),
        PopupMenuItem<_MenuAction>(
          value: _MenuAction.clearAll,
          child: const ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.clear_all),
            title: Text('Clear selection'),
          ),
        ),
      ],
    );
  }
}

enum _MenuAction {
  toggleDebug,
  toggleInfo,
  toggleWarn,
  toggleError,
  selectAll,
  clearAll,
}
