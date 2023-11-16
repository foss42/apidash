import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:apidash/consts.dart';

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
    return MultiSplitViewTheme(
      data: MultiSplitViewThemeData(
        dividerThickness: 3,
        dividerPainter: DividerPainters.background(
          color: Theme.of(context).colorScheme.surfaceVariant,
          highlightedColor: Theme.of(context).colorScheme.outline.withOpacity(
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
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

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
      Area(minimalSize: kMinRequestEditorDetailsCardPaneSize),
      Area(minimalSize: kMinRequestEditorDetailsCardPaneSize),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MultiSplitViewTheme(
      data: MultiSplitViewThemeData(
        dividerThickness: 3,
        dividerPainter: DividerPainters.background(
          color: Theme.of(context).colorScheme.surfaceVariant,
          highlightedColor: Theme.of(context).colorScheme.outline.withOpacity(
                kHintOpacity,
              ),
          animationEnabled: false,
        ),
      ),
      child: MultiSplitView(
        controller: _controller,
        children: [
          widget.leftWidget,
          widget.rightWidget,
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
