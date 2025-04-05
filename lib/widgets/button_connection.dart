import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class ConnectionButton extends StatelessWidget {
  const ConnectionButton({
    super.key,
    required this.isConnected,
    required this.onTap,
    this.onDisconnect,
  });

  final bool isConnected;
  final void Function() onTap;
  final void Function()? onDisconnect;

  @override
  Widget build(BuildContext context) {
    return ADFilledButton(
      onPressed: isConnected ? onDisconnect : onTap,
      isTonal: isConnected ? true : false,
      items: isConnected
          ? const [
              kHSpacer8,
              Text(
                kLabelDisconnect,
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
