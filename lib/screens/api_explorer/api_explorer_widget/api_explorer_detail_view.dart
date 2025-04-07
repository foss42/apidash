import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/api_explorer/api_explorer_widget/api_explorer_url_card.dart';
import 'package:apidash/screens/api_explorer/api_explorer_widget/splitView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/api_endpoint.dart';

class ApiExplorerDetailView extends ConsumerWidget {
  final ApiEndpointModel endpoint;
  final bool isMediumWindow;
  final TextEditingController searchController;

  const ApiExplorerDetailView({
    super.key,
    required this.endpoint,
    required this.isMediumWindow,
    required this.searchController,
  });

  void _handleBackNavigation(WidgetRef ref, BuildContext context) {
    ref.read(selectedEndpointIdProvider.notifier).state = null;
    ref.read(selectedCatalogIdProvider.notifier).state = null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(selectedCatalogProvider);
    final baseUrl = catalog?.baseUrl ?? '';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _handleBackNavigation(ref, context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: ApiExplorerURLCard(
              endpoint: endpoint,
              baseUrl: baseUrl,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: ApiExplorerSplitView(api: endpoint)),
          )
        ],
      ),
    );
  }
}