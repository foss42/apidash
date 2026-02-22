import 'package:apidash/consts.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'request_params.dart';
import 'request_headers.dart';

class EditWebSocketRequestPane extends ConsumerStatefulWidget {
  const EditWebSocketRequestPane({super.key});

  @override
  ConsumerState<EditWebSocketRequestPane> createState() =>
      _EditWebSocketRequestPaneState();
}

class _EditWebSocketRequestPaneState
    extends ConsumerState<EditWebSocketRequestPane> {
  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final codePaneVisible = ref.watch(codePaneVisibleStateProvider);
    final tabIndex = ref.watch(
        selectedRequestModelProvider.select((value) => value?.requestTabIndex));

    final contextParams = [
      kLabelURLParams,
      kLabelHeaders,
    ];

    if (selectedId == null) {
      return const SizedBox.shrink();
    }

    return RequestPane(
      selectedId: selectedId,
      codePaneVisible: codePaneVisible,
      tabIndex: tabIndex,
      onPressedCodeButton: () {
        ref.read(codePaneVisibleStateProvider.notifier).state =
            !codePaneVisible;
      },
      onTapTabBar: (index) {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(requestTabIndex: index);
      },
      tabLabels: contextParams,
      children: [
        EditWebSocketParams(),
        EditWebSocketHeaders(),
      ],
    );
  }
}

class EditWebSocketParams extends ConsumerWidget {
  const EditWebSocketParams({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const EditRequestURLParams();
  }
}

class EditWebSocketHeaders extends ConsumerWidget {
  const EditWebSocketHeaders({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const EditRequestHeaders();
  }
}
