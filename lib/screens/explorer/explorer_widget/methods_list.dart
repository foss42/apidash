import 'package:apidash/screens/explorer/explorer_widget/method_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';

class MethodsList extends ConsumerWidget {
  final Map<String, dynamic> collection;
  
  const MethodsList({
    super.key, 
    required this.collection,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final endpoints = collection['endpoints'] as List<dynamic>? ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(collection['name'] ?? 'API Collection'),
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
          final endpoint = endpoints[index] as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: MethodCard(endpoint: endpoint),
          );
        },
      ),
    );
  }
}