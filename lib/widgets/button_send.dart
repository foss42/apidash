import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class SendButton extends StatelessWidget {
  const SendButton({
    super.key,
    required this.isWorking,
    required this.onTap,
  });

  final bool isWorking;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isWorking ? null : onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: isWorking
            ? const [
                Text(
                  kLabelSending,
                  style: kTextStyleButton,
                ),
              ]
            : const [
                Text(
                  kLabelSend,
                  style: kTextStyleButton,
                ),
                kHSpacer10,
                Icon(
                  size: 16,
                  Icons.send,
                ),
              ],
      ),
    );
  }
}
