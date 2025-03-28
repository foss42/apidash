import 'package:apidash/screens/api_explorer/api_explorer_widget/empty_collections_view.dart';
import 'package:apidash/screens/api_explorer/api_explorer_widget/error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';

class ApiExplorerBrowseView extends ConsumerWidget {
  final ScrollController scrollController;
  final TextEditingController searchController;

  const ApiExplorerBrowseView({
    super.key,
    required this.scrollController,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(apiExplorerLoadingProvider);
    final error = ref.watch(apiExplorerErrorProvider);
    final filteredCollections = ref.watch(filteredCollectionsProvider);

    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
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
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: isLoading
                ? const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()))
                : error != null
                    ? SliverFillRemaining(child: ErrorView(error: error))
                    : filteredCollections.isEmpty
                        ? const SliverFillRemaining(
                            child: EmptyCollectionsView())
                        : SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 300,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 1.2,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => _buildApiTemplateCard(
                                  context, ref, filteredCollections[index]),
                              childCount: filteredCollections.length,
                            ),
                          ),
          ),
        ],
      ),
    );
  }
  }

  Widget _buildApiTemplateCard(
      BuildContext context,
      WidgetRef ref, // Add WidgetRef parameter
      Map<String, dynamic> collection) {
    final theme = Theme.of(context);
    final endpoints =
        List<Map<String, dynamic>>.from(collection['endpoints'] ?? []);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          ref.read(selectedEndpointIdProvider.notifier).state = null;
          ref.read(selectedCollectionIdProvider.notifier).state = collection['id'];
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.api,
                        color: theme.colorScheme.primary, size: 24),
                  ),
                  const Spacer(),
                  Text(
                    '${endpoints.length} Endpoints',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.outline),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                collection['name'] ?? 'Unnamed API',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  collection['description'] ?? 'No description provided',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.outline),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (endpoints.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: endpoints
                      .take(3)
                      .map((e) => Chip(
                            label: Text(e['method'] ?? 'GET',
                                style: theme.textTheme.labelSmall),
                            backgroundColor: theme.colorScheme.surfaceVariant,
                            visualDensity: VisualDensity.compact,
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

