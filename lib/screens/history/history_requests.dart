import 'package:apidash/consts.dart';
import 'package:flutter/material.dart';
import 'package:apidash/providers/history_providers.dart';
import 'package:apidash/utils/history_utils.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryRequests extends ConsumerWidget {
  const HistoryRequests({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRequestId = ref.watch(selectedHistoryIdStateProvider);
    final selectedRequest = ref.watch(selectedHistoryRequestModelProvider);
    final historyMetas = ref.watch(historyMetaStateNotifier);
    final requestGroup = getRequestGroup(
        historyMetas?.values.toList(), selectedRequest?.metaData);
    return Column(
      children: [
        kVSpacer20,
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
                },
              ),
            ))
      ],
    );
  }
}
