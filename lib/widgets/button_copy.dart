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
    return Tooltip(
      message: showLabel ? '' : kLabelCopy,
      child: SizedBox(
        width: showLabel ? null : kTextButtonMinWidth,
        child: TextButton(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: toCopy));
            sm.hideCurrentSnackBar();
            sm.showSnackBar(getSnackBar("Copied"));
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.content_copy,
                size: 20,
              ),
              if (showLabel) const Text(kLabelCopy)
            ],
          ),
        ),
      ),
    );
  }
}
