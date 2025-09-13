import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/terminal/models.dart';
import '../../consts.dart';
import '../../providers/terminal_providers.dart';
import '../../providers/collection_providers.dart';
import '../../widgets/button_copy.dart';
import '../../widgets/field_search.dart';
import '../../widgets/terminal_tiles.dart';
import '../../widgets/empty_message.dart';
import 'package:apidash_design_system/apidash_design_system.dart';

class TerminalPage extends ConsumerStatefulWidget {
  const TerminalPage({super.key});

  @override
  ConsumerState<TerminalPage> createState() => _TerminalPageState();
}

class _TerminalPageState extends ConsumerState<TerminalPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  bool _showTimestamps = false; // user toggle

  // Initially all levels will be selected
  final Set<TerminalLevel> _selectedLevels = {
    TerminalLevel.debug,
    TerminalLevel.info,
    TerminalLevel.warn,
    TerminalLevel.error,
  };

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(terminalStateProvider);
    final collection = ref.watch(collectionStateNotifierProvider);
    final selectedId = ref.watch(selectedIdStateProvider);
    final allEntries = state.entries;
    final filtered = _applyFilters(allEntries);

    return Scaffold(
      body: Column(
        children: [
          _buildToolbar(context, allEntries),
          const Divider(height: 1),
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: EmptyMessage(
                      title: 'No logs yet',
                      subtitle:
                          'Send a request to see details here in the console',
                    ),
                  )
                : ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (ctx, i) {
                      final e = filtered[filtered.length - 1 - i];
                      String requestName = '';
                      if (e.source == TerminalSource.js) {
                        if (selectedId != null) {
                          final model = collection?[selectedId];
                          if (model != null) {
                            requestName =
                                model.name.isNotEmpty ? model.name : model.id;
                          } else {
                            requestName = selectedId;
                          }
                        }
                      } else if (e.requestId != null) {
                        final model = collection?[e.requestId];
                        if (model != null) {
                          requestName =
                              model.name.isNotEmpty ? model.name : model.id;
                        } else {
                          requestName = e.requestId!;
                        }
                      }
                      switch (e.source) {
                        case TerminalSource.js:
                          return JsLogTile(
                            entry: e,
                            showTimestamp: _showTimestamps,
                            requestName:
                                requestName.isNotEmpty ? requestName : null,
                          );
                        case TerminalSource.network:
                          return NetworkLogTile(
                            entry: e,
                            showTimestamp: _showTimestamps,
                            requestName:
                                requestName.isNotEmpty ? requestName : null,
                          );
                        case TerminalSource.system:
                          return SystemLogTile(
                            entry: e,
                            showTimestamp: _showTimestamps,
                          );
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, List<TerminalEntry> allEntries) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Row(
        children: [
          Expanded(
            child: SearchField(
              controller: _searchCtrl,
              hintText: 'Search logs',
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(width: 8),
          // Filter button
          _FilterMenu(
            selected: _selectedLevels,
            onChanged: (set) => setState(() {
              _selectedLevels
                ..clear()
                ..addAll(set);
            }),
          ),
          const SizedBox(width: 4),
          Tooltip(
            message: 'Show timestamps',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: _showTimestamps,
                  onChanged: (v) =>
                      setState(() => _showTimestamps = v ?? false),
                ),
                const Text('Timestamp', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),

          const Spacer(),
          // Clear button
          ADIconButton(
            tooltip: 'Clear logs',
            icon: Icons.delete_outline,
            iconSize: 22,
            onPressed: () {
              ref.read(terminalStateProvider.notifier).clear();
            },
          ),
          const SizedBox(width: 4),
          // Copy all button
          CopyButton(
            showLabel: false,
            toCopy: ref
                .read(terminalStateProvider.notifier)
                .serializeAll(entries: allEntries),
          ),
        ],
      ),
    );
  }

  List<TerminalEntry> _applyFilters(List<TerminalEntry> entries) {
    final q = _searchCtrl.text.trim().toLowerCase();
    bool matches(TerminalEntry e) {
      if (!_selectedLevels.contains(e.level)) return false;
      if (q.isEmpty) return true;
      final controller = ref.read(terminalStateProvider.notifier);
      final title = controller.titleFor(e).toLowerCase();
      final sub = (controller.subtitleFor(e) ?? '').toLowerCase();
      return title.contains(q) || sub.contains(q);
    }

    return entries.where(matches).toList(growable: false);
  }
}

class _FilterMenu extends StatelessWidget {
  const _FilterMenu({
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
