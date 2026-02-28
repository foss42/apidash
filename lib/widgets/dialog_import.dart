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
  Function(String)? onPastedContentImport,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        contentPadding: kP12,
        content: _ImportDialogContent(
          importFormat: importFormat,
          onImportFormatChange: onImportFormatChange,
          onFileDropped: onFileDropped,
          onPastedContentImport: onPastedContentImport,
        ),
      );
    },
  );
}

class _ImportDialogContent extends StatefulWidget {
  const _ImportDialogContent({
    required this.importFormat,
    this.onImportFormatChange,
    this.onFileDropped,
    this.onPastedContentImport,
  });

  final ImportFormat importFormat;
  final Function(ImportFormat?)? onImportFormatChange;
  final Function(XFile)? onFileDropped;
  final Function(String)? onPastedContentImport;

  @override
  State<_ImportDialogContent> createState() => _ImportDialogContentState();
}

class _ImportDialogContentState extends State<_ImportDialogContent> {
  late ImportFormat _fmt;
  final TextEditingController _pasteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fmt = widget.importFormat;
  }

  @override
  void didUpdateWidget(_ImportDialogContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.importFormat != widget.importFormat) {
      _fmt = widget.importFormat;
    }
  }

  @override
  void dispose() {
    _pasteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(kLabelImport),
              kHSpacer8,
              DropdownButtonImportFormat(
                importFormat: _fmt,
                onChanged: (format) {
                  if (format != null) {
                    widget.onImportFormatChange?.call(format);
                    setState(() {
                      _fmt = format;
                    });
                  }
                },
              ),
            ],
          ),
          kVSpacer6,
          DragAndDropArea(
            onFileDropped: widget.onFileDropped,
          ),
          if (widget.onPastedContentImport != null) ...[
            kVSpacer10,
            const Text('Or paste content below'),
            kVSpacer6,
            TextField(
              controller: _pasteController,
              maxLines: 6,
              minLines: 2,
              decoration: const InputDecoration(
                hintText: 'Paste cURL, Postman, Insomnia, or HAR content…',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            kVSpacer6,
            Align(
              alignment: Alignment.centerRight,
              child: ADFilledButton(
                onPressed: () {
                  final content = _pasteController.text.trim();
                  if (content.isNotEmpty) {
                    widget.onPastedContentImport!.call(content);
                  }
                },
                child: const Text('Import from pasted text'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
