import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/consts.dart';  // Add this import for ImportFormat  // Make sure this is included
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/widgets/openapi_selection_dialog.dart'; // Add this import
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
        (content) async { 
          final importedRequestModels = await kImporter
              .getHttpRequestModelList(importFormatType, content);
              
          if (importedRequestModels != null) {
            if (importedRequestModels.isEmpty) {
              sm.showSnackBar(
                  getSnackBar("No requests imported", small: false));
            } else {
              // for OpenAPI selection the dialog box will be shown
              // to select the endpoints to import
              List<(String?, HttpRequestModel)> requestsToImport = importedRequestModels;
              
              if (importFormatType == ImportFormat.openapi && importedRequestModels.length > 1) {
                final selectedRequests = await showOpenApiSelectionDialog(
                  context: context,
                  requests: importedRequestModels,
                );
                
                if (selectedRequests == null || selectedRequests.isEmpty) {
                  // User cancelled or selected none
                  sm.showSnackBar(getSnackBar("Import cancelled", small: false));
                  return;
                }
                
                requestsToImport = selectedRequests;
              }
            
              
              // requestsToImport instead of importedRequestModels
              for (var model in requestsToImport.reversed) {
                ref
                    .read(collectionStateNotifierProvider.notifier)
                    .addRequestModel(
                      model.$2,
                      name: model.$1,
                    );
              }
              sm.showSnackBar(getSnackBar(
                  "Successfully imported ${requestsToImport.length} requests", // Update this
                  small: false));
            }
            // Solves - Do not use BuildContexts across async gaps
            if (!context.mounted) return;
            Navigator.of(context).pop();
          } else {
            var err = "Unable to parse ${file.name}";
            sm.showSnackBar(getSnackBar(err, small: false));
          }
        },
        onError: (e) {
          var err = "Unable to import ${file.name}";
          sm.showSnackBar(getSnackBar(err, small: false));
        },
      );
    },
  );
}