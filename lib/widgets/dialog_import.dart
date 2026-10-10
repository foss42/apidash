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
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                DragAndDropArea(onFileDropped: onFileDropped),
              ],
            ),
          );
        },
      );
    },
  );
}
