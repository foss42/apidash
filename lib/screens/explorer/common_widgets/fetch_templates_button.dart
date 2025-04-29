import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/templates_provider.dart';
import 'package:apidash_design_system/apidash_design_system.dart';

class FetchTemplatesButton extends ConsumerWidget {
  const FetchTemplatesButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesState = ref.watch(templatesProvider);

    return ElevatedButton(
      onPressed: templatesState.isLoading
          ? null
          : () async {
              await ref.read(templatesProvider.notifier).fetchTemplatesFromGitHub();
              final newState = ref.read(templatesProvider);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    newState.error ??
                        'New templates fetched successfully!',
                    style: const TextStyle(fontSize: 14),
                  ),
                  backgroundColor: newState.error != null
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.primary,
                  behavior: SnackBarBehavior.floating,
                  width: 400,
                  padding: kP12,
                ),
              );
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: templatesState.isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Text('Fetch Latest'),
    );
  }
}