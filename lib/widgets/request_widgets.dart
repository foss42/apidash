import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'tabs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context);
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
                  l10n!.kLabelRequests,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                FilledButton.tonalIcon(
                  onPressed: widget.onPressedCodeButton,
                  icon: Icon(
                    widget.codePaneVisible
                        ? Icons.code_off_rounded
                        : Icons.code_rounded,
                  ),
                  label: SizedBox(
                    //TODO : Verify if okay
                    // width: 75,
                    child: Text(widget.codePaneVisible
                        ? l10n.kLabelHideCode
                        : l10n.kLabelShowCode),
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
          onTap: widget.onTapTabBar,
          tabs: [
            TabLabel(
              text: l10n.kLabelURLParams,
              showIndicator: widget.showIndicators[0],
            ),
            TabLabel(
              text: l10n.kLabelHeaders,
              showIndicator: widget.showIndicators[1],
            ),
            TabLabel(
              text: l10n.kLabelBody,
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
