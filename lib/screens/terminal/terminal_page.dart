import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash/terminal/terminal.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';

class TerminalPage extends ConsumerStatefulWidget {
  const TerminalPage({super.key});

  @override
  ConsumerState<TerminalPage> createState() => _TerminalPageState();
}

class _TerminalPageState extends ConsumerState<TerminalPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  bool _showTimestamps = false;

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
    return Scaffold(
      body: _LogsTab(
        searchCtrl: _searchCtrl,
        showTimestamps: _showTimestamps,
        selectedLevels: _selectedLevels,
        onTimestampToggle: () =>
            setState(() => _showTimestamps = !_showTimestamps),
        onLevelsChanged: (s) => setState(() {
          _selectedLevels
            ..clear()
            ..addAll(s);
        }),
        onSearchChanged: () => setState(() {}),
      ),
    );
  }
}

class _LogsTab extends ConsumerWidget {
  const _LogsTab({
    required this.searchCtrl,
    required this.showTimestamps,
    required this.selectedLevels,
    required this.onTimestampToggle,
    required this.onLevelsChanged,
    required this.onSearchChanged,
  });

  final TextEditingController searchCtrl;
  final bool showTimestamps;
  final Set<TerminalLevel> selectedLevels;
  final VoidCallback onTimestampToggle;
  final ValueChanged<Set<TerminalLevel>> onLevelsChanged;
  final VoidCallback onSearchChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(terminalStateProvider);
    final collection = ref.watch(collectionStateNotifierProvider);
    final allEntries = state.entries;
    final filtered = _applyFilters(
      ref,
      allEntries,
      searchCtrl.text,
      selectedLevels,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Row(
            children: [
              Expanded(
                child: SearchField(
                  controller: searchCtrl,
                  hintText: kHintSearchLogs,
                  onChanged: (_) => onSearchChanged(),
                ),
              ),
              const SizedBox(width: 8),
              TerminalLevelFilterMenu(
                selected: selectedLevels,
                onChanged: onLevelsChanged,
              ),
              const SizedBox(width: 4),
              IconButton(
                tooltip: kTooltipShowTimestamps,
                isSelected: showTimestamps,
                icon: const Icon(Icons.access_time),
                selectedIcon: const Icon(Icons.access_time_filled),
                onPressed: onTimestampToggle,
              ),
              const SizedBox(width: 4),
              ADIconButton(
                tooltip: kTooltipClearLogs,
                icon: Icons.delete_outline,
                iconSize: 22,
                onPressed: () {
                  ref.read(terminalStateProvider.notifier).clear();
                },
              ),
              const SizedBox(width: 4),
              CopyButton(
                showLabel: false,
                toCopy: ref
                    .read(terminalStateProvider.notifier)
                    .serializeAll(entries: allEntries),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: filtered.isEmpty
              ? const Center(
                  child: SimpleText(
                    title: kMsgNoLogs,
                    subtitle: kMsgSendToView,
                  ),
                )
              : ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (ctx, i) {
                    final e = filtered[filtered.length - 1 - i];
                    final searchQuery = searchCtrl.text.trim();
                    String requestName = '';
                    if (e.source == TerminalSource.js && e.requestId != null) {
                      final model = collection?[e.requestId];
                      if (model != null) {
                        requestName = model.name.isNotEmpty
                            ? model.name
                            : kLabelUntitled;
                      }
                    } else if (e.requestId != null) {
                      final model = collection?[e.requestId];
                      if (model != null) {
                        requestName = model.name.isNotEmpty
                            ? model.name
                            : kLabelUntitled;
                      }
                    }
                    switch (e.source) {
                      case TerminalSource.js:
                        return JsLogTile(
                          entry: e,
                          showTimestamp: showTimestamps,
                          searchQuery: searchQuery,
                          requestName:
                              requestName.isNotEmpty ? requestName : null,
                        );
                      case TerminalSource.network:
                        return NetworkLogTile(
                          entry: e,
                          showTimestamp: showTimestamps,
                          searchQuery: searchQuery,
                          requestName:
                              requestName.isNotEmpty ? requestName : null,
                        );
                      case TerminalSource.system:
                        return SystemLogTile(
                          entry: e,
                          showTimestamp: showTimestamps,
                          searchQuery: searchQuery,
                        );
                    }
                  },
                ),
        ),
      ],
    );
  }

  static List<TerminalEntry> _applyFilters(
    WidgetRef ref,
    List<TerminalEntry> entries,
    String searchText,
    Set<TerminalLevel> levels,
  ) {
    final q = searchText.trim().toLowerCase();
    bool matches(TerminalEntry e) {
      if (!levels.contains(e.level)) return false;
      if (q.isEmpty) return true;
      final controller = ref.read(terminalStateProvider.notifier);
      final title = controller.titleFor(e).toLowerCase();
      final sub = (controller.subtitleFor(e) ?? '').toLowerCase();
      return title.contains(q) || sub.contains(q);
    }

    return entries.where(matches).toList(growable: false);
  }
}
