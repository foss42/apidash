import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/history_utils.dart';
import 'package:apidash/widgets/widgets.dart';

class HistoryRequests extends ConsumerWidget {
  const HistoryRequests({
    super.key,
    this.scrollController,
    this.onSelect,
  });

  final ScrollController? scrollController;
  final Function()? onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRequestId = ref.watch(selectedHistoryIdStateProvider);
    final selectedRequest = ref.watch(selectedHistoryRequestModelProvider);
    final historyMetas = ref.watch(historyMetaStateNotifier);
    final requestGroup = getRequestGroup(
        historyMetas?.values.toList(), selectedRequest?.metaData);
    return ListView(
      shrinkWrap: true,
      controller: scrollController,
      padding: kPh4,
      children: [
        kVSpacer10,
        ...requestGroup.map((request) => Padding(
              padding: kPv2 + kPh4,
              child: HistoryRequestCard(
                id: request.historyId,
                model: request,
                isSelected: selectedRequestId == request.historyId,
                onTap: () {
                  ref.read(selectedHistoryIdStateProvider.notifier).state =
                      request.historyId;
                  ref
                      .read(historyMetaStateNotifier.notifier)
                      .loadHistoryRequest(request.historyId);
                  onSelect?.call();
                },
              ),
            )),
        kVSpacer10,
      ],
    );
  }
}

class HistorRequestsScrollableSheet extends StatefulWidget {
  const HistorRequestsScrollableSheet({
    super.key,
  });

  @override
  State<HistorRequestsScrollableSheet> createState() =>
      _HistorRequestsScrollableSheetState();
}

class _HistorRequestsScrollableSheetState
    extends State<HistorRequestsScrollableSheet> {
  double sheetPosition = 0.5;
  final double dragSensitivity = 600;
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: sheetPosition,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              Grabber(
                onVerticalDragUpdate: (DragUpdateDetails details) {
                  setState(() {
                    sheetPosition -= details.delta.dy / dragSensitivity;
                    if (sheetPosition < 0.25) {
                      sheetPosition = 0.25;
                    }
                    if (sheetPosition > 0.9) {
                      sheetPosition = 0.9;
                    }
                  });
                },
                isOnDesktopAndWeb: isOnDesktopAndWeb,
              ),
              Expanded(
                child: HistoryRequests(
                  scrollController: scrollController,
                  onSelect: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          );
        });
  }

  bool get isOnDesktopAndWeb {
    if (kIsWeb) {
      return true;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return true;
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        return false;
    }
  }
}

class Grabber extends StatelessWidget {
  const Grabber({
    super.key,
    required this.onVerticalDragUpdate,
    required this.isOnDesktopAndWeb,
  });

  final ValueChanged<DragUpdateDetails> onVerticalDragUpdate;
  final bool isOnDesktopAndWeb;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final handle = Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: kPv10,
          width: 80.0,
          height: 6.0,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
    if (!isOnDesktopAndWeb) {
      return handle;
    }
    return GestureDetector(
      onVerticalDragUpdate: onVerticalDragUpdate,
      child: handle,
    );
  }
}
