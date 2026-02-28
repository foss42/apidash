import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'importer.dart';

void _handleImportContent(
  BuildContext context,
  WidgetRef ref,
  ScaffoldMessengerState sm,
  String content,
  [String? sourceLabel],
) {
  final importFormatType = ref.read(importFormatStateProvider);
  sm.hideCurrentSnackBar();
  kImporter.getHttpRequestModelList(importFormatType, content).then(
    (importedRequestModels) {
      if (importedRequestModels != null) {
        if (importedRequestModels.isEmpty) {
          sm.showSnackBar(getSnackBar("No requests imported", small: false));
        } else {
          for (var model in importedRequestModels.reversed) {
            ref
                .read(collectionStateNotifierProvider.notifier)
                .addRequestModel(model.$2, name: model.$1);
          }
          sm.showSnackBar(getSnackBar(
              "Successfully imported ${importedRequestModels.length} requests",
              small: false));
        }
        if (!context.mounted) return;
        Navigator.of(context).pop();
      } else {
        final err = sourceLabel != null
            ? "Unable to parse $sourceLabel"
            : "Unable to parse pasted content";
        sm.showSnackBar(getSnackBar(err, small: false));
      }
    },
  );
}

void importToCollectionPane(
  BuildContext context,
  WidgetRef ref,
  ScaffoldMessengerState sm,
) {
  showImportDialog(
    context: context,
    importFormat: ref.watch(importFormatStateProvider),
    onImportFormatChange: (format) {
      if (format != null) {
        ref.read(importFormatStateProvider.notifier).state = format;
      }
    },
    onFileDropped: (file) {
      sm.hideCurrentSnackBar();
      file.readAsString().then(
        (content) {
          _handleImportContent(context, ref, sm, content, file.name);
        },
        onError: (e) {
          sm.showSnackBar(
              getSnackBar("Unable to import ${file.name}", small: false));
        },
      );
    },
    onPastedContentImport: (content) {
      _handleImportContent(context, ref, sm, content);
    },
  );
}
