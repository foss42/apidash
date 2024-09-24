import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';

class SendButton extends ConsumerWidget {
  const SendButton({
    super.key,
    required this.isWorking,
    required this.onTap,
  });

  final bool isWorking;
  final void Function() onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    double scaleFactor = settings.scaleFactor;

    return FilledButton(
      onPressed: isWorking ? null : onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: isWorking
            ? [
          Text(
            kLabelSending,
            style: kTextStyleButton.copyWith(
              fontSize: 16 * scaleFactor, // Scale text size
            ),
          ),
        ]
            : [
          Text(
            kLabelSend,
            style: kTextStyleButton.copyWith(
              fontSize: 16 * scaleFactor, // Scale text size
            ),
          ),
          SizedBox(width: 8 * scaleFactor), // Adjusted spacing
          Icon(
            Icons.send,
            size: 20 * scaleFactor, // Adjusted icon size
          ),
        ],
      ),
    );
  }
}
