import 'package:apidash_design_system/ui/design_system_provider.dart';
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
  final ds = DesignSystemProvider.of(context);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(kLabelImport),
                    kHSpacer8(ds.scaleFactor),
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
                kVSpacer6(ds.scaleFactor),
                DragAndDropArea(
                  onFileDropped: onFileDropped,
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
