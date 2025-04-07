import 'package:apidash/models/api_catalog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'method_card.dart';

class MethodsList extends ConsumerWidget {
  final ApiCatalogModel catalog;
  
  const MethodsList({super.key, required this.catalog});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(catalog.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              ref.read(selectedCatalogIdProvider.notifier).state = null,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: catalog.endpoints!.length,
        itemBuilder: (context, index) {
          final endpoint = catalog.endpoints![index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: MethodCard(endpoint: endpoint),
          );
        },
      ),
    );
  }
}