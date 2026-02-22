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
  Function(String content)? onTextSubmitted,
}) {
  showDialog(
    context: context,
    builder: (context) {
      var fmt = importFormat;
      final textController = TextEditingController();

      return StatefulBuilder(
        builder: (context, StateSetter setState) {
          // Use 60% of screen height, capped between 400–600
          final screenHeight = MediaQuery.of(context).size.height;
          final dialogHeight = (screenHeight * 0.6).clamp(400.0, 600.0);

          return AlertDialog(
            contentPadding: kP12,
            content: SizedBox(
              width: 500,
              height: dialogHeight,
              child: Column(
                children: [
                  // ── Format selector row ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        kLabelImport,
                        style: kTextStyleButton,
                      ),
                      kHSpacer8,
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

                  // ── Drag and drop area (compact) ──
                  SizedBox(
                    height: 120,
                    child: DragAndDropArea(
                      onFileDropped: onFileDropped,
                    ),
                  ),
                  kVSpacer6,

                  // ── Divider ──
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'OR paste content below',
                          style: kTextStyleSmall.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  kVSpacer6,

                  // ── Paste text field (takes remaining space) ──
                  Expanded(
                    child: TextField(
                      controller: textController,
                      expands: true,
                      maxLines: null,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText: _hintForFormat(fmt),
                        hintStyle: kCodeStyle.copyWith(
                          fontSize: 12,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.4),
                        ),
                        border: const OutlineInputBorder(),
                        contentPadding: kP10,
                      ),
                      style: kCodeStyle.copyWith(fontSize: 13),
                    ),
                  ),
                  kVSpacer6,

                  // ── Action buttons ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ADTextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        label: kLabelCancel,
                      ),
                      kHSpacer8,
                      ADFilledButton(
                        onPressed: () {
                          final text = textController.text.trim();
                          if (text.isNotEmpty) {
                            onTextSubmitted?.call(text);
                          }
                        },
                        label: kLabelImport,
                      ),
                    ],
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

String _hintForFormat(ImportFormat format) {
  return switch (format) {
    ImportFormat.curl =>
      'Paste cURL command here...\ne.g. curl -X GET https://api.example.com',
    ImportFormat.postman => 'Paste Postman collection JSON here...',
    ImportFormat.insomnia => 'Paste Insomnia export JSON here...',
    ImportFormat.har => 'Paste HAR (HTTP Archive) JSON here...',
  };
}
