import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:apidash/consts.dart';

class DashboardSplitView extends StatefulWidget {
  const DashboardSplitView({
    super.key,
    required this.sidebarWidget,
    required this.mainWidget,
    this.scaleFactor = 1.0, // Added scale factor
  });

  final Widget sidebarWidget;
  final Widget mainWidget;
  final double scaleFactor; // Scale factor to adjust the size dynamically

  @override
  DashboardSplitViewState createState() => DashboardSplitViewState();
}

class DashboardSplitViewState extends State<DashboardSplitView> {
  late final MultiSplitViewController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize MultiSplitViewController with scaled sizes
    _controller = MultiSplitViewController(
      areas: [
        Area(
          id: "sidebar",
          min: 220 * widget.scaleFactor, // Apply scaling
          size: 250 * widget.scaleFactor, // Apply scaling
          max: 350 * widget.scaleFactor, // Apply scaling
        ),
        Area(
          id: "main",
          min: 400 * widget.scaleFactor, // Apply scaling
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiSplitViewTheme(
      data: MultiSplitViewThemeData(
        dividerThickness: 3 * widget.scaleFactor, // Scale divider thickness
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
            "sidebar" => Padding(
              padding: EdgeInsets.only(
                right: 10 * widget.scaleFactor, // Scale padding between sidebar and main widget
              ),
              child: widget.sidebarWidget,
            ),
            "main" => Padding(
              padding: EdgeInsets.only(
                left: 10 * widget.scaleFactor, // Scale padding between sidebar and main widget
              ),
              child: widget.mainWidget,
            ),
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
