import 'package:flutter/material.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';

import 'package:apidash/screens/home_page/editor_pane/details_card/response_pane_websocket.dart';

class HistoryResponsePane extends ConsumerWidget {
  const HistoryResponsePane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedHistoryIdStateProvider);
    final selectedHistoryRequest =
        ref.watch(selectedHistoryRequestModelProvider);

    final historyHttpResponseModel = selectedHistoryRequest?.httpResponseModel;

    if (selectedId != null) {
      final requestModel =
          getRequestModelFromHistoryModel(selectedHistoryRequest!);

      final statusCode = historyHttpResponseModel?.statusCode;

      if (requestModel.apiType == APIType.websocket) {
        return Column(
          children: [
            ResponsePaneHeader(
              responseStatus: statusCode,
              message: kResponseCodeReasons[statusCode],
              time: historyHttpResponseModel?.time,
            ),
            Expanded(
              child: WebSocketMessageList(
                messages: requestModel.webSocketRequestModel?.messages,
              ),
            ),
          ],
        );
      }

      return Column(
        children: [
          ResponsePaneHeader(
            responseStatus: statusCode,
            message: kResponseCodeReasons[statusCode],
            time: historyHttpResponseModel?.time,
          ),
          Expanded(
            child: ResponseTabView(
              selectedId: selectedId,
              children: [
                ResponseBody(
                  selectedRequestModel: requestModel,
                  isPartOfHistory: true,
                ),
                ResponseHeaders(
                  responseHeaders: historyHttpResponseModel?.headers ?? {},
                  requestHeaders:
                      historyHttpResponseModel?.requestHeaders ?? {},
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
