import 'package:apidash_design_system/ui/design_system_provider.dart';
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
  });

  final bool isStreaming;
  final bool isWorking;
  final void Function() onTap;
  final void Function()? onCancel;

  @override
  Widget build(BuildContext context) {
    final ds = DesignSystemProvider.of(context);
    return ADFilledButton(
      onPressed: (isWorking || isStreaming) ? onCancel : onTap,
      isTonal: (isWorking || isStreaming),
      items: (isWorking || isStreaming)
          ? [
              kHSpacer8(ds.scaleFactor),
              Text(
                isStreaming ? kLabelStop : kLabelCancel,
                style: kTextStyleButton(ds.scaleFactor),
              ),
              kHSpacer6(ds.scaleFactor),
            ]
          : [
              Text(
                kLabelSend,
                style: kTextStyleButton(ds.scaleFactor),
              ),
              kHSpacer10(ds.scaleFactor),
              const Icon(
                size: 16,
                Icons.send,
              ),
            ],
    );
  }
}
