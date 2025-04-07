import 'package:apidash/models/api_explorer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'method_card.dart';

class MethodsList extends ConsumerWidget {
  final ApiExplorerModel collection;
  
  const MethodsList({super.key, required this.collection});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Assuming endpoints are stored in the parameters field
    // If you have a different structure, adjust this accordingly
    final endpoints = collection.parameters.map((param) {
      return ApiExplorerModel(
        id: '${collection.id}-${param.name}',
        name: param.name,
        source: collection.source,
        updatedAt: collection.updatedAt,
        path: param.name, // Adjust as needed
        method: collection.method, // Or extract from parameter
        baseUrl: collection.baseUrl,
        parameters: [param],
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(collection.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              ref.read(selectedCollectionIdProvider.notifier).state = null,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: endpoints.length,
        itemBuilder: (context, index) {
          final endpoint = endpoints[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: MethodCard(endpoint: endpoint),
          );
        },
      ),
    );
  }
}