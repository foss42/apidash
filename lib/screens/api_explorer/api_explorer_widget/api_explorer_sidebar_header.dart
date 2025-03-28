import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash/providers/providers.dart';
import '../../../consts.dart';

class ApiExplorerSidebarHeader extends ConsumerWidget {
  const ApiExplorerSidebarHeader({super.key});

  Future<void> _showAddApiDialog(BuildContext context, WidgetRef ref) async {
    final sm = ScaffoldMessenger.of(context);
    final urlController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add API Specification'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: urlController,
                decoration: const InputDecoration(
                  labelText: 'API Spec URL',
                  hintText: 'https://example.com/api-spec.yaml',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.link),
                ),
                autofocus: true,
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
                      if (url.isEmpty) return;

                      Navigator.pop(context);
                      try {
                        await ref
                            .read(apiExplorerProvider.notifier)
                            .addCollectionFromUrl(url,ref);
                        sm.showSnackBar(const SnackBar(
                            content: Text('API imported successfully!')));
                      } catch (e) {
                        sm.showSnackBar(SnackBar(
                            content: Text('Error importing API: $e')));
                      }
                    },
                    child: const Text('Import'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mobileScaffoldKey = ref.read(mobileScaffoldKeyStateProvider);
    final sm = ScaffoldMessenger.of(context);
    return Padding(
      padding: kPe4,
      child: Row(
        children: [
          kHSpacer10,
          Text(
            "API Explorer",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Spacer(),
          ADIconButton(
            icon: Icons.add,
            iconSize: kButtonIconSizeLarge,
            tooltip: "Add API Spec",
            onPressed: () => _showAddApiDialog(context, ref),
          ),
          ADIconButton(
            icon: Icons.refresh,
            iconSize: kButtonIconSizeLarge,
            tooltip: "Refresh APIs",
            onPressed: () {
              ref.read(apiExplorerProvider.notifier).refreshApis(ref);
              sm.showSnackBar(
                const SnackBar(content: Text('Refreshing API collections')),
              );
            },
          ),
          context.width <= kMinWindowSize.width
              ? IconButton(
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(4),
                    minimumSize: const Size(36, 36),
                  ),
                  onPressed: () {
                    mobileScaffoldKey.currentState?.closeDrawer();
                  },
                  icon: const Icon(Icons.chevron_left),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}