import 'package:flutter/material.dart';

class EmptyCollectionsView extends StatelessWidget {
  const EmptyCollectionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_awesome_mosaic_rounded,
              size: 48, color: theme.colorScheme.outline),
          const SizedBox(height: 24),
          Text('No APIs Found', style: theme.textTheme.titleMedium),
          const SizedBox(height: 16),
          Text(
            'Try adjusting your search or add a new API collection',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          OutlinedButton(
              onPressed: () {}, child: const Text('Add New Collection')),
        ],
      ),
    );
  }
}