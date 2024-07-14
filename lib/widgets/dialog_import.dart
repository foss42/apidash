import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'drag_and_drop_area.dart';

showImportDialog(
  BuildContext context,
  Function(XFile) onFileDropped,
) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(12),
        content: DragAndDropArea(
          onFileDropped: onFileDropped,
        ),
      );
    },
  );
}
