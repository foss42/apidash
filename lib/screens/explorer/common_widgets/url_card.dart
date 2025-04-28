import 'package:flutter/material.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/models/models.dart';
import 'chip.dart';
import '../import.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';

class UrlCard extends ConsumerWidget {
  final RequestModel? requestModel;

  const UrlCard({
    super.key,
    required this.requestModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final importedData = importRequestData(requestModel);
    final httpRequestModel = importedData.httpRequestModel;
    final url = httpRequestModel?.url ?? '';
    final method = httpRequestModel?.method.toString().split('.').last.toUpperCase() ?? 'GET';

    return Card(
      color: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Row(
          children: [
            CustomChip.httpMethod(method),
            kHSpacer10,
            Expanded(
              child: Text(
                url,
                style: const TextStyle(color: Colors.blue),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            kHSpacer20,
            ElevatedButton(
              onPressed: () {
                if (httpRequestModel != null) {
                  ref.read(collectionStateNotifierProvider.notifier).addRequestModel(
                    httpRequestModel,
                    name: requestModel?.name ?? 'Imported Request',
                  );
                   ScaffoldMessenger.of(context).showSnackBar(  //SnackBar notification
                    SnackBar(
                      content: Text('Request "${requestModel?.name ?? 'Imported Request'}" imported successfully'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  ref.read(navRailIndexStateProvider.notifier).state = 0;  // Navigate to HomePage ind 0
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text('Import'),
            ),
          ],
        ),
      ),
    );
  }
}