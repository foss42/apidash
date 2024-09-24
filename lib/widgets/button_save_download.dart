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
     this.scaleFactor=1,
  });

  final Uint8List? content;
  final String? mimeType;
  final String? ext;
  final String? name;
  final bool showLabel;
  final double scaleFactor;

  @override
  Widget build(BuildContext context) {
    var sm = ScaffoldMessenger.of(context);
    final iconSize = 18 * scaleFactor;
    final icon = Icon(
      Icons.download,
      size: iconSize,
    );
    final label = Text(
      kLabelDownload,
      style: TextStyle(fontSize: 14 * scaleFactor),
    );

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
      label: label,
      style: TextButton.styleFrom(
        minimumSize: Size(64 * scaleFactor, 36 * scaleFactor),
        padding: EdgeInsets.symmetric(
          horizontal: 8.0 * scaleFactor,
          vertical: 4.0 * scaleFactor,
        ),
      ),
    )
        : IconButton(
      tooltip: kLabelDownload,
      color: Theme.of(context).colorScheme.primary,
      visualDensity: VisualDensity.compact,
      onPressed: onPressed,
      icon: icon,
      iconSize: iconSize,
    );
  }
}
