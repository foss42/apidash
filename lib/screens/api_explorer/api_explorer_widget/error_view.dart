import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String error;
  const ErrorView({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded,
              size: 48, color: theme.colorScheme.error),
          const SizedBox(height: 24),
          Text('Unable to Load APIs', style: theme.textTheme.titleMedium),
          const SizedBox(height: 16),
          Text(error,
              textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 24),
          FilledButton.tonal(
              onPressed: () {}, child: const Text('Retry Connection')),
        ],
      ),
    );
  }
}