import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:apidash/extensions/extensions.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';

class HistoryPane extends ConsumerWidget {
  const HistoryPane({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: (!context.isMediumWindow && kIsMacOS
              ? kP24CollectionPane
              : kP8CollectionPane) +
          (context.isMediumWindow ? kPb70 : EdgeInsets.zero),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [kVSpacer10, Expanded(child: HistoryList()), kVSpacer5],
      ),
    );
  }
}

class HistoryList extends HookConsumerWidget {
  const HistoryList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historySequence = ref.watch(historySequenceProvider);
    final alwaysShowHistoryPaneScrollbar = ref.watch(settingsProvider
        .select((value) => value.alwaysShowCollectionPaneScrollbar));
    final List<DateTime>? sortedHistoryKeys = historySequence?.keys.toList();
    sortedHistoryKeys?.sort((a, b) => b.compareTo(a));
    ScrollController scrollController = useScrollController();
    return Scrollbar(
      controller: scrollController,
      thumbVisibility: alwaysShowHistoryPaneScrollbar,
      radius: const Radius.circular(12),
      child: ListView(
        padding: context.isMediumWindow
            ? EdgeInsets.only(
                bottom: MediaQuery.paddingOf(context).bottom,
                right: 8,
              )
            : kPe8,
        controller: scrollController,
        children: sortedHistoryKeys != null
            ? sortedHistoryKeys.map((date) {
                var items = historySequence![date]!;
                final requestGroups = getRequestGroups(items);
                return Column(
                  children: [
                    ExpansionTile(
                      title: Text(
                        humanizeDate(date),
                      ),
                      children: requestGroups.values.map((item) {
                        return Padding(
                          padding: kPv2 + kPh4,
                          child: SidebarHistoryCard(
                            id: item.first.historyId,
                            models: item,
                            method: item.first.method,
                            selectedId:
                                ref.watch(selectedRequestGroupStateProvider),
                            requestGroupSize: item.length,
                            onTap: () {
                              ref
                                  .read(historyMetaStateNotifier.notifier)
                                  .loadHistoryRequest(item.first.historyId);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                );
              }).toList()
            : [
                const Text(
                  'No history',
                  style: TextStyle(color: Colors.grey),
                )
              ],
      ),
    );
  }
}
