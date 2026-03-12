import 'package:flutter/material.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/providers.dart';

class DashbotSuggestButton extends ConsumerWidget {
  const DashbotSuggestButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = ref.watch(
        selectedRequestModelProvider.select((v) => v?.httpRequestModel?.url));
    final isEmptyUrl = (url == null || url.trim().isEmpty);
    final isGenerating = ref.watch(
        chatViewmodelProvider.select((state) => state.isGenerating));

    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        minimumSize: const Size(0, 36), // match URL bar height
      ),
      onPressed: (isEmptyUrl || isGenerating)
          ? null
          : () async {
              final error = await ref
                  .read(chatViewmodelProvider.notifier)
                  .suggestRequestConfig();
              if (error != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      error,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onError,
                          ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              }
            },
      icon: isGenerating
          ? const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.auto_awesome, size: 16),
      label: const Text('Smart Suggest'),
    );
  }
}
