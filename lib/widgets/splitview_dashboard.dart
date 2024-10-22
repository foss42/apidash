import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';

class DashboardSplitView extends StatefulWidget {
  const DashboardSplitView({
    super.key,
    required this.sidebarWidget,
    required this.mainWidget,
  });

  final Widget sidebarWidget;
  final Widget mainWidget;

  @override
  DashboardSplitViewState createState() => DashboardSplitViewState();
}

class DashboardSplitViewState extends State<DashboardSplitView> {
  final MultiSplitViewController _controller = MultiSplitViewController(
    areas: [
      Area(id: "sidebar", min: 220, size: 250, max: 350),
      Area(id: "main", min: 400),
    ],
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiSplitViewTheme(
      data: MultiSplitViewThemeData(
        dividerThickness: 3,
        dividerPainter: DividerPainters.background(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          highlightedColor: Theme.of(context).colorScheme.outline.withOpacity(
                kHintOpacity,
              ),
          animationEnabled: false,
        ),
      ),
      child: MultiSplitView(
        controller: _controller,
        sizeOverflowPolicy: SizeOverflowPolicy.shrinkFirst,
        sizeUnderflowPolicy: SizeUnderflowPolicy.stretchLast,
        builder: (context, area) {
          return switch (area.id) {
            "sidebar" => widget.sidebarWidget,
            "main" => widget.mainWidget,
            _ => Container(),
          };
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
