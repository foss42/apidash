import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/providers/providers.dart';
class AddApiDialog extends ConsumerWidget {
  const AddApiDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sm = ScaffoldMessenger.of(context);
    final urlController = TextEditingController();
    final nameController = TextEditingController();
    return AlertDialog(
      title: const Text('Add API Specification'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Collection Name',
                hintText: 'My API Collection',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.collections_bookmark),
              ),
              maxLength: 40,
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                labelText: 'API Spec URL',
                hintText: 'https://example.com/api-spec.yaml',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
              maxLength: 200,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () async {
                    final url = urlController.text.trim();
                    final name = nameController.text.trim();
                    if (url.isEmpty) return;

                    Navigator.pop(context);
                    try {
                      await ref
                          .read(apiExplorerProvider.notifier)
                          .addCollectionFromUrl(
                            url,
                            ref,
                          );
                      sm.showSnackBar(
                        const SnackBar(content: Text('API imported successfully!')),
                      );
                    } catch (e) {
                      sm.showSnackBar(
                        SnackBar(content: Text('Error importing API: $e')),
                      );
                    }
                  },
                  child: const Text('Import'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
