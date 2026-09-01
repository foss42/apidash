import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/widgets/widgets.dart';
import '../../consts.dart';
import '../../providers/agentic_providers.dart';
import '../../providers/providers.dart';
import '../../screens/history/history_details.dart';

class AgenticHistoryScreen extends ConsumerWidget {
  const AgenticHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrowScreen = constraints.maxWidth < 800;

        if (isNarrowScreen) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: AppBar(
              title: const Text("Agentic History", style: TextStyle(fontSize: 16)),
              scrolledUnderElevation: 0,
            ),
            drawer: const Drawer(
              child: SafeArea(child: _AgenticHistorySidebar()),
            ),
            body: const _AgenticHistoryDetails(),
          );
        }

        return const Row(
          children: [
            SizedBox(
              width: 280,
              child: _AgenticHistorySidebar(),
            ),
            VerticalDivider(width: 1, thickness: 1),
            Expanded(
              child: _AgenticHistoryDetails(),
            ),
          ],
        );
      },
    );
  }
}

class _AgenticHistorySidebar extends ConsumerWidget {
  const _AgenticHistorySidebar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedRequests = ref.watch(agenticHistoryGroupedProvider);
    final activeId = ref.watch(activeAgenticIdStateProvider);

    return Column(
      children: [
        if (MediaQuery.sizeOf(context).width >= 800) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Agentic History",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        tooltip: 'Clear All Agentic History',
                        onPressed: () {
                          ref.read(activeAgenticIdStateProvider.notifier).state = null;
                          ref.read(agenticCollectionStateNotifierProvider.notifier).clearAllHistory();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.history_toggle_off,
                          size: 20,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        tooltip: 'History Settings',
                        // --- FUNCTIONAL SETTINGS TRIGGER ---
                        onPressed: () {
                          showHistoryRetentionDialog(
                            context,
                            ref.read(
                              settingsProvider.select(
                                    (value) => value.historyRetentionPeriod,
                              ),
                            ),
                                (value) {
                              ref
                                  .read(settingsProvider.notifier)
                                  .update(historyRetentionPeriod: value);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
        ],
        Expanded(
          child: ListView.builder(
            itemCount: groupedRequests.keys.length,
            itemBuilder: (context, index) {
              final groupName = groupedRequests.keys.elementAt(index);
              final items = groupedRequests[groupName]!;

              return ExpansionTile(
                initiallyExpanded: false,
                shape: const Border(),
                title: Text(
                  groupName,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                subtitle: Text("${items.length} tests", style: const TextStyle(fontSize: 11)),
                children: items.map((req) {
                  if (req.httpRequestModel == null) return const SizedBox.shrink();

                  return Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: SidebarRequestCard(
                      id: req.id,
                      apiType: req.apiType,
                      method: req.httpRequestModel?.method,
                      name: req.name.split('::').last,
                      url: req.getUrl(),
                      selectedId: activeId,
                      onTap: () {
                        ref.read(activeAgenticIdStateProvider.notifier).state = req.id;

                        if (MediaQuery.sizeOf(context).width < 800) {
                          Navigator.pop(context);
                        }
                      },
                      onMenuSelected: (ItemMenuOption item) {
                        if (item == ItemMenuOption.delete) {
                          if (activeId == req.id) {
                            ref.read(activeAgenticIdStateProvider.notifier).state = null;
                          }
                          ref.read(agenticCollectionStateNotifierProvider.notifier).deleteRequest(req.id);
                        }
                      },
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AgenticHistoryDetails extends ConsumerWidget {
  const _AgenticHistoryDetails();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeAgenticIdStateProvider);
    final collection = ref.watch(agenticCollectionStateNotifierProvider);
    final activeRequest = activeId != null ? collection[activeId] : null;

    if (activeRequest == null) {
      return const Center(child: Text("Select an agentic test to view details"));
    }

    final historyModel = HistoryRequestModel(
      historyId: activeRequest.id,
      metaData: HistoryMetaModel(
        historyId: activeRequest.id,
        requestId: activeRequest.id,
        apiType: activeRequest.apiType,
        name: activeRequest.name.split('::').last,
        url: activeRequest.httpRequestModel?.url ?? '',
        method: activeRequest.httpRequestModel?.method ?? HTTPVerb.get,
        responseStatus: activeRequest.responseStatus ?? -1,
        timeStamp: DateTime.now(),
      ),
      httpRequestModel: activeRequest.httpRequestModel,
      httpResponseModel: activeRequest.httpResponseModel ?? const HttpResponseModel(),
    );

    return ProviderScope(
      key: ValueKey(activeRequest.id),
      overrides: [
        selectedHistoryRequestModelProvider.overrideWith((ref) => historyModel),
      ],
      child: const HistoryDetails(),
    );
  }
}