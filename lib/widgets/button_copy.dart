import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:apidash/consts.dart';

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
    String msg;
    onPressed() async {
      try {
        await Clipboard.setData(ClipboardData(text: toCopy));
        msg = "Copied";
      } catch (e) {
        msg = "An error occurred";
      }
      sm.hideCurrentSnackBar();
      sm.showSnackBar(getSnackBar(msg));
    }

    return showLabel
        ? ADTextButton(
            icon: Icons.content_copy,
            iconSize: kButtonIconSizeLarge,
            label: kLabelCopy,
            onPressed: onPressed,
          )
        : ADIconButton(
            icon: Icons.content_copy,
            iconSize: kButtonIconSizeLarge,
            tooltip: kLabelCopy,
            color: Theme.of(context).colorScheme.primary,
            visualDensity: VisualDensity.compact,
            onPressed: onPressed,
          );
  }
}
