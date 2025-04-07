import 'package:apidash/models/api_catalog.dart';
import 'package:apidash/screens/api_explorer/api_explorer_widget/api_endpoint_card.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';

class ApiCollectionList extends ConsumerWidget {
  const ApiCollectionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiCatalogs = ref.watch(filteredCatalogsProvider);
    final alwaysShowScrollbar = ref.watch(settingsProvider
        .select((value) => value.alwaysShowCollectionPaneScrollbar));

    final searchQuery = ref.watch(apiSearchQueryProvider);
    final scrollController = ScrollController();
    final isLoading = ref.watch(apiCatalogLoadingProvider);

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (apiCatalogs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.api, size: 48),
            kVSpacer16,
            Text(
              searchQuery.isEmpty
                  ? 'No API catalogs found'
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
              label: Text('${apiCatalogs.length} results'),
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
                  ref.read(apiCatalogProvider.notifier).refreshApis(),
              child: ListView.separated(
                controller: scrollController,
                itemCount: apiCatalogs.length,
                separatorBuilder: (context, index) => Divider(
                  height: 0,
                  thickness: 2,
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                ),
                itemBuilder: (context, index) {
                  final catalog = apiCatalogs[index];
                  return Padding(
                    padding: kPv2,
                    child: ApiCatalogExpansionTile(
                      catalog: catalog,
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

class ApiCatalogExpansionTile extends ConsumerWidget {
  const ApiCatalogExpansionTile({
    super.key,
    required this.catalog,
    this.initiallyExpanded = false,
  });

  final ApiCatalogModel catalog;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedEndpointId = ref.watch(selectedEndpointIdProvider);
    final selectedCatalogId = ref.watch(selectedCatalogIdProvider);

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
            catalog.name,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: selectedCatalogId == catalog.id
                      ? colorScheme.primary
                      : colorScheme.outline,
                ),
          ),
        ],
      ),
      onExpansionChanged: (expanded) {
        if (expanded) {
          ref.read(selectedCatalogIdProvider.notifier).state = catalog.id;
        } else {
          if (selectedCatalogId == catalog.id) {
            ref.read(selectedCatalogIdProvider.notifier).state = null;
          }
        }
      },
      trailing: const SizedBox.shrink(),
      tilePadding: kPh8,
      shape: const RoundedRectangleBorder(),
      collapsedBackgroundColor: colorScheme.surfaceContainerLow,
      initiallyExpanded: initiallyExpanded,
      childrenPadding: kPv8 + kPe4,
      children: catalog.endpoints!.map((endpoint) => Padding(
        padding: kPv2 + kPh4,
        child: ApiUrlCard(
          endpoint: endpoint,
          isSelected: selectedEndpointId == endpoint.id,
          onTap: () {
            ref.read(selectedCatalogIdProvider.notifier).state = catalog.id;
            ref.read(selectedEndpointIdProvider.notifier).state = endpoint.id;
            if (context.isMediumWindow) {
              kApiExplorerScaffoldKey.currentState?.closeDrawer();
            }
          },
        ),
      )).toList(),
    );
  }
}