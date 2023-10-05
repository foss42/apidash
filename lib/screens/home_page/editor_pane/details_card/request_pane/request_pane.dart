import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'request_headers.dart';
import 'request_params.dart';
import 'request_body.dart';

class EditRequestPane extends ConsumerStatefulWidget {
  const EditRequestPane({super.key});

  @override
  ConsumerState<EditRequestPane> createState() => _EditRequestPaneState();
}

class _EditRequestPaneState extends ConsumerState<EditRequestPane> {
  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(activeIdStateProvider);
    final codePaneVisible = ref.watch(codePaneVisibleStateProvider);
    final tabIndex = ref.watch(
        activeRequestModelProvider.select((value) => value?.requestTabIndex));

    final headerLength = ref.watch(
        activeRequestModelProvider.select((value) => value?.headersMap.length));
    final paramLength = ref.watch(
        activeRequestModelProvider.select((value) => value?.paramsMap.length));
    final bodyLength = ref.watch(activeRequestModelProvider
        .select((value) => value?.requestBody?.length));

    return RequestPane(
      activeId: activeId,
      codePaneVisible: codePaneVisible,
      tabIndex: tabIndex,
      onPressedCodeButton: () {
        ref
            .read(codePaneVisibleStateProvider.notifier)
            .update((state) => !codePaneVisible);
      },
      onTapTabBar: (index) {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(activeId!, requestTabIndex: index);
      },
      showIndicators: [
        paramLength != null && paramLength > 0,
        headerLength != null && headerLength > 0,
        bodyLength != null && bodyLength > 0,
      ],
      children: const [
        EditRequestURLParams(),
        EditRequestHeaders(),
        EditRequestBody(),
      ],
    );
  }
}
