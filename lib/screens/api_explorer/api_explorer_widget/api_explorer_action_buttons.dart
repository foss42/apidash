import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/widgets/widgets.dart';
import '../../../models/api_endpoint.dart';
import '../../../providers/providers.dart';

class ApiExplorerActionButtons extends ConsumerWidget {
  const ApiExplorerActionButtons({super.key, this.endpoint});

  final ApiEndpointModel? endpoint;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiCatalog = ref.read(apiCatalogProvider.notifier);
    return FilledButtonGroup(
      buttons: [
        ButtonData(
          icon: Icons.download_rounded,
          label: 'Try Now',
          onPressed: () async {
            if (endpoint != null) {
              try {
                await apiCatalog.importEndpoint(endpoint!);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('API endpoint imported successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            }
          },
          tooltip: "Import API Endpoint",
        ),
      ],
    );
  }
}