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

class ConnectButton extends StatelessWidget {
  const ConnectButton({
    super.key,
    required this.isConnecting,
    required this.isConnected,
    required this.onTap,
    this.onCancel,
    this.onDisconnect,
  });

  final bool? isConnecting;
  final bool? isConnected;
  final void Function() onTap;
  final void Function()? onCancel;
  final void Function()? onDisconnect;

  @override
  Widget build(BuildContext context) {
    return ADFilledButton(
      onPressed: ((isConnected != null && isConnected == true) ||
              (isConnecting != null && isConnected == true))
          ? onDisconnect
          : onTap,
      items: (isConnected != false || isConnecting != false)
          ? [
              kHSpacer8,
              Text(
                isConnecting != null && isConnecting == true
                    ? kLabelCancel
                    : isConnected != null && isConnected == true
                        ? kLabelDisconnect
                        : kLabelConnect,
                style: kTextStyleButton,
              ),
              kHSpacer6,
            ]
          : const [
              Text(
                kLabelConnect,
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
