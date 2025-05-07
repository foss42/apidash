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
          Center(
            child: Text('No APIs Found', style: theme.textTheme.titleMedium),
          )
        ],
      ),
    );
  }
}
