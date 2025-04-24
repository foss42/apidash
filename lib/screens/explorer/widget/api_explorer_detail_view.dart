import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/explorer/widget/url_card.dart';
import 'package:apidash/screens/explorer/widget/splitView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/models/api_explorer_models.dart';

class ApiExplorerDetailView extends ConsumerWidget {
  final ApiEndpoint endpoint;
  final bool isMediumWindow;

  const ApiExplorerDetailView({
    super.key,
    required this.endpoint,
    required this.isMediumWindow,
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
        title: Text(endpoint.name),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: ApiExplorerURLCard(endpoint: endpoint),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: ApiExplorerSplitView(endpoint: endpoint),
            ),
          ),
        ],
      ),
    );
  }
}