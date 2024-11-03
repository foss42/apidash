import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';

class EqualSplitView extends StatelessWidget {
  const EqualSplitView({
    super.key,
    required this.leftWidget,
    required this.rightWidget,
  });

  final Widget leftWidget;
  final Widget rightWidget;

  getMinFractionWidth(double width) {
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final minWidth = getMinFractionWidth(constraints.maxWidth);
          return MultiSplitView(
            controller: MultiSplitViewController(
              areas: [
                Area(id: "left", flex: 1, min: minWidth),
                Area(id: "right", flex: 1, min: minWidth),
              ],
            ),
            builder: (context, area) {
              return switch (area.id) {
                "left" => leftWidget,
                "right" => rightWidget,
                _ => Container(),
              };
            },
          );
        },
      ),
    );
  }
}
