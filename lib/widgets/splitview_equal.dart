import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';

// Changed from StatelessWidget to StatefulWidget
class EqualSplitView extends StatefulWidget {
  const EqualSplitView({
    super.key,
    required this.leftWidget,
    required this.rightWidget,
  });

  final Widget leftWidget;
  final Widget rightWidget;

  @override
  State<EqualSplitView> createState() => _EqualSplitViewState();
}

class _EqualSplitViewState extends State<EqualSplitView> {
  // Declare the controller in the State
  late MultiSplitViewController _controller;

  double getMinFractionWidth(double width) {
    if (width < 900) {
      return 0.9;
    } else if (width < 1000) {
      return 0.7;
    } else if (width < 1200) {
      return 0.5;
    } else {
      return 0.4;
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize the controller ONCE here so dragged sizes survive rebuilds
    _controller = MultiSplitViewController(
      areas: [
        Area(id: "left", flex: 1),
        Area(id: "right", flex: 1),
      ],
    );
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiSplitViewTheme(
      data: MultiSplitViewThemeData(
        dividerThickness: 3,
        dividerPainter: DividerPainters.background(
          color: Theme.of(context).colorScheme.surfaceContainer,
          highlightedColor:
              Theme.of(context).colorScheme.surfaceContainerHighest,
          animationEnabled: false,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final minWidth = getMinFractionWidth(constraints.maxWidth);
          
          // Safely update min constraints on the existing areas 
          // without destroying the flex weights the user dragged
          for (var area in _controller.areas) {
             area.min = minWidth; 
          }

          return MultiSplitView(
            controller: _controller, // Use the preserved controller
            builder: (context, area) {
              return switch (area.id) {
                // Access left/right widgets using 'widget.' prefix
                "left" => widget.leftWidget, 
                "right" => widget.rightWidget, 
                _ => Container(),
              };
            },
          );
        },
      ),
    );
  }
}