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
    final selectedRequest = ref.read(selectedHistoryRequestModelProvider);
    final historyMetas = ref.read(historyMetaStateNotifier);
    final requestGroup = getRequestGroup(
        historyMetas?.values.toList(), selectedRequest?.metaData);
    return Column(
      children: requestGroup
          .map((request) => SidebarHistoryCard(
                id: request.historyId,
                method: request.method,
                isSelected: selectedRequestId == request.historyId,
                onTap: () {
                  ref.read(selectedHistoryIdStateProvider.notifier).state =
                      request.historyId;
                },
                models: [request],
              ))
          .toList(),
    );
  }
}
