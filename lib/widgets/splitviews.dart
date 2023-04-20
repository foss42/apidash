import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:apidash/consts.dart';

class DashboardSplitView extends StatefulWidget {
  const DashboardSplitView({
    Key? key,
    required this.sidebarWidget,
    required this.mainWidget,
  }) : super(key: key);

  final Widget sidebarWidget;
  final Widget mainWidget;

  @override
  DashboardSplitViewState createState() => DashboardSplitViewState();
}

class DashboardSplitViewState extends State<DashboardSplitView> {
  final MultiSplitViewController _controller = MultiSplitViewController(
    areas: [
      Area(size: 250, minimalSize: 200),
      Area(minimalWeight: 0.7),
    ],
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: MultiSplitViewTheme(
              data: MultiSplitViewThemeData(
                dividerThickness: 3,
                dividerPainter: DividerPainters.background(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  highlightedColor:
                      Theme.of(context).colorScheme.outline.withOpacity(
                            kHintOpacity,
                          ),
                  animationEnabled: false,
                ),
              ),
              child: MultiSplitView(
                controller: _controller,
                children: [
                  widget.sidebarWidget,
                  widget.mainWidget,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
