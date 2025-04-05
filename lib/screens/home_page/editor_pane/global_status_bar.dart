import 'package:flutter/material.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';

class GlobalStatusBar extends ConsumerWidget {
  const GlobalStatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusMessage = ref.watch(statusMessageProvider);

    // Get color based on message type
    final color = statusMessage.type == StatusMessageType.info
        ? kColorSchemeSeed
        : statusMessage.type == StatusMessageType.warning
            ? kColorHttpMethodPut
            : statusMessage.type == StatusMessageType.error
                ? kColorDarkDanger
                : kColorBlack;

    // Get icon based on message type
    final icon = statusMessage.type == StatusMessageType.error
        ? Icons.error_outline
        : statusMessage.type == StatusMessageType.warning
            ? Icons.warning_amber_outlined
            : statusMessage.type == StatusMessageType.info
                ? Icons.info_outline
                : null;

    return Container(
      padding: kPh12,
      width: double.infinity,
      height: 40,
      // Use background color only for status messages (info/warning/error)
      color: icon != null ? color.withOpacity(kForegroundOpacity) : kColorWhite,
      child: Row(
        children: [
          // Only display icons for info, warning, and error states
          if (icon != null) ...[
            Icon(icon, size: kButtonIconSizeSmall, color: color),
            kHSpacer8,
          ],
          Expanded(
            child: Text(
              statusMessage.message,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              // Prevent text overflow issues
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
