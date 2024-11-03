import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:apidash/extensions/extensions.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';
import 'history_widgets/history_widgets.dart';

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
        children: [
          HistorySidebarHeader(),
          Expanded(child: HistoryList()),
          kVSpacer5,
        ],
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
      child: ListView.separated(
        padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
        controller: scrollController,
        itemCount: sortedHistoryKeys?.length ?? 0,
        separatorBuilder: (context, index) => Divider(
          height: 0,
          thickness: 2,
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
        ),
        itemBuilder: (context, index) {
          var items = historySequence![sortedHistoryKeys![index]]!;
          final requestGroups = getRequestGroups(items);
          return Padding(
            padding: kPv2,
            child: HistoryExpansionTile(
              date: sortedHistoryKeys[index],
              requestGroups: requestGroups,
              initiallyExpanded: index == 0,
            ),
          );
        },
      ),
    );
  }
}

class HistoryExpansionTile extends StatefulHookConsumerWidget {
  const HistoryExpansionTile({
    super.key,
    required this.requestGroups,
    required this.date,
    this.initiallyExpanded = false,
  });

  final Map<String, List<HistoryMetaModel>> requestGroups;
  final DateTime date;
  final bool initiallyExpanded;

  @override
  ConsumerState<HistoryExpansionTile> createState() =>
      _HistoryExpansionTileState();
}

class _HistoryExpansionTileState extends ConsumerState<HistoryExpansionTile>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      initialValue: widget.initiallyExpanded ? 1.0 : 0.0,
    );
    final animation = Tween(begin: 0.0, end: 0.25).animate(animationController);
    final colorScheme = Theme.of(context).colorScheme;
    final selectedGroupId = ref.watch(selectedRequestGroupIdStateProvider);
    return ExpansionTile(
      dense: true,
      title: Row(
        children: [
          RotationTransition(
              turns: animation,
              child: Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: colorScheme.onSurface.withOpacity(0.6),
              )),
          kHSpacer5,
          Text(
            humanizeDate(widget.date),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
        ],
      ),
      onExpansionChanged: (value) {
        if (value) {
          animationController.forward();
        } else {
          animationController.reverse();
        }
      },
      trailing: const SizedBox.shrink(),
      tilePadding: kPh8,
      shape: const RoundedRectangleBorder(),
      collapsedBackgroundColor: colorScheme.surfaceContainerLow,
      initiallyExpanded: widget.initiallyExpanded,
      childrenPadding: kPv8 + kPe4,
      children: widget.requestGroups.values.map((item) {
        return Padding(
          padding: kPv2 + kPh4,
          child: SidebarHistoryCard(
            id: item.first.historyId,
            models: item,
            method: item.first.method,
            isSelected: selectedGroupId == getHistoryRequestKey(item.first),
            requestGroupSize: item.length,
            onTap: () {
              ref
                  .read(historyMetaStateNotifier.notifier)
                  .loadHistoryRequest(item.first.historyId);
              kHisScaffoldKey.currentState?.closeDrawer();
            },
          ),
        );
      }).toList(),
    );
  }
}
