import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';

class SaveInDownloadsButton extends StatelessWidget {
  const SaveInDownloadsButton({
    super.key,
    this.content,
    this.mimeType,
    this.ext,
    this.name,
    this.showLabel = true,
  });

  final Uint8List? content;
  final String? mimeType;
  final String? ext;
  final String? name;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    var sm = ScaffoldMessenger.of(context);
    final onPressed = (content != null)
        ? () => saveToDownloads(
              sm,
              content: content,
              mimeType: mimeType,
              ext: ext,
              name: name,
            )
        : null;

    return showLabel
        ? ADTextButton(
            icon: Icons.download,
            iconSize: kButtonIconSizeLarge,
            label: kLabelDownload,
            onPressed: onPressed,
          )
        : ADIconButton(
            icon: Icons.download,
            iconSize: kButtonIconSizeLarge,
            onPressed: onPressed,
            tooltip: kLabelDownload,
            color: Theme.of(context).colorScheme.primary,
            visualDensity: VisualDensity.compact,
          );
  }
}
