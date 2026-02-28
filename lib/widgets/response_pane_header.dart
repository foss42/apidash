import 'package:apidash_design_system/ui/design_system_provider.dart';
import 'package:flutter/material.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';
import 'button_clear_response.dart';

class ResponsePaneHeader extends StatelessWidget {
  const ResponsePaneHeader({
    super.key,
    this.responseStatus,
    this.message,
    this.time,
    this.onClearResponse,
  });

  final int? responseStatus;
  final String? message;
  final Duration? time;
  final VoidCallback? onClearResponse;

  @override
  Widget build(BuildContext context) {
    final ds = DesignSystemProvider.of(context);
    final bool showClearButton = onClearResponse != null;
    return Padding(
      padding: kPv8,
      child: SizedBox(
        height: kHeaderHeight*ds.scaleFactor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            kHSpacer10(ds.scaleFactor),
            Expanded(
              child: Text(
                "$responseStatus: ${message ?? '-'}",
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: kCodeStyle.fontFamily,
                      color: getResponseStatusCodeColor(
                        responseStatus,
                        brightness: Theme.of(context).brightness,
                      ),
                    ),
              ),
            ),
            kHSpacer10(ds.scaleFactor),
            Text(
              humanizeDuration(time),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: kCodeStyle.fontFamily,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
            kHSpacer10(ds.scaleFactor),
            showClearButton
                ? ClearResponseButton(
                    onPressed: onClearResponse,
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
