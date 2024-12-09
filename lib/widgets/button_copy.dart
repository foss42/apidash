import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:apidash/consts.dart';
import "snackbars.dart";

class CopyButton extends StatelessWidget {
  const CopyButton({
    super.key,
    required this.toCopy,
    this.showLabel = true,
  });

  final String toCopy;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    var sm = ScaffoldMessenger.of(context);
    const icon = Icon(
      Icons.content_copy,
      size: 18,
    );
    onPressed() async {
      await Clipboard.setData(ClipboardData(text: toCopy));
      sm.hideCurrentSnackBar();
      sm.showSnackBar(getSnackBar("Copied"));
    }

    return showLabel
        ? TextButton.icon(
            onPressed: onPressed,
            icon: icon,
            label: const Text(kLabelCopy),
          )
        : ADIconButton(
            icon: Icons.content_copy,
            iconSize: 18,
            tooltip: kLabelCopy,
            color: Theme.of(context).colorScheme.primary,
            visualDensity: VisualDensity.compact,
            onPressed: onPressed,
          );
  }
}
