import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import '../../../consts.dart';

class HistorySidebarHeader extends ConsumerWidget {
  const HistorySidebarHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mobileScaffoldKey = ref.read(mobileScaffoldKeyStateProvider);
    final sm = ScaffoldMessenger.of(context);
    final isSelectionMode = ref.watch(isHistorySelectionModeProvider);
    final selectedIds = ref.watch(selectedHistoryItemIdsProvider);

    return Padding(
      padding: kPe4,
      child: Row(
        children: [
          kHSpacer10,
          Text(
            isSelectionMode ? "${selectedIds.length} selected" : "History",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Spacer(),
          if (isSelectionMode) ...[
            ADIconButton(
              icon: Icons.done_all,
              iconSize: kButtonIconSizeLarge,
              tooltip: "Select All",
              onPressed: () {
                final historyMetas = ref.read(historyMetaStateNotifier);
                if (historyMetas != null) {
                  ref.read(selectedHistoryItemIdsProvider.notifier).state =
                      historyMetas.keys.toSet();
                }
              },
            ),
            ADIconButton(
              icon: Icons.delete_outline,
              iconSize: kButtonIconSizeLarge,
              tooltip: "Delete Selected",
              color: Theme.of(context).brightness == Brightness.dark
                  ? kColorDarkDanger
                  : kColorLightDanger,
              onPressed: selectedIds.isEmpty
                  ? null
                  : () {
                showOkCancelDialog(
                  context,
                  dialogTitle: "Delete Selected History",
                  content:
                  "Are you sure you want to delete the selected history items? This action cannot be undone.",
                  onClickOk: () async {
                    sm.hideCurrentSnackBar();
                    try {
                      await ref
                          .read(historyMetaStateNotifier.notifier)
                          .deleteHistoryRequests(selectedIds);
                      sm.showSnackBar(getSnackBar(
                        "Selected history deleted successfully",
                      ));
                    } catch (e) {
                      debugPrint("Delete Selected History Stack: $e");
                      sm.showSnackBar(getSnackBar(
                        "Error deleting selected history",
                        color: kColorRed,
                      ));
                    }
                  },
                );
              },
            ),
            ADIconButton(
              icon: Icons.close,
              iconSize: kButtonIconSizeLarge,
              tooltip: "Cancel Selection",
              onPressed: () {
                ref.read(isHistorySelectionModeProvider.notifier).state = false;
                ref.read(selectedHistoryItemIdsProvider.notifier).state = {};
              },
            ),
          ] else ...[
            ADIconButton(
              icon: Icons.checklist,
              iconSize: kButtonIconSizeLarge,
              tooltip: "Select",
              onPressed: () {
                ref.read(isHistorySelectionModeProvider.notifier).state = true;
              },
            ),
            ADIconButton(
              icon: Icons.delete_forever,
              iconSize: kButtonIconSizeLarge,
              tooltip: "Clear History",
              color: Theme.of(context).brightness == Brightness.dark
                  ? kColorDarkDanger
                  : kColorLightDanger,
              onPressed: () {
                showOkCancelDialog(
                  context,
                  dialogTitle: kTitleClearHistory,
                  content: kMsgClearHistory,
                  onClickOk: () async {
                    sm.hideCurrentSnackBar();
                    try {
                      await ref
                          .read(historyMetaStateNotifier.notifier)
                          .clearAllHistory();
                      sm.showSnackBar(getSnackBar(
                        kMsgClearHistorySuccess,
                      ));
                    } catch (e) {
                      debugPrint("Clear History Stack: $e");
                      sm.showSnackBar(getSnackBar(
                        kMsgClearHistoryError,
                        color: kColorRed,
                      ));
                    }
                  },
                );
              },
            ),
            ADIconButton(
              icon: Icons.manage_history_rounded,
              iconSize: kButtonIconSizeLarge,
              tooltip: "Manage History",
              onPressed: () {
                showHistoryRetentionDialog(
                    context,
                    ref.read(settingsProvider.select(
                            (value) => value.historyRetentionPeriod)), (value) {
                  ref.read(settingsProvider.notifier).update(
                    historyRetentionPeriod: value,
                  );
                });
              },
            ),
          ],
          context.width <= kMinWindowSize.width
              ? IconButton(
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(4),
              minimumSize: const Size(36, 36),
            ),
            onPressed: () {
              mobileScaffoldKey.currentState?.closeDrawer();
            },
            icon: const Icon(Icons.chevron_left),
          )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
