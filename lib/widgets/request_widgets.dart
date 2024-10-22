import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:apidash/extensions/extensions.dart';
import 'package:apidash/consts.dart';
import 'tabs.dart';

class RequestPane extends StatefulHookWidget {
  const RequestPane({
    super.key,
    required this.selectedId,
    required this.codePaneVisible,
    this.tabIndex,
    this.onPressedCodeButton,
    this.onTapTabBar,
    required this.children,
    this.showIndicators = const [false, false, false],
    this.showViewCodeButton,
  });

  final String? selectedId;
  final bool codePaneVisible;
  final int? tabIndex;
  final void Function()? onPressedCodeButton;
  final void Function(int)? onTapTabBar;
  final List<Widget> children;
  final List<bool> showIndicators;
  final bool? showViewCodeButton;

  @override
  State<RequestPane> createState() => _RequestPaneState();
}

class _RequestPaneState extends State<RequestPane>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final TabController controller = useTabController(
      initialLength: 3,
      vsync: this,
    );
    if (widget.tabIndex != null) {
      controller.index = widget.tabIndex!;
    }
    return Column(
      children: [
        (widget.showViewCodeButton ?? !context.isMediumWindow)
            ? Padding(
                padding: kP8,
                child: SizedBox(
                  height: kHeaderHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FilledButton.tonalIcon(
                        style: FilledButton.styleFrom(
                          padding: kPh12,
                          minimumSize: const Size(44, 44),
                        ),
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
              )
            : const SizedBox.shrink(),
        TabBar(
          key: Key(widget.selectedId!),
          controller: controller,
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
            controller: controller,
            physics: const NeverScrollableScrollPhysics(),
            children: widget.children,
          ),
        ),
      ],
    );
  }
}
