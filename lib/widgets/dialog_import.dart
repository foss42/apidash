import 'package:apidash/consts.dart';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'drag_and_drop_area.dart';
import 'dropdown_import_format.dart';

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
            contentPadding: const EdgeInsets.all(12),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Import    ",style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width:8),
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
                const SizedBox(height:10),
                DragAndDropArea(
                  onFileDropped: onFileDropped,
                ),
                const SizedBox(height:12),
              ],
            ),
          );
        },
      );
    },
  );
}
