import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
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
      final navigator = Navigator.of(context);
      sm.hideCurrentSnackBar();
      file.readAsString().then(
        (content) {
          kImporter
              .getHttpRequestModelList(importFormatType, content)
              .then((importedRequestModels) {
            final String message;
            if (importedRequestModels == null) {
              message = "Unable to parse ${file.name}";
            } else if (importedRequestModels.isEmpty) {
              message = "No requests imported";
            } else {
              for (var model in importedRequestModels.reversed) {
                ref
                    .read(collectionStateNotifierProvider.notifier)
                    .addRequestModel(
                      model.$2,
                      name: model.$1,
                    );
              }
              message =
                  "Successfully imported ${importedRequestModels.length} requests";
            }
            _showImportResult(navigator, sm, message);
          });
        },
        onError: (e) {
          _showImportResult(navigator, sm, "Unable to import ${file.name}");
        },
      );
    },
  );
}

/// Shows the import result once the dialog and, on mobile, the drawer are out
/// of the way: the scaffold's snackbar renders below both, so a message shown
/// while they are open stays hidden until they are closed.
void _showImportResult(
  NavigatorState navigator,
  ScaffoldMessengerState sm,
  String message,
) {
  // maybePop rather than pop: if the dialog was dismissed while the file was
  // being read and parsed, there is nothing to close and the route below it
  // must stay.
  navigator.maybePop();
  kHomeScaffoldKey.currentState?.closeDrawer();
  sm.showSnackBar(getSnackBar(message, small: false));
}
