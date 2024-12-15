import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class SendButton extends StatelessWidget {
  const SendButton({
    super.key,
    required this.isWorking,
    required this.onTap,
    this.onCancel,
  });

  final bool isWorking;
  final void Function() onTap;
  final void Function()? onCancel;

  @override
  Widget build(BuildContext context) {
    return ADFilledButton(
      onPressed: isWorking ? onCancel : onTap,
      isTonal: isWorking ? true : false,
      items: isWorking
          ? const [
              kHSpacer8,
              Text(
                kLabelCancel,
                style: kTextStyleButton,
              ),
              kHSpacer6,
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
    );
  }
}
