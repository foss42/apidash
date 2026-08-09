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
    this.sendLabel = kLabelSend,
    this.activeLabel,
  });

  final bool isStreaming;
  final bool isWorking;
  final void Function() onTap;
  final void Function()? onCancel;
  final String sendLabel;
  final String? activeLabel;

  @override
  Widget build(BuildContext context) {
    return ADFilledButton(
      onPressed: (isWorking || isStreaming) ? onCancel : onTap,
      isTonal: (isWorking || isStreaming),
      items: (isWorking || isStreaming)
          ? [
              kHSpacer8,
              Text(
                activeLabel ?? (isStreaming ? kLabelStop : kLabelCancel),
                style: kTextStyleButton,
              ),
              kHSpacer6,
            ]
          : [
              Text(
                sendLabel,
                style: kTextStyleButton,
              ),
              if (sendLabel == kLabelSend) ...[
                kHSpacer10,
                const Icon(
                  size: 16,
                  Icons.send,
                ),
              ],
            ],
    );
  }
}
