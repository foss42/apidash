import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'method_card.dart';

class MethodsList extends ConsumerWidget {
  final Map<String, dynamic> collection;
  
  const MethodsList({super.key, required this.collection});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final endpoints = List<Map<String, dynamic>>.from(collection['endpoints'] ?? []);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(collection['name'] ?? 'API Methods'),
          floating: true,
          snap: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () =>
                ref.read(selectedCollectionIdProvider.notifier).state = null,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final endpoint = endpoints[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MethodCard(endpoint: endpoint),
                );
              },
              childCount: endpoints.length,
            ),
          ),
        ),
      ],
    );
  }
}