import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../styles.dart';
import 'tables.dart';
import 'body_editor.dart';

class EditRequestPane extends ConsumerStatefulWidget {
  const EditRequestPane({super.key});

  @override
  ConsumerState<EditRequestPane> createState() => _EditRequestPaneState();
}

class _EditRequestPaneState extends ConsumerState<EditRequestPane>
    with TickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: 3,
      animationDuration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(activeItemIdStateProvider);
    _controller.index = ref
        .read(collectionStateNotifierProvider.notifier)
        .getRequestModel(activeId!)
        .requestTabIndex;
    return Column(
      children: [
        TabBar(
          key: Key(activeId),
          controller: _controller,
          overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
          onTap: (index) {
            ref
                .read(collectionStateNotifierProvider.notifier)
                .update(activeId, requestTabIndex: _controller.index);
          },
          tabs: const [
            SizedBox(
              height: 45,
              child: Center(
                child: Text(
                  'URL Params',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: textStyleButton,
                ),
              ),
            ),
            SizedBox(
              height: 45,
              child: Center(
                child: Text(
                  'Headers',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  style: textStyleButton,
                ),
              ),
            ),
            SizedBox(
              height: 45,
              child: Center(
                child: Text(
                  'Body',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  style: textStyleButton,
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              EditRequestURLParams(),
              EditRequestHeaders(),
              EditRequestBody(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
