import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'tabs.dart';

class RequestPane extends StatefulWidget {
  const RequestPane({
    super.key,
    required this.activeId,
    required this.codePaneVisible,
    this.tabIndex,
    this.onPressedCodeButton,
    this.onTapTabBar,
    required this.children,
    this.showIndicators = const [false, false, false],
  });

  final String? activeId;
  final bool codePaneVisible;
  final int? tabIndex;
  final void Function()? onPressedCodeButton;
  final void Function(int)? onTapTabBar;
  final List<Widget> children;
  final List<bool> showIndicators;

  @override
  State<RequestPane> createState() => _RequestPaneState();
}

class _RequestPaneState extends State<RequestPane>
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: kPh20v10,
          child: SizedBox(
            height: kHeaderHeight,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
                Text(
                  "Request",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                FilledButton.tonalIcon(
                  onPressed: widget.onPressedCodeButton,
                  icon: Icon(
                    widget.codePaneVisible
                        ? Icons.code_off_rounded
                        : Icons.code_rounded,
                  ),
                  label: Text(
                    widget.codePaneVisible ? "Hide Code" : "View Code",
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        TabBar(
          key: Key(widget.activeId!),
          controller: _controller,
          overlayColor: kColorTransparentState,
          onTap: widget.onTapTabBar,
          tabs: [
            TabLabel(
              text: 'URL Params',
              showIndicator: widget.showIndicators[0],
            ),
            TabLabel(
              text: 'Headers',
              showIndicator: widget.showIndicators[1],
            ),
            TabLabel(
              text: 'Body',
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
