// api_explorer_browse_view.dart
import 'package:apidash/screens/api_explorer/api_explorer_browse-View/api_card.dart';
import 'package:apidash/screens/api_explorer/api_explorer_widget/error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';

import 'api_explorer_browse-View/empty_collections_view.dart';

class ApiExplorerBrowseView extends ConsumerWidget {
  final TextEditingController searchController;

  const ApiExplorerBrowseView({
    super.key,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(apiCatalogLoadingProvider);
    final error = ref.watch(apiCatalogErrorProvider);
    final filteredCatalogs = ref.watch(filteredCatalogsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('API Templates'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search APIs...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => searchController.clear(),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) =>
                  ref.read(apiSearchQueryProvider.notifier).state = value,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
                ? ErrorView(error: error)
                : filteredCatalogs.isEmpty
                    ? const EmptyCollectionsView()
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: filteredCatalogs.length,
                        itemBuilder: (context, index) => ApiCard(
                          catalog: filteredCatalogs[index],
                          theme: Theme.of(context),
                        ),
                        shrinkWrap: true,
                      ),
      ),
    );
  }
}