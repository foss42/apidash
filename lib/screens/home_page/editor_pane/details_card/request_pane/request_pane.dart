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
    var index = ref
        .read(collectionStateNotifierProvider.notifier)
        .getRequestModel(activeId!)
        .requestTabIndex;

    return RequestPane(
      activeId: activeId,
      codePaneVisible: codePaneVisible,
      tabIndex: index,
      onPressedCodeButton: () {
        ref
            .read(codePaneVisibleStateProvider.notifier)
            .update((state) => !codePaneVisible);
      },
      onTapTabBar: (index) {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(activeId, requestTabIndex: index);
      },
      children: const [
        EditRequestURLParams(),
        EditRequestHeaders(),
        EditRequestBody(),
      ],
    );
  }
}
