import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:apidash/consts.dart';
import 'tab_label.dart';

class RequestPane extends StatefulHookWidget {
  const RequestPane({
    super.key,
    required this.selectedId,
    required this.codePaneVisible,
    this.tabIndex,
    this.onPressedCodeButton,
    this.onTapTabBar,
    required this.tabLabels,
    required this.children,
    this.showIndicators = const [false, false, false],
    this.showViewCodeButton,
  });

  final String? selectedId;
  final bool codePaneVisible;
  final int? tabIndex;
  final void Function()? onPressedCodeButton;
  final void Function(int)? onTapTabBar;
  final List<String> tabLabels;
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
      initialLength: widget.children.length,
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
                          size: 18,
                        ),
                        label: SizedBox(
                          width: 80,
                          child: Text(
                            widget.codePaneVisible
                                ? kLabelHideCode
                                : kLabelViewCode,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : kVSpacer10,
        TabBar(
          key: Key(widget.selectedId!),
          controller: controller,
          overlayColor: kColorTransparentState,
          labelPadding: kPh2,
          onTap: widget.onTapTabBar,
          tabs: widget.tabLabels.indexed
              .map<Widget>(
                (e) => TabLabel(
                  text: e.$2,
                  showIndicator: widget.showIndicators[e.$1],
                ),
              )
              .toList(),
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
