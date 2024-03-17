import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import '../tabs.dart';

class MQTTRequestPane extends StatefulWidget {
  const MQTTRequestPane({
    super.key,
    required this.selectedId,
    this.tabIndex,
    this.onTapTabBar,
    required this.children,
    this.showIndicators = const [false, false, false],
    required this.tabLabels,
  });

  final List<String> tabLabels;
  final String? selectedId;
  final int? tabIndex;
  final void Function(int)? onTapTabBar;
  final List<Widget> children;
  final List<bool> showIndicators;

  @override
  State<MQTTRequestPane> createState() => _MQTTRequestPaneState();
}

class _MQTTRequestPaneState extends State<MQTTRequestPane>
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
    if (widget.tabIndex != null) {
      _controller.index = widget.tabIndex!;
    }
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
                // FilledButton.tonalIcon(
                //   onPressed: widget.onPressedCodeButton,
                //   icon: Icon(
                //     widget.codePaneVisible
                //         ? Icons.code_off_rounded
                //         : Icons.code_rounded,
                //   ),
                //   label: SizedBox(
                //     width: 75,
                //     child: Text(
                //         widget.codePaneVisible ? "Hide Code" : "View Code"),
                //   ),
                // ),
              ],
            ),
          ),
        ),
        TabBar(
          key: Key(widget.selectedId!),
          controller: _controller,
          overlayColor: kColorTransparentState,
          onTap: widget.onTapTabBar,
          tabs: [
            TabLabel(
              text: widget.tabLabels[0],
              showIndicator: widget.showIndicators[0],
            ),
            TabLabel(
              text: widget.tabLabels[1],
              showIndicator: widget.showIndicators[1],
            ),
            TabLabel(
              text: widget.tabLabels[2],
              showIndicator: widget.showIndicators[2],
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
