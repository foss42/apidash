import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart';
import 'previewer_code.dart';

extension ExportDocContextX on BuildContext {
  bool get isSmallWindow => isCompactWindow;
}

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
  bool? isBottomSheet,
}) async {
  final useBottomSheet = isBottomSheet ?? context.isMediumWindow;
  if (useBottomSheet) {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ExportDocumentDialog(
        request: request,
        response: response,
        requestName: requestName,
        onSaveToFile: onSaveToFile,
        onCopy: onCopy,
        isBottomSheet: true,
      ),
    );
  } else {
    await showDialog(
      context: context,
      builder: (context) => ExportDocumentDialog(
        request: request,
        response: response,
        requestName: requestName,
        onSaveToFile: onSaveToFile,
        onCopy: onCopy,
        isBottomSheet: false,
      ),
    );
  }
}

Future<void> showExportDocBottomSheet(
  BuildContext context, {
  required HttpRequestModel request,
  HttpResponseModel? response,
  String? requestName,
  Future<void> Function(String content, String filename)? onSaveToFile,
  Future<void> Function(String content)? onCopy,
}) async {
  await showExportDocDialog(
    context,
    request: request,
    response: response,
    requestName: requestName,
    onSaveToFile: onSaveToFile,
    onCopy: onCopy,
    isBottomSheet: true,
  );
}

class ExportDocumentSheet extends StatelessWidget {
  const ExportDocumentSheet({
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
  Widget build(BuildContext context) {
    return ExportDocumentDialog(
      request: request,
      response: response,
      requestName: requestName,
      onSaveToFile: onSaveToFile,
      onCopy: onCopy,
      isBottomSheet: true,
    );
  }
}

class ExportDocumentDialog extends StatefulWidget {
  const ExportDocumentDialog({
    super.key,
    required this.request,
    this.response,
    this.requestName,
    this.onSaveToFile,
    this.onCopy,
    this.isBottomSheet = false,
  });

  final HttpRequestModel request;
  final HttpResponseModel? response;
  final String? requestName;
  final Future<void> Function(String content, String filename)? onSaveToFile;
  final Future<void> Function(String content)? onCopy;
  final bool isBottomSheet;

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
    final prefix =
        (widget.requestName != null && widget.requestName!.trim().isNotEmpty)
        ? '${widget.requestName!.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_')}_'
        : '';
    return _selectedFormat == ExportDocFormat.markdown
        ? '${prefix}api_doc.md'
        : '${prefix}curl_session.sh';
  }

  Future<void> _handleCopy() async {
    final sm = ScaffoldMessenger.of(context);
    try {
      if (widget.onCopy != null) {
        await widget.onCopy!(_currentContent);
      } else {
        await FlutterClipboard.copy(_currentContent);
      }
      sm.hideCurrentSnackBar();
      sm.showSnackBar(getSnackBar(kMsgCopiedToClipboard));
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

      final bytes = Uint8List.fromList(utf8.encode(_currentContent));
      final path = await promptSaveFile(
        suggestedName: fileName,
        content: bytes,
        acceptedTypeGroups: [
          XTypeGroup(label: _selectedFormat.label, extensions: [ext]),
        ],
      );

      if (path != null) {
        final sp = getShortPath(path);
        sm.hideCurrentSnackBar();
        sm.showSnackBar(getSnackBar("Saved to $sp", small: false));
      }
    } catch (e) {
      sm.hideCurrentSnackBar();
      sm.showSnackBar(getSnackBar("Failed to save: $e"));
    }
  }

  List<Widget> _buildActionButtons(BuildContext context) {
    return [
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
    ];
  }

  Widget _buildPreviewContent(ThemeData theme, dynamic codeTheme) {
    return Column(
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
              color: theme.colorScheme.surfaceContainerLow,
              border: Border.all(
                color: theme.colorScheme.surfaceContainerHighest,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final codeTheme = theme.brightness == Brightness.light
        ? kLightCodeTheme
        : kDarkCodeTheme;

    final isMedium = context.isMediumWindow;
    final isSmall = context.isSmallWindow;
    final mediaQuery = MediaQuery.of(context);

    if (widget.isBottomSheet) {
      final sheetHeight = (mediaQuery.size.height * 0.85).clamp(380.0, 720.0);

      return Container(
        width: double.infinity,
        height: sheetHeight,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.description_outlined,
                  color: theme.colorScheme.primary,
                ),
                kHSpacer10,
                Expanded(
                  child: Text(
                    "Export API Documentation",
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: "Close",
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            kVSpacer10,
            Expanded(child: _buildPreviewContent(theme, codeTheme)),
            kVSpacer10,
            Wrap(
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: _buildActionButtons(context),
            ),
          ],
        ),
      );
    }

    // Desktop / Large Window: 700x500 modal (or constrained by screen if smaller)
    final dialogWidth = isMedium || isSmall
        ? (mediaQuery.size.width - 32).clamp(280.0, 700.0)
        : 700.0;
    final dialogHeight = isMedium || isSmall
        ? (mediaQuery.size.height * 0.75).clamp(320.0, 500.0)
        : 500.0;

    return AlertDialog(
      icon: const Icon(Icons.description_outlined),
      iconColor: theme.colorScheme.primary,
      title: const Text("Export API Documentation"),
      titleTextStyle: theme.textTheme.titleLarge,
      actionsAlignment: MainAxisAlignment.end,
      actionsOverflowButtonSpacing: 8,
      content: SizedBox(
        width: dialogWidth,
        height: dialogHeight,
        child: _buildPreviewContent(theme, codeTheme),
      ),
      actions: _buildActionButtons(context),
    );
  }
}
