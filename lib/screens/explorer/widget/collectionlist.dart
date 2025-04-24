import 'package:apidash/screens/explorer/widget/api_endpoint_card.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/models/api_explorer_models.dart';

class ApiCollectionList extends ConsumerWidget {
  const ApiCollectionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiCollections = ref.watch(filteredCollectionsProvider);
    final alwaysShowScrollbar = ref.watch(settingsProvider
        .select((value) => value.alwaysShowCollectionPaneScrollbar));
    final searchQuery = ref.watch(apiSearchQueryProvider);
    final isLoading = ref.watch(apiExplorerLoadingProvider);

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (apiCollections.isEmpty) {
      return _buildEmptyState(context, searchQuery);
    }

    return Column(
      children: [
        if (searchQuery.isNotEmpty) _buildSearchResultsHeader(ref, apiCollections),
        Expanded(
          child: _buildCollectionsList(ref, apiCollections, alwaysShowScrollbar),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, String searchQuery) {
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

  Widget _buildSearchResultsHeader(WidgetRef ref, List<ApiCollection> collections) {
    return Padding(
      padding: kPh8,
      child: Chip(
        label: Text('${collections.length} results'),
        onDeleted: () => ref.read(apiSearchQueryProvider.notifier).state = '',
      ),
    );
  }

  Widget _buildCollectionsList(
    WidgetRef ref,
    List<ApiCollection> collections,
    bool alwaysShowScrollbar,
  ) {
    return Scrollbar(
      thumbVisibility: alwaysShowScrollbar,
      radius: const Radius.circular(12),
      child: RefreshIndicator(
        onRefresh: () => ref.read(apiExplorerProvider.notifier).refreshApis(ref),
        child: ListView.separated(
          itemCount: collections.length,
          separatorBuilder: (context, index) => Divider(
            height: 0,
            thickness: 2,
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
          ),
          itemBuilder: (context, index) {
            final collection = collections[index];
            return Padding(
              padding: kPv2,
              child: ApiCollectionExpansionTile(
                collection: collection,
                initiallyExpanded: index == 0 && 
                    ref.read(apiSearchQueryProvider).isEmpty,
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

    return ExpansionTile(
      dense: true,
      title: _buildTitle(context, colorScheme, selectedCollectionId),
      onExpansionChanged: (expanded) => _handleExpansionChanged(ref, expanded),
      trailing: const SizedBox.shrink(),
      tilePadding: kPh8,
      shape: const RoundedRectangleBorder(),
      collapsedBackgroundColor: colorScheme.surfaceContainerLow,
      initiallyExpanded: initiallyExpanded,
      childrenPadding: kPv8 + kPe4,
      children: _buildEndpointCards(ref, context, selectedEndpointId),
    );
  }

  Widget _buildTitle(
    BuildContext context,
    ColorScheme colorScheme,
    String? selectedCollectionId,
  ) {
    return Row(
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
    );
  }

  void _handleExpansionChanged(WidgetRef ref, bool expanded) {
    if (expanded) {
      ref.read(selectedCollectionIdProvider.notifier).state = collection.id;
    } else {
      if (ref.read(selectedCollectionIdProvider) == collection.id) {
        ref.read(selectedCollectionIdProvider.notifier).state = null;
      }
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

    if (context.isMediumWindow) {
      kApiExplorerScaffoldKey.currentState?.closeDrawer();
    }
  }
}