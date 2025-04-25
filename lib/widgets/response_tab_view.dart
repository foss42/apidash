import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'tab_label.dart';

class ResponseTabView extends StatefulWidget {
  const ResponseTabView({
    super.key,
    this.selectedId,
    required this.children,
  });

  final String? selectedId;
  final List<Widget> children;
  @override
  State<ResponseTabView> createState() => _ResponseTabViewState();
}

class _ResponseTabViewState extends State<ResponseTabView>
    with TickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: 2,
      animationDuration: kTabAnimationDuration,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          key: Key(widget.selectedId!),
          controller: _controller,
          labelPadding: kPh2,
          overlayColor: kColorTransparentState,
          onTap: (index) {},
          tabs: const [
            TabLabel(
              text: kLabelResponseBody,
            ),
            TabLabel(
              text: kLabelHeaders,
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            children: widget.children,
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
