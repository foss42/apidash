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
      padding: (!context.isMediumWindow && kIsMacOS ? kPt24 : kPt8) +
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
    final selectedGroupId = ref.watch(selectedRequestGroupIdStateProvider);
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
        padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
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
                      initiallyExpanded: true,
                      children: requestGroups.values.map((item) {
                        return Padding(
                          padding: kPv2 + kPh4,
                          child: SidebarHistoryCard(
                            id: item.first.historyId,
                            models: item,
                            method: item.first.method,
                            isSelected: selectedGroupId ==
                                getHistoryRequestKey(item.first),
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
                const Center(
                  child: Text(
                    'No history',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              ],
      ),
    );
  }
}
