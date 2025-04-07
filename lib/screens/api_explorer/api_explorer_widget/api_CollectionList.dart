import 'package:apidash/screens/api_explorer/api_explorer_widget/api_endpoint_card.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import '../../../models/models.dart';

class ApiCollectionList extends HookConsumerWidget {
  const ApiCollectionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiCollections = ref.watch(filteredCollectionsProvider);
    final alwaysShowScrollbar = ref.watch(settingsProvider
        .select((value) => value.alwaysShowCollectionPaneScrollbar));

    final searchQuery = ref.watch(apiSearchQueryProvider);
    final scrollController = ScrollController();
    final isLoading = ref.watch(apiExplorerLoadingProvider);

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (apiCollections.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.api, size: 48),
            kVSpacer16,
            Text(
              searchQuery.isEmpty
                  ? 'No API collections found'
                  : 'No results for "$searchQuery"',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        if (searchQuery.isNotEmpty) ...[
          Padding(
            padding: kPh8,
            child: Chip(
              label: Text('${apiCollections.length} results'),
              onDeleted: () =>
                  ref.read(apiSearchQueryProvider.notifier).state = '',
            ),
          ),
          kVSpacer5,
        ],
        Expanded(
          child: Scrollbar(
            controller: scrollController,
            thumbVisibility: alwaysShowScrollbar,
            radius: const Radius.circular(12),
            child: RefreshIndicator(
              onRefresh: () =>
                  ref.read(apiExplorerProvider.notifier).refreshApis(),
              child: ListView.separated(
                controller: scrollController,
                itemCount: apiCollections.length,
                separatorBuilder: (context, index) => Divider(
                  height: 0,
                  thickness: 2,
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                ),
                itemBuilder: (context, index) {
                  final collection = apiCollections[index];
                  return Padding(
                    padding: kPv2,
                    child: ApiCollectionExpansionTile(
                      collection: collection,
                      initiallyExpanded: index == 0 && searchQuery.isEmpty,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ApiCollectionExpansionTile extends HookConsumerWidget {
  const ApiCollectionExpansionTile({
    super.key,
    required this.collection,
    this.initiallyExpanded = false,
  });

  final ApiExplorerModel collection;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedEndpointId = ref.watch(selectedEndpointIdProvider);
    final selectedCollectionId = ref.watch(selectedCollectionIdProvider);

    return ExpansionTile(
      dense: true,
      title: Row(
        children: [
          Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: colorScheme.outline,
          ),
          kHSpacer5,
          Text(
            collection.name,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: selectedCollectionId == collection.id
                      ? colorScheme.primary
                      : colorScheme.outline,
                ),
          ),
        ],
      ),
      onExpansionChanged: (expanded) {
        if (expanded) {
          ref.read(selectedCollectionIdProvider.notifier).state = collection.id;
        } else {
          if (selectedCollectionId == collection.id) {
            ref.read(selectedCollectionIdProvider.notifier).state = null;
          }
        }
      },
      trailing: const SizedBox.shrink(),
      tilePadding: kPh8,
      shape: const RoundedRectangleBorder(),
      collapsedBackgroundColor: colorScheme.surfaceContainerLow,
      initiallyExpanded: initiallyExpanded,
      childrenPadding: kPv8 + kPe4,
      children: [
        Padding(
          padding: kPv2 + kPh4,
          child: ApiUrlCard(
            apiEndpoint: collection,  // Now properly typed
            isSelected: selectedEndpointId == collection.id,
            onTap: () {
              ref.read(selectedCollectionIdProvider.notifier).state = collection.id;
              ref.read(selectedEndpointIdProvider.notifier).state = collection.id;
              if (context.isMediumWindow) {
                kApiExplorerScaffoldKey.currentState?.closeDrawer();
              }
            },
          ),
        )
      ],
    );
  }
}