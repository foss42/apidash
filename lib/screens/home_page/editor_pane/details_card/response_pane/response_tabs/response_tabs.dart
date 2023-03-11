import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import 'response_headers.dart';
import 'response_body.dart';

class ResponseTabs extends ConsumerStatefulWidget {
  const ResponseTabs({super.key});

  @override
  ConsumerState<ResponseTabs> createState() => _ResponseTabsState();
}

class _ResponseTabsState extends ConsumerState<ResponseTabs>
    with TickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: 2,
      animationDuration: tabAnimationDuration,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(activeIdStateProvider);
    return Column(
      children: [
        TabBar(
          key: Key(activeId!),
          controller: _controller,
          overlayColor: colorTransparent,
          onTap: (index) {},
          tabs: const [
            SizedBox(
              height: 45,
              child: Center(
                child: Text(
                  'Body',
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
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              ResponseBody(),
              ResponseHeaders(),
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
