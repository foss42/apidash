import 'dart:io';
import 'package:apidash/consts.dart';
import 'package:apidash/dialogs/import/fallback_dialog.dart';
import 'package:apidash/dialogs/import/har_request_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ImportDialogWrapper extends StatefulWidget {
  const ImportDialogWrapper({super.key});

  @override
  State<ImportDialogWrapper> createState() => _ImportDialogWrapperState();
}

class _ImportDialogWrapperState extends State<ImportDialogWrapper> {
  /// Removes existing dialog from widget tree and
  /// pushes provided dialog, as a dialog chain.
  void popAndPushDialog({
    required Widget dialog,
    required BuildContext context,
    bool popOldDialog = true,
  }) {
    // Remove "Select File" dialog
    if (mounted && popOldDialog) {
      Navigator.of(context).pop();
    }

    showAdaptiveDialog(
      context: context,
      builder: (context) => dialog,
    );
  }

  /// Handles the imported file, to show appropriate dialog
  Future<void> setFile(String path) async {
    File file = File(path);
    ImportFileType type = identifyFileType(file);

    switch (type) {
      case ImportFileType.har:
        popAndPushDialog(
          context: context,
          dialog: ImportRequestsFromHARDialog(
            harFile: file,
          ),
        );
      default:
        popAndPushDialog(
          dialog: const ImportErrorDialog(),
          context: context,
          popOldDialog: false,
        );
    }
  }

  /// Returns type of import based on extension, or json file contents.
  ImportFileType identifyFileType(File file) {
    final path = file.uri.path;

    if (path.endsWith('.har')) {
      return ImportFileType.har;
    } else {
      return ImportFileType.unknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      contentPadding: const EdgeInsets.all(16.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          kVSpacer20,
          Column(
            children: [
              Text(
                'Import requests from a file.',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              kVSpacer20,
              InkWell(
                onTap: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();

                  if (result != null) {
                    setFile(result.files.single.path!);
                  } else {
                    // User canceled the picker
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    color: Colors.grey.shade400,
                  ),
                  child: const Text("Select archive"),
                ),
              ),
            ],
          ),
          kVSpacer20,
        ],
      ),
    );
  }
}
