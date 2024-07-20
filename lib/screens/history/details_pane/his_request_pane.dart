import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';

class HistoryRequestPane extends ConsumerWidget {
  const HistoryRequestPane({
    super.key,
    this.isCompact = false,
  });

  final bool isCompact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedHistoryIdStateProvider);
    final codePaneVisible = ref.watch(historyCodePaneVisibleStateProvider);

    final headersMap = ref.watch(selectedHistoryRequestModelProvider
            .select((value) => value?.httpRequestModel.headersMap)) ??
        {};
    final headerLength = headersMap.length;

    final paramsMap = ref.watch(selectedHistoryRequestModelProvider
            .select((value) => value?.httpRequestModel.paramsMap)) ??
        {};
    final paramLength = paramsMap.length;

    final hasBody = ref.watch(selectedHistoryRequestModelProvider
            .select((value) => value?.httpRequestModel.hasBody)) ??
        false;

    return RequestPane(
      selectedId: selectedId,
      codePaneVisible: codePaneVisible,
      onPressedCodeButton: () {
        ref.read(historyCodePaneVisibleStateProvider.notifier).state =
            !codePaneVisible;
      },
      showViewCodeButton: !isCompact,
      showIndicators: [
        paramLength > 0,
        headerLength > 0,
        hasBody,
      ],
      children: [
        RequestDataTable(
          rows: paramsMap,
          keyName: kNameURLParam,
        ),
        RequestDataTable(
          rows: headersMap,
          keyName: kNameHeader,
        ),
        const SizedBox(),
      ],
    );
  }
}
