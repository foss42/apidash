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
    return IconButton(
      tooltip: kTooltipClearResponse,
      onPressed: onPressed,
      icon: const Icon(
        Icons.delete,
        size: 16,
      ),
    );
  }
}
