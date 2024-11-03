import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/extensions/extensions.dart';
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
    return Container(
      padding: (kIsWindows || kIsMacOS) ? kPt28 : EdgeInsets.zero,
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
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
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        onPressed: () {
                          scaffoldKey.currentState!.openEndDrawer();
                        },
                      ),
                    )
                  : const SizedBox.shrink()),
            ],
          ),
          drawer: Drawer(
            shape: const ContinuousRectangleBorder(),
            backgroundColor: Theme.of(context).colorScheme.surface,
            surfaceTintColor: kColorTransparent,
            child: leftDrawerContent,
          ),
          endDrawer: rightDrawerContent,
          body: mainContent,
          bottomNavigationBar: bottomNavigationBar,
        ),
      ),
    );
  }
}
