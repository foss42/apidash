import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';
import "snackbars.dart";

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
        ? () async {
            var message = "";
            var path = await getFileDownloadpath(
              name,
              ext ?? getFileExtension(mimeType),
            );
            if (path != null) {
              try {
                await saveFile(path, content!);
                var sp = getShortPath(path);
                message = 'Saved to $sp';
              } catch (e) {
                message = "An error occurred while saving file.";
              }
            } else {
              message = "Unable to determine the download path.";
            }
            sm.hideCurrentSnackBar();
            sm.showSnackBar(getSnackBar(message, small: false));
          }
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
