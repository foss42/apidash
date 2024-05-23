import 'package:apidash/consts.dart';
import 'package:apidash/screens/mobile/navbar.dart';
import 'package:flutter/material.dart';

class LeftDrawer extends StatelessWidget {
  final Widget drawerContent;
  const LeftDrawer({super.key, required this.drawerContent});

  @override
  Widget build(BuildContext context) {
    final isLargeMobile = MediaQuery.sizeOf(context).width > kLargeMobileWidth;
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
      color: Theme.of(context).colorScheme.onInverseSurface,
      child: Drawer(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Container(
            padding: EdgeInsets.only(
                left: MediaQuery.paddingOf(context).left,
                bottom: isLargeMobile
                    ? MediaQuery.paddingOf(context).bottom
                    : 70 + MediaQuery.paddingOf(context).bottom),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius:
                  const BorderRadius.only(topRight: Radius.circular(8)),
            ),
            child: isLargeMobile
                ? Row(
                    children: [
                      const NavRail(),
                      Expanded(child: drawerContent),
                    ],
                  )
                : drawerContent,
          ),
        ),
      ),
    );
  }
}
