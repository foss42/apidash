import 'package:apidash/consts.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';
import 'widgets.dart'
    show
        DropdownButtonCodegenLanguage,
        CopyButton,
        SaveInDownloadsButton,
        CodeGenPreviewer;

class ViewCodePane extends StatefulWidget {
  const ViewCodePane({
    super.key,
    required this.code,
    required this.codegenLanguage,
    required this.onChangedCodegenLanguage,
  });

  final String code;
  final CodegenLanguage codegenLanguage;
  final Function(CodegenLanguage?) onChangedCodegenLanguage;

  @override
  State<ViewCodePane> createState() => _ViewCodePaneState();
}

class _ViewCodePaneState extends State<ViewCodePane> {
  @override
  Widget build(BuildContext context) {
    var codeTheme = Theme.of(context).brightness == Brightness.light
        ? kLightCodeTheme
        : kDarkCodeTheme;
    final textContainerdecoration = BoxDecoration(
      color: Color.alphaBlend(
          (Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.primaryContainer)
              .withOpacity(kForegroundOpacity),
          Theme.of(context).colorScheme.surface),
      border: Border.all(color: Theme.of(context).colorScheme.surfaceVariant),
      borderRadius: kBorderRadius8,
    );

    return Padding(
      padding: kP10,
      child: Column(
        children: [
          SizedBox(
            height: kHeaderHeight,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Code",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                DropdownButtonCodegenLanguage(
                  codegenLanguage: widget.codegenLanguage,
                  onChanged: widget.onChangedCodegenLanguage,
                ),
                CopyButton(toCopy: widget.code),
                SaveInDownloadsButton(
                  content: stringToBytes(widget.code),
                  mimeType: "application/vnd.dart",
                )
              ],
            ),
          ),
          kVSpacer10,
          Expanded(
            child: Container(
              width: double.maxFinite,
              padding: kP8,
              decoration: textContainerdecoration,
              child: CodeGenPreviewer(
                code: widget.code,
                theme: codeTheme,
                language: 'dart',
                textStyle: kCodeStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
