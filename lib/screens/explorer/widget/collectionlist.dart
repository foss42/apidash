import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash/screens/explorer/widget/endpoint_card.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/models/api_explorer_models.dart';

class ApiCollectionList extends ConsumerWidget {
  const ApiCollectionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiCollections = ref.watch(filteredCollectionsProvider);
    final alwaysShowScrollbar = ref.watch(
      settingsProvider.select((value) => value.alwaysShowCollectionPaneScrollbar),
    );
    final searchQuery = ref.watch(apiSearchQueryProvider);
    final isLoading = ref.watch(apiExplorerLoadingProvider);

    return _buildContent(
      context,
      ref,
      isLoading: isLoading,
      collections: apiCollections,
      searchQuery: searchQuery,
      alwaysShowScrollbar: alwaysShowScrollbar,
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref, {
    required bool isLoading,
    required List<ApiCollection> collections,
    required String searchQuery,
    required bool alwaysShowScrollbar,
  }) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    }

    if (collections.isEmpty) {
      return _buildEmptyState(context, searchQuery);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (searchQuery.isNotEmpty)
          _buildSearchResultsHeader(ref, collections),
        Expanded(
          child: _buildCollectionsList(
            ref,
            collections,
            alwaysShowScrollbar,
            searchQuery,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, String searchQuery) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.api,
            size: 48,
            color: Theme.of(context).colorScheme.outline,
          ),
          kVSpacer16,
          Text(
            searchQuery.isEmpty
                ? 'No API collections found'
                : 'No results for "$searchQuery"',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          if (searchQuery.isEmpty) ...[
            kVSpacer8,
            Text(
              'Add a new collection to get started',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchResultsHeader(
    WidgetRef ref,
    List<ApiCollection> collections,
  ) {
    return Padding(
      padding: kPh8.add(const EdgeInsets.only(top: 8)),
      child: Row(
        children: [
          Chip(
            label: Text(
              '${collections.length} ${collections.length == 1 ? 'result' : 'results'}',
            ),
            onDeleted: () => ref.read(apiSearchQueryProvider.notifier).state = '',
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            iconSize: 20,
            onPressed: () => ref.read(apiSearchQueryProvider.notifier).state = '',
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionsList(
    WidgetRef ref,
    List<ApiCollection> collections,
    bool alwaysShowScrollbar,
    String searchQuery,
  ) {
    return Scrollbar(
      thumbVisibility: alwaysShowScrollbar,
      radius: const Radius.circular(12),
      child: RefreshIndicator(
        onRefresh: () => ref.read(apiExplorerProvider.notifier).refreshApis(ref),
        displacement: 40,
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: 16),
          itemCount: collections.length,
          separatorBuilder: (context, index) => Divider(
            height: 0,
            thickness: 1,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          itemBuilder: (context, index) {
            final collection = collections[index];
            return Padding(
              padding: kPv2,
              child: ApiCollectionExpansionTile(
                key: ValueKey('collection-${collection.id}'),
                collection: collection,
                initiallyExpanded: index == 0 && searchQuery.isEmpty,
              ),
            );
          },
        ),
      ),
    );
  }
}

class ApiCollectionExpansionTile extends ConsumerWidget {
  const ApiCollectionExpansionTile({
    super.key,
    required this.collection,
    this.initiallyExpanded = false,
  });

  final ApiCollection collection;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedEndpointId = ref.watch(selectedEndpointIdProvider);
    final selectedCollectionId = ref.watch(selectedCollectionIdProvider);
    final isSelected = selectedCollectionId == collection.id;

    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        key: ValueKey('collection-tile-${collection.id}'),
        dense: true,
        title: _buildTitle(context, isSelected),
        onExpansionChanged: (expanded) => _handleExpansionChanged(ref, expanded),
        trailing: const SizedBox.shrink(),
        tilePadding: kPh8,
        shape: const RoundedRectangleBorder(),
        collapsedBackgroundColor: colorScheme.surfaceContainerLow,
        backgroundColor: colorScheme.surfaceContainerLow,
        initiallyExpanded: initiallyExpanded,
        childrenPadding: kPv8 + kPe4,
        children: _buildEndpointCards(ref, context, selectedEndpointId),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, bool isSelected) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        AnimatedRotation(
          turns: isSelected ? 0.25 : 0,
          duration: const Duration(milliseconds: 200),
          child: Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: isSelected 
                ? colorScheme.primary 
                : colorScheme.outline,
          ),
        ),
        kHSpacer5,
        Expanded(
          child: Text(
            collection.name,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (collection.endpoints.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              '${collection.endpoints.length}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colorScheme.outline,
                  ),
            ),
          ),
      ],
    );
  }

  void _handleExpansionChanged(WidgetRef ref, bool expanded) {
    if (expanded) {
      ref.read(selectedCollectionIdProvider.notifier).state = collection.id;
    } else if (ref.read(selectedCollectionIdProvider) == collection.id) {
      ref.read(selectedCollectionIdProvider.notifier).state = null;
    }
  }

  List<Widget> _buildEndpointCards(
    WidgetRef ref,
    BuildContext context,
    String? selectedEndpointId,
  ) {
    return collection.endpoints.map((endpoint) {
      return Padding(
        padding: kPv2 + kPh4,
        child: ApiUrlCard(
          key: ValueKey('endpoint-card-${endpoint.id}'),
          endpoint: endpoint,
          isSelected: selectedEndpointId == endpoint.id,
          onTap: () => _handleEndpointTap(ref, context, endpoint),
        ),
      );
    }).toList();
  }

  void _handleEndpointTap(
    WidgetRef ref,
    BuildContext context,
    ApiEndpoint endpoint,
  ) {
    ref.read(selectedCollectionIdProvider.notifier).state = collection.id;
    ref.read(selectedEndpointIdProvider.notifier).state = endpoint.id;

    // Close drawer on medium screens for better UX
    if (context.isMediumWindow) {
      kApiExplorerScaffoldKey.currentState?.closeDrawer();
    }
  }
}