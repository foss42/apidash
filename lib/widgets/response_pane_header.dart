import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/widgets/ai_ui_desginer_widgets.dart';
import 'package:flutter/material.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'button_clear_response.dart';

class ResponsePaneHeader extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final bool showClearButton = onClearResponse != null;
    return Padding(
      padding: kPv8,
      child: SizedBox(
        height: kHeaderHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            kHSpacer10,
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
            FilledButton.tonalIcon(
              style: FilledButton.styleFrom(
                padding: kPh12,
                minimumSize: const Size(44, 44),
              ),
              onPressed: () {
                final model = ref.watch(selectedRequestModelProvider
                    .select((value) => value?.httpResponseModel));
                if (model == null) return;
                final body = (model.sseOutput?.isNotEmpty ?? false)
                    ? model.sseOutput?.join("\n")
                    : model.formattedBody ?? model.body;
                showCustomDialog(context, body ?? "");
              },
              icon: Icon(
                Icons.generating_tokens,
              ),
              label: const SizedBox(
                child: Text(
                  kLabelGenerateUI,
                ),
              ),
            ),
            kHSpacer10,
            Text(
              humanizeDuration(time),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: kCodeStyle.fontFamily,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
            kHSpacer10,
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
