import 'package:apidash/widgets/websocket_response_messages.dart';
import 'package:apidash/widgets/websocket_response_view.dart';
import 'package:apidash_design_system/tokens/colors.dart';
import 'package:apidash_design_system/tokens/measurements.dart';
import 'package:apidash_design_system/tokens/typography.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';

class HistoryWebsocketMessageResponsePane extends ConsumerWidget {
  const HistoryWebsocketMessageResponsePane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedHistoryIdStateProvider);
    final selectedHistoryRequest =
        ref.watch(selectedHistoryRequestModelProvider);

    if (selectedId != null) {
      final requestModel =
          getRequestModelFromHistoryModel(selectedHistoryRequest!);

      return Column(
        children: [
          Padding(
            padding: kPv8,
            child: SizedBox(
              height: kHeaderHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  kHSpacer10,
                  Expanded(
                    child: Text(
                      kLabelDisconnected,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontFamily: kCodeStyle.fontFamily,
                          color: kColorStatusCode400),
                    ),
                  ),
                  kHSpacer10,
                ],
              ),
            ),
          ),
          Expanded(
            child: WebsocketResponseView(
              selectedId: selectedId,
              children: [
                WebsocketResponseMessage(
                  selectedRequestModel: requestModel,
                  isPartOfHistory: true,
                ),
              ],
            ),
          ),
        ],
      );
    }
    return const Text("No Request Selected");
  }
}
