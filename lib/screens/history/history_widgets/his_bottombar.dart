import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/extensions/extensions.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/utils.dart';
import '../history_requests.dart';
import 'his_action_buttons.dart';

class HistoryPageBottombar extends ConsumerWidget {
  const HistoryPageBottombar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRequestModel = ref.watch(selectedHistoryRequestModelProvider);
    final historyMetas = ref.watch(historyMetaStateNotifier);
    final requestGroup = getRequestGroup(
        historyMetas?.values.toList(), selectedRequestModel?.metaData);
    final requestCount = requestGroup.length;

    return Container(
      height: 60 + MediaQuery.paddingOf(context).bottom,
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.only(
        bottom: MediaQuery.paddingOf(context).bottom,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.onInverseSurface,
            width: 1,
          ),
        ),
      ),
      child: context.isMediumWindow
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HistoryActionButtons(historyRequestModel: selectedRequestModel),
                HistorySheetButton(requestCount: requestCount)
              ],
            )
          : Center(
              child: HistoryActionButtons(
                  historyRequestModel: selectedRequestModel)),
    );
  }
}

class HistorySheetButton extends StatelessWidget {
  const HistorySheetButton({
    super.key,
    required this.requestCount,
  });

  final int requestCount;

  @override
  Widget build(BuildContext context) {
    final isCompact = context.isCompactWindow;
    const icon = Icon(Icons.keyboard_arrow_up_rounded);
    return Badge(
      isLabelVisible: requestCount > 1,
      label: Text(
        requestCount > 9 ? '9+' : requestCount.toString(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      child: FilledButton.tonal(
        style: FilledButton.styleFrom(
          minimumSize: const Size(44, 44),
          padding: isCompact ? kP4 : const EdgeInsets.fromLTRB(16, 12, 8, 12),
        ),
        onPressed: requestCount > 1
            ? () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: const HistorRequestsScrollableSheet());
                  },
                );
              }
            : null,
        child: isCompact
            ? icon
            : const Row(
                children: [
                  Text(
                    "Show All",
                    style: kTextStyleButton,
                  ),
                  kHSpacer5,
                  icon,
                ],
              ),
      ),
    );
  }
}
