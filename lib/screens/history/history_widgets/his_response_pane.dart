import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';

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
      return Column(
        children: [
          ResponsePaneHeader(
            responseStatus: historyHttpResponseModel?.statusCode,
            message: kResponseCodeReasons[historyHttpResponseModel?.statusCode],
            time: historyHttpResponseModel?.time,
          ),
          Expanded(
            child: ResponseTabView(
              selectedId: selectedId,
              children: [
                ResponseBody(
                  selectedRequestModel: requestModel,
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
