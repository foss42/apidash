import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'drag_and_drop_area.dart';
import 'dropdown_import_format.dart';
import '../consts.dart';

showImportDialog({
  required BuildContext context,
  required ImportFormat importFormat,
  Function(ImportFormat?)? onImportFormatChange,
  Function(XFile)? onFileDropped,
}) {
  showDialog(
    context: context,
    builder: (context) {
      var fmt = importFormat;
      return StatefulBuilder(
        builder: (context, StateSetter setState) {
          return AlertDialog(
            contentPadding: kP12,
            content: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
                minWidth: 280,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Use Wrap instead of Row to handle overflow gracefully
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      const Text(kLabelImport),
                      DropdownButtonImportFormat(
                        importFormat: fmt,
                        onChanged: (format) {
                          if (format != null) {
                            onImportFormatChange?.call(format);
                            setState(() {
                              fmt = format;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  kVSpacer6,
                  DragAndDropArea(
                    onFileDropped: onFileDropped,
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
