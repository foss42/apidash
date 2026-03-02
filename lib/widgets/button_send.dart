import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class SendButton extends StatelessWidget {
  const SendButton({
    super.key,
    required this.isStreaming,
    required this.isWorking,
    required this.onTap,
    this.onCancel,
    this.text,
    this.icon,
  });

  final bool isStreaming;
  final bool isWorking;
  final void Function() onTap;
  final void Function()? onCancel;
  final String? text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ADFilledButton(
      onPressed: (isWorking || isStreaming) ? onCancel : onTap,
      isTonal: (isWorking || isStreaming),
      items: (isWorking || isStreaming)
          ? [
              kHSpacer8,
              Text(
                isStreaming ? kLabelStop : kLabelCancel,
                style: kTextStyleButton,
              ),
              kHSpacer6,
            ]
          : [
              Text(
                text ?? kLabelSend,
                style: kTextStyleButton,
              ),
              kHSpacer10,
              Icon(
                size: 16,
                icon ?? Icons.send,
              ),
            ],
    );
  }
}
