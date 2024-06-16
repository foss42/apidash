import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:apidash/extensions/extensions.dart';
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

class TwoDrawerScaffold extends StatelessWidget {
  const TwoDrawerScaffold({
    super.key,
    required this.scaffoldKey,
    required this.mainContent,
    required this.title,
    this.actions,
    this.leftDrawerContent,
    this.rightDrawerContent,
    this.rightDrawerIcon,
    this.bottomNavigationBar,
    this.onDrawerChanged,
    this.onEndDrawerChanged,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;
  final Widget mainContent;
  final Widget title;
  final List<Widget>? actions;
  final Widget? leftDrawerContent;
  final Widget? rightDrawerContent;
  final IconData? rightDrawerIcon;
  final Widget? bottomNavigationBar;
  final ValueChanged<bool>? onDrawerChanged;
  final ValueChanged<bool>? onEndDrawerChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: (kIsWindows || kIsMacOS) ? kPt28 : EdgeInsets.zero,
      color: Theme.of(context).colorScheme.surface,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        onDrawerChanged: onDrawerChanged,
        onEndDrawerChanged: onEndDrawerChanged,
        drawerEdgeDragWidth: context.width,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          scrolledUnderElevation: 0,
          shape: const ContinuousRectangleBorder(),
          leading: IconButton(
            icon: const Icon(Icons.format_list_bulleted_rounded),
            onPressed: () {
              scaffoldKey.currentState!.openDrawer();
            },
          ),
          title: title,
          titleSpacing: 0,
          actions: [
            ...actions ?? [],
            (rightDrawerContent != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: Icon(
                        rightDrawerIcon ?? Icons.arrow_forward,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      onPressed: () {
                        scaffoldKey.currentState!.openEndDrawer();
                      },
                    ),
                  )
                : const SizedBox.shrink()),
          ],
        ),
        drawer: leftDrawerContent,
        endDrawer: rightDrawerContent,
        body: mainContent,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}
