import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import 'request_headers.dart';
import 'request_params.dart';
import 'request_body.dart';

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
      animationDuration: kTabAnimationDuration,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(activeIdStateProvider);
    _controller.index = ref
        .read(collectionStateNotifierProvider.notifier)
        .getRequestModel(activeId!)
        .requestTabIndex;
    return Column(
      children: [
        Padding(
          padding: kPh20v10,
          child: SizedBox(
            height: kHeaderHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Request",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                FilledButton.tonalIcon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.code_rounded,
                  ),
                  label: const Text("Generate Code"),
                ),
              ],
            ),
          ),
        ),
        TabBar(
          key: Key(activeId),
          controller: _controller,
          overlayColor: kColorTransparent,
          onTap: (index) {
            ref
                .read(collectionStateNotifierProvider.notifier)
                .update(activeId, requestTabIndex: _controller.index);
          },
          tabs: const [
            SizedBox(
              height: kTabHeight,
              child: Center(
                child: Text(
                  'URL Params',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: kTextStyleButton,
                ),
              ),
            ),
            SizedBox(
              height: kTabHeight,
              child: Center(
                child: Text(
                  'Headers',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  style: kTextStyleButton,
                ),
              ),
            ),
            SizedBox(
              height: kTabHeight,
              child: Center(
                child: Text(
                  'Body',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  style: kTextStyleButton,
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
