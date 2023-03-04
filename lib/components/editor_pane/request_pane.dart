import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tab_container/tab_container.dart';
import '../../providers/providers.dart';
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
    return Padding(
      padding: const EdgeInsets.all(5),
      child: TabContainer(
        key: Key(activeId),
        controller: _controller,
        color: Colors.grey.shade100,
        onEnd: () {
          ref
              .read(collectionStateNotifierProvider.notifier)
              .update(activeId, requestTabIndex: _controller.index);
        },
        tabs: const [
          'URL Params',
          'Headers',
          'Body',
        ],
        children: const [
          EditRequestURLParams(),
          EditRequestHeaders(),
          EditRequestBody(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
