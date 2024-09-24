import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:apidash/consts.dart';
import "snackbars.dart";

class CopyButton extends StatelessWidget {
  const CopyButton({
    super.key,
    required this.toCopy,
    this.showLabel = true,
     this.scaleFactor =1,
  });

  final String toCopy;
  final bool showLabel;
  final double scaleFactor;

  @override
  Widget build(BuildContext context) {
    var sm = ScaffoldMessenger.of(context);
    final iconSize = 18 * scaleFactor;
    final textStyle = TextStyle(
      fontSize: 14 * scaleFactor,
    );
    final icon = Icon(
      Icons.content_copy,
      size: iconSize,
    );
    const label = kLabelCopy;

    onPressed() async {
      await Clipboard.setData(ClipboardData(text: toCopy));
      sm.hideCurrentSnackBar();
      sm.showSnackBar(getSnackBar("Copied"));
    }

    return showLabel
        ? TextButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(
        label,
        style: textStyle,
      ),
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
