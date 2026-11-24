import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';

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
  final MultiSplitViewController _controller = MultiSplitViewController(
    areas: [
      Area(id: "left", flex: 1),
      Area(id: "right", flex: 1),
    ],
  );

  double? _minWidth;

  static double getMinFractionWidth(double width) {
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

  void _syncMinWidth(double width) {
    final minWidth = getMinFractionWidth(width);
    if (_minWidth == minWidth) return;
    _minWidth = minWidth;
    // Area.min notifies the controller, which would mark MultiSplitView
    // dirty during the build phase — defer to after the frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      for (final area in _controller.areas) {
        area.min = minWidth;
      }
    });
  }

  /// Double-tapping the divider restores the default balanced 50:50 split.
  void _resetPanes() {
    for (final area in _controller.areas) {
      if (area.flex != null) {
        area.flex = 1;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiSplitViewTheme(
      data: MultiSplitViewThemeData(
        dividerThickness: 3,
        dividerPainter: DividerPainters.background(
          color: Theme.of(context).colorScheme.surfaceContainer,
          highlightedColor: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest,
          animationEnabled: false,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          _syncMinWidth(constraints.maxWidth);
          return MultiSplitView(
            controller: _controller,
            onDividerDoubleTap: (_) => _resetPanes(),
            builder: (context, area) {
              if (area.id == "left") {
                return widget.leftWidget;
              }
              return widget.rightWidget;
            },
          );
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
