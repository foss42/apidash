import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:apidash/consts.dart';

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
  // final MultiSplitViewController _controller = MultiSplitViewController(
  //   areas: [
  //     Area(id: "left", min: kMinRequestEditorDetailsCardPaneSize),
  //     Area(id: "right", min: kMinRequestEditorDetailsCardPaneSize),
  //   ],
  // );

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

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
}
