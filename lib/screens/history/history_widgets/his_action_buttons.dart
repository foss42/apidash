import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/consts.dart';

class HistoryActionButtons extends ConsumerWidget {
  const HistoryActionButtons({super.key, this.historyRequestModel});

  final HistoryRequestModel? historyRequestModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestId = historyRequestModel?.metaData.requestId;
    final isAvailable =
        requestId != null &&
        ref.watch(requestSequenceProvider).contains(requestId);

    return FilledButtonGroup(
      buttons: [
        ButtonData(
          icon: Icons.copy_rounded,
          label: kLabelDuplicate,
          onPressed: requestId != null
              ? () {
                  ref
                      .read(activeCollectionProvider.notifier)
                      .duplicateFromHistory(historyRequestModel!);
                  ref.read(navRailIndexStateProvider.notifier).state = 0;
                }
              : null,
          tooltip: kTooltipDuplicateRequest,
        ),
        ButtonData(
          icon: Icons.north_east_rounded,
          label: kLabelRequest,
          onPressed: isAvailable
              ? () {
                  ref
                      .read(activeCollectionProvider.notifier)
                      .loadRequest(requestId);
                  ref.read(selectedIdStateProvider.notifier).state = requestId;
                  ref.read(navRailIndexStateProvider.notifier).state = 0;
                }
              : null,
          tooltip: isAvailable ? kTooltipGoToRequest : kTooltipRequestNotFound,
        ),
      ],
    );
  }
}
