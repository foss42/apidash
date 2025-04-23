import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/api_explorer_models.dart';

class ApiExplorerActionButtons extends ConsumerWidget {
  const ApiExplorerActionButtons({
    super.key,
    required this.endpoint,
  });

  final ApiEndpoint endpoint;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiExplorer = ref.read(apiExplorerProvider.notifier);
    
    return FilledButtonGroup(
      buttons: [
        ButtonData(
          icon: Icons.download_rounded,
          label: 'Try Now',
          onPressed: () => _handleImport(context, ref, apiExplorer),
          tooltip: "Import API Endpoint",
        ),
      ],
    );
  }

  Future<void> _handleImport(
    BuildContext context,
    WidgetRef ref,
    ApiExplorerNotifier apiExplorer,
  ) async {
    try {
      await apiExplorer.importEndpoint(endpoint, ref);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('API endpoint imported successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to import: ${e.toString()}'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}