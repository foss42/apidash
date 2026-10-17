import 'dart:convert';
import 'dart:typed_data';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart';
import 'previewer_code.dart';

enum ExportDocFormat {
  markdown('Markdown (.md)', 'md', 'markdown'),
  curl('cURL Session', 'sh', 'bash');

  const ExportDocFormat(this.label, this.extension, this.highlightLanguage);
  final String label;
  final String extension;
  final String highlightLanguage;
}

Future<void> showExportDocDialog(
  BuildContext context, {
  required HttpRequestModel request,
  HttpResponseModel? response,
  String? requestName,
  Future<void> Function(String content, String filename)? onSaveToFile,
  Future<void> Function(String content)? onCopy,
}) async {
  await showDialog(
    context: context,
    builder: (context) => ExportDocumentDialog(
      request: request,
      response: response,
      requestName: requestName,
      onSaveToFile: onSaveToFile,
      onCopy: onCopy,
    ),
  );
}

class ExportDocumentDialog extends StatefulWidget {
  const ExportDocumentDialog({
    super.key,
    required this.request,
    this.response,
    this.requestName,
    this.onSaveToFile,
    this.onCopy,
  });

  final HttpRequestModel request;
  final HttpResponseModel? response;
  final String? requestName;
  final Future<void> Function(String content, String filename)? onSaveToFile;
  final Future<void> Function(String content)? onCopy;

  @override
  State<ExportDocumentDialog> createState() => _ExportDocumentDialogState();
}

class _ExportDocumentDialogState extends State<ExportDocumentDialog> {
  ExportDocFormat _selectedFormat = ExportDocFormat.markdown;
  late final String _markdownContent;
  late final String _curlContent;

  @override
  void initState() {
    super.initState();
    _markdownContent = const MarkdownDocGenerator().generate(
      request: widget.request,
      response: widget.response,
      requestName: widget.requestName,
    );
    _curlContent = const CurlSessionGenerator().generate(
      request: widget.request,
      response: widget.response,
      requestName: widget.requestName,
    );
  }

  String get _currentContent => _selectedFormat == ExportDocFormat.markdown
      ? _markdownContent
      : _curlContent;

  String get _defaultFileName {
    final dateStr = DateTime.now().toIso8601String().split('T').first;
    final prefix = (widget.requestName != null &&
            widget.requestName!.trim().isNotEmpty)
        ? widget.requestName!.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_')
        : 'api_doc';
    return _selectedFormat == ExportDocFormat.markdown
        ? '${prefix}_$dateStr.md'
        : 'curl_session_$dateStr.sh';
  }

  Future<void> _handleCopy() async {
    final sm = ScaffoldMessenger.of(context);
    try {
      if (widget.onCopy != null) {
        await widget.onCopy!(_currentContent);
      } else {
        await Clipboard.setData(ClipboardData(text: _currentContent));
      }
      sm.hideCurrentSnackBar();
      sm.showSnackBar(getSnackBar("Copied to clipboard"));
    } catch (e) {
      sm.hideCurrentSnackBar();
      sm.showSnackBar(getSnackBar("Failed to copy: $e"));
    }
  }

  Future<void> _handleSaveToFile() async {
    final sm = ScaffoldMessenger.of(context);
    final fileName = _defaultFileName;
    final ext = _selectedFormat.extension;

    try {
      if (widget.onSaveToFile != null) {
        await widget.onSaveToFile!(_currentContent, fileName);
        sm.hideCurrentSnackBar();
        sm.showSnackBar(getSnackBar("Saved to $fileName"));
        return;
      }

      final FileSaveLocation? saveLocation = await getSaveLocation(
        suggestedName: fileName,
        acceptedTypeGroups: [
          XTypeGroup(
            label: _selectedFormat.label,
            extensions: [ext],
          ),
        ],
      );

      if (saveLocation != null) {
        final bytes = Uint8List.fromList(utf8.encode(_currentContent));
        final xFile = XFile.fromData(
          bytes,
          name: fileName,
          mimeType: ext == 'md' ? 'text/markdown' : 'application/x-sh',
        );
        await xFile.saveTo(saveLocation.path);
        sm.hideCurrentSnackBar();
        sm.showSnackBar(getSnackBar("Document saved to ${saveLocation.path}"));
      }
    } catch (e) {
      sm.hideCurrentSnackBar();
      sm.showSnackBar(getSnackBar("Failed to save: $e"));
    }
  }

  @override
  Widget build(BuildContext context) {
    final codeTheme = Theme.of(context).brightness == Brightness.light
        ? kLightCodeTheme
        : kDarkCodeTheme;

    final mediaQuery = MediaQuery.of(context);
    final dialogWidth = (mediaQuery.size.width * 0.75).clamp(320.0, 750.0);
    final dialogHeight = (mediaQuery.size.height * 0.65).clamp(300.0, 550.0);

    return AlertDialog(
      icon: const Icon(Icons.description_outlined),
      iconColor: Theme.of(context).colorScheme.primary,
      title: const Text("Export API Documentation"),
      titleTextStyle: Theme.of(context).textTheme.titleLarge,
      content: SizedBox(
        width: dialogWidth,
        height: dialogHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<ExportDocFormat>(
              segments: const [
                ButtonSegment<ExportDocFormat>(
                  value: ExportDocFormat.markdown,
                  label: Text("Markdown (.md)"),
                  icon: Icon(Icons.description_outlined),
                ),
                ButtonSegment<ExportDocFormat>(
                  value: ExportDocFormat.curl,
                  label: Text("cURL Session"),
                  icon: Icon(Icons.terminal_outlined),
                ),
              ],
              selected: {_selectedFormat},
              onSelectionChanged: (newSelection) {
                setState(() {
                  _selectedFormat = newSelection.first;
                });
              },
            ),
            kVSpacer10,
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest,
                  ),
                  borderRadius: kBorderRadius8,
                ),
                padding: kP8,
                child: CodePreviewer(
                  key: ValueKey(_selectedFormat),
                  code: _currentContent,
                  theme: codeTheme,
                  language: _selectedFormat.highlightLanguage,
                  textStyle: kCodeStyle,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        ADFilledButton(
          icon: Icons.content_copy_rounded,
          label: "Copy to Clipboard",
          isTonal: true,
          onPressed: _handleCopy,
        ),
        ADFilledButton(
          icon: Icons.save_alt_rounded,
          label: "Save to File",
          onPressed: _handleSaveToFile,
        ),
        ADTextButton(
          label: "Close",
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
