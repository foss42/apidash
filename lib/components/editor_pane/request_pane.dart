import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tab_container/tab_container.dart';
import '../../providers/providers.dart';
import '../styles.dart';
import 'tables.dart';
import 'body_editor.dart';

class EditRequestPane extends ConsumerStatefulWidget {
  const EditRequestPane({super.key});

  @override
  ConsumerState<EditRequestPane> createState() => _EditRequestPaneState();
}

class _EditRequestPaneState extends ConsumerState<EditRequestPane> {
  late final TabContainerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabContainerController(length: 3);
  }

  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(activeItemIdStateProvider);
    _controller.jumpTo(ref
        .read(collectionStateNotifierProvider.notifier)
        .getRequestModel(activeId!)
        .requestTabIndex);
    return TabContainer(
      key: Key(activeId),
      controller: _controller,
      color: colorGrey100,
      onEnd: () {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(activeId, requestTabIndex: _controller.index);
      },
      isStringTabs: false,
      tabs: const [
        Text(
          'URL Params',
          textAlign: TextAlign.center,
          overflow: TextOverflow.fade,
          style: textStyleButton,
        ),
        Text(
          'Headers',
          textAlign: TextAlign.center,
          overflow: TextOverflow.fade,
          style: textStyleButton,
        ),
        Text(
          'Body',
          textAlign: TextAlign.center,
          overflow: TextOverflow.fade,
          style: textStyleButton,
        )
      ],
      children: const [
        EditRequestURLParams(),
        EditRequestHeaders(),
        EditRequestBody(),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
