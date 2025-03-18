import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/widgets/tab_request_card.dart';
import 'package:apidash/utils/utils.dart';

class TabPane extends ConsumerWidget {
  const TabPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collection = ref.watch(collectionStateNotifierProvider);
    final requestSequence = ref.watch(requestSequenceProvider);
    final selectedId = ref.watch(selectedIdStateProvider);
    final visibleTabs = ref.watch(visibleTabsProvider);

    // Prevents rendering if data isn’t ready
    if (collection == null || requestSequence.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: SingleChildScrollView(  // horizontal scrolling for the tab bar
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            // Filters and maps only visible tabs for rendering
            children: requestSequence
                .where((id) => visibleTabs.contains(id))
                .map((id) {
                  final request = collection[id]!;
                  final name = request.name.isNotEmpty
                      ? request.name
                      : getRequestTitleFromUrl(request.httpRequestModel?.url) ?? 'Untitled';
                      
                  return TabRequestCard(
                    apiType: request.apiType,
                    method: request.httpRequestModel!.method,
                    name: name,
                    isSelected: selectedId == id,
                    onTap: () => ref.read(selectedIdStateProvider.notifier).state = id,
                    // Manages tab closure and selection adjustment
                    onClose: () {
                      ref.read(visibleTabsProvider.notifier).toggleVisibility(id);
                      if (selectedId == id) {
                        final remainingTabs = requestSequence.where((tabId) => visibleTabs.contains(tabId) && tabId != id).toList();
                        if (remainingTabs.isNotEmpty) {
                          ref.read(selectedIdStateProvider.notifier).state = remainingTabs.first;
                        } else {
                          ref.read(selectedIdStateProvider.notifier).state = null;
                        }
                      }
                    },
                  );
                })
                .toList(),
          ),
        ),
      ),
    );
  }
}