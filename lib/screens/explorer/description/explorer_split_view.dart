import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';

class ExplorerSplitView extends StatefulWidget {
  const ExplorerSplitView({
    super.key,
    required this.sidebarWidget,
    required this.mainWidget,
  });

  final Widget sidebarWidget;
  final Widget mainWidget;

  @override
  ExplorerSplitViewState createState() => ExplorerSplitViewState();
}

class ExplorerSplitViewState extends State<ExplorerSplitView> {
  final MultiSplitViewController _controller = MultiSplitViewController(
    areas: [
      Area(id: "sidebar", min: 350, size: 400, max: 450),
      Area(id: "main"),
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
          color: Theme.of(context).colorScheme.surfaceContainer,
          highlightedColor: Theme.of(context).colorScheme.surfaceContainerHighest,
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