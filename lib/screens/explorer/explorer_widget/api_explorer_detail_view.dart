import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/explorer/explorer_widget/api_explorer_url_card.dart';
import 'package:apidash/screens/explorer/explorer_widget/splitView.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ApiExplorerDetailView extends ConsumerWidget {
  final Map<String, dynamic> api;
  final bool isMediumWindow;
  final TextEditingController searchController;

  const ApiExplorerDetailView({
    super.key,
    required this.api,
    required this.isMediumWindow,
    required this.searchController,
  });

  void _handleBackNavigation(WidgetRef ref, BuildContext context) {
    ref.read(selectedEndpointIdProvider.notifier).state = null;
    ref.read(selectedCollectionIdProvider.notifier).state = null;
  }

 @override
Widget build(BuildContext context, WidgetRef ref) {
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
          child: ApiExplorerURLCard(apiEndpoint: api),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: ApiExplorerSplitView(api: api),
          ),
        ),
      ],
    ),
  );
}
}