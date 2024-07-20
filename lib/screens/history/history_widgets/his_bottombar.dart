import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/utils.dart';
import '../history_requests.dart';

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
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            requestCount > 1
                ? Badge(
                    label: Text(
                      requestCount > 9 ? '9 +' : requestCount.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    child: IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 500),
                                child: const HistorRequestsScrollableSheet());
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_up_rounded,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
