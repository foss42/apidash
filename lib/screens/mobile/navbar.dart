import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import '../common_widgets/common_widgets.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final railIdx = ref.watch(navRailIndexStateProvider);
    return Wrap(
      children: [
        Container(
          alignment: Alignment.topCenter,
          height: 70 + MediaQuery.paddingOf(context).bottom,
          width: MediaQuery.sizeOf(context).width,
          padding:
              EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.onInverseSurface,
              ),
            ),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Material(
            type: MaterialType.transparency,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: NavbarButton(
                    railIdx: railIdx,
                    buttonIdx: 0,
                    selectedIcon: Icons.auto_awesome_mosaic_rounded,
                    icon: Icons.auto_awesome_mosaic_outlined,
                    label: 'Requests',
                  ),
                ),
                Expanded(
                  child: NavbarButton(
                    railIdx: railIdx,
                    buttonIdx: 1,
                    selectedIcon: Icons.laptop_windows,
                    icon: Icons.laptop_windows_outlined,
                    label: 'Variables',
                  ),
                ),
                Expanded(
                  child: NavbarButton(
                    railIdx: railIdx,
                    buttonIdx: 2,
                    selectedIcon: Icons.history_rounded,
                    icon: Icons.history_outlined,
                    label: 'History',
                  ),
                ),
                Expanded(
                  child: NavbarButton(
                    railIdx: railIdx,
                    buttonIdx: 3,
                    selectedIcon: Icons.settings,
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
