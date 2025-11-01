import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';
import 'importer.dart';

void importToCollectionPane(
  BuildContext context,
  WidgetRef ref,
  ScaffoldMessengerState sm,
) {
  // TODO: The dialog must have a feature to paste contents in a text field
  // Also, a mechanism can be added where on importing a file it shows the
  // contents in the text field and then the user presses ok to add it to collection
  showImportDialog(
    context: context,
    importFormat: ref.watch(importFormatStateProvider),
    onImportFormatChange: (format) {
      if (format != null) {
        ref.read(importFormatStateProvider.notifier).state = format;
      }
    },
    onFileDropped: (file) {
      final importFormatType = ref.read(importFormatStateProvider);
      sm.hideCurrentSnackBar();
      file.readAsString().then(
        (content) {
          kImporter
              .getHttpRequestModelList(importFormatType, content)
              .then((importedRequestModels) async {
            if (importedRequestModels != null) {
              if (importedRequestModels.isEmpty) {
                sm.showSnackBar(
                    getSnackBar("No requests imported", small: false));
                if (!context.mounted) return;
                Navigator.of(context).pop();
              } else {
                // Determine if we should show selection dialog
                // Currently only Hurl format supports selective import
                final shouldShowSelectionDialog = 
                    importFormatType == ImportFormat.hurl;
                
                List<(String?, HttpRequestModel)> requestsToImport;
                
                if (shouldShowSelectionDialog && context.mounted) {
                  // Show selection dialog for Hurl files
                  final selectedRequests = await showRequestSelectionDialog(
                    context: context,
                    requests: importedRequestModels,
                  );
                  
                  // User cancelled or didn't select anything
                  if (selectedRequests == null || selectedRequests.isEmpty) {
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                    return;
                  }
                  
                  requestsToImport = selectedRequests;
                } else {
                  // Import all requests directly for other formats
                  requestsToImport = importedRequestModels;
                }
                
                // Import the requests
                for (var model in requestsToImport.reversed) {
                  ref
                      .read(collectionStateNotifierProvider.notifier)
                      .addRequestModel(
                        model.$2,
                        name: model.$1,
                      );
                }
                
                // Show success message
                sm.showSnackBar(getSnackBar(
                    "Successfully imported ${requestsToImport.length} request${requestsToImport.length == 1 ? '' : 's'}",
                    small: false));
                
                // Close the import dialog
                if (!context.mounted) return;
                Navigator.of(context).pop();
              }
            } else {
              var err = "Unable to parse ${file.name}";
              sm.showSnackBar(getSnackBar(err, small: false));
            }
          });
        },
        onError: (e) {
          var err = "Unable to import ${file.name}";
          sm.showSnackBar(getSnackBar(err, small: false));
        },
      );
    },
  );
}
