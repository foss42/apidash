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
    const icon = Icon(
      Icons.download,
      size: 18,
    );
    const label = kLabelDownload;
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
        ? TextButton.icon(
            onPressed: onPressed,
            icon: icon,
            label: const Text(label),
          )
        : IconButton(
            tooltip: label,
            color: Theme.of(context).colorScheme.primary,
            visualDensity: VisualDensity.compact,
            onPressed: onPressed,
            icon: icon,
          );
  }
}
