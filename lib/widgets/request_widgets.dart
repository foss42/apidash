import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'tabs.dart';
import 'package:apidash/extensions/extensions.dart' show MediaQueryExtension;

class RequestPane extends StatefulWidget {
  const RequestPane({
    super.key,
    required this.selectedId,
    required this.codePaneVisible,
    this.tabIndex,
    this.onPressedCodeButton,
    this.onTapTabBar,
    required this.children,
    this.showIndicators = const [false, false, false],
  });

  final String? selectedId;
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
      children: [
        context.isMobile
            ? const SizedBox.shrink()
            : Padding(
                padding: kP8,
                child: SizedBox(
                  height: kHeaderHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FilledButton.tonalIcon(
                        onPressed: widget.onPressedCodeButton,
                        icon: Icon(
                          widget.codePaneVisible
                              ? Icons.code_off_rounded
                              : Icons.code_rounded,
                        ),
                        label: SizedBox(
                          width: 75,
                          child: Text(
                            widget.codePaneVisible
                                ? kLabelHideCode
                                : kLabelViewCode,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        TabBar(
          key: Key(widget.selectedId!),
          controller: _controller,
          overlayColor: kColorTransparentState,
          labelPadding: kPh2,
          onTap: widget.onTapTabBar,
          tabs: [
            TabLabel(
              text: kLabelURLParams,
              showIndicator: widget.showIndicators[0],
            ),
            TabLabel(
              text: kLabelHeaders,
              showIndicator: widget.showIndicators[1],
            ),
            TabLabel(
              text: kLabelBody,
              showIndicator: widget.showIndicators[2],
            ),
          ],
        ),
        kVSpacer5,
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
