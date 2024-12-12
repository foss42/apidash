import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class ClearResponseButton extends StatelessWidget {
  const ClearResponseButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ADIconButton(
      icon: Icons.delete,
      onPressed: onPressed,
      tooltip: kTooltipClearResponse,
    );
  }
}
