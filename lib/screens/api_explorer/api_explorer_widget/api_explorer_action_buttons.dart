import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/widgets/widgets.dart';
import '../../../providers/providers.dart';

class ApiExplorerActionButtons extends ConsumerWidget {
  const ApiExplorerActionButtons({super.key, this.endpoint});

  final Map<String, dynamic>? endpoint;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiExplorer = ref.read(apiExplorerProvider.notifier);
    return FilledButtonGroup(
      buttons: [
        ButtonData(
          icon: Icons.download_rounded,
          label: 'Try Now',
          onPressed: () async {
            try {
              await apiExplorer.importEndpoint(endpoint!, ref);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('API endpoint imported successfully')),
              );
            } catch (e) {
               ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(e.toString())),
              );
            }            
          },
          tooltip: "Import API Endpoint",
        ),
      ],
    );
  }
}
