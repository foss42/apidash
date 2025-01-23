import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class ConnectionButton extends StatelessWidget {
  const ConnectionButton({
    super.key,
    required this.isWorking,
    required this.onTap,
    this.onDisconnect,
  });

  final bool isWorking;
  final void Function() onTap;
  final void Function()? onDisconnect;

  @override
  Widget build(BuildContext context) {
    return ADFilledButton(
      onPressed: isWorking ? onDisconnect : onTap,
      isTonal: isWorking ? true : false,
      items: isWorking
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
                KLabelConnect,
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
