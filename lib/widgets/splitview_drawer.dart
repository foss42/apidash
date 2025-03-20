import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class DrawerSplitView extends StatelessWidget {
  const DrawerSplitView({
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
    final theme = Theme.of(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.colorScheme.surface,
      onDrawerChanged: onDrawerChanged,
      onEndDrawerChanged: onEndDrawerChanged,
      drawerEdgeDragWidth: MediaQuery.of(context).size.width,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
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
          ...?actions,
          if (rightDrawerContent != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(
                  rightDrawerIcon ?? Icons.arrow_forward,
                  color: theme.colorScheme.onSurface,
                ),
                onPressed: () {
                  scaffoldKey.currentState!.openEndDrawer();
                },
              ),
            ),
        ],
      ),
      drawer: Drawer(
        shape: const ContinuousRectangleBorder(),
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: kColorTransparent,
        child: leftDrawerContent,
      ),
      endDrawer: rightDrawerContent,
      body: SafeArea(
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: mainContent,
            ),
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
