import 'package:apidash/screens/explorer/explorer_widget/method_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/api_explorer_models.dart';

class MethodsList extends ConsumerWidget {
  final ApiCollection collection;
  
  const MethodsList({
    super.key, 
    required this.collection,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        itemCount: collection.endpoints.length,
        itemBuilder: (context, index) {
          final endpoint = collection.endpoints[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: MethodCard(endpoint: endpoint),
          );
        },
      ),
    );
  }
}