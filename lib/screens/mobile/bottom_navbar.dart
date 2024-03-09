import 'package:apidash/providers/ui_providers.dart';
import 'package:apidash/screens/mobile/page_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../settings_page.dart';
import '../intro_page.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final railIdx = ref.watch(navRailIndexStateProvider);
    return Wrap(
      children: [
        Container(
          alignment: Alignment.topCenter,
          height: 70 + MediaQuery.of(context).padding.bottom,
          width: MediaQuery.of(context).size.width,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
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
                  child: customNavigationDestination(context, ref, railIdx, 0,
                      Icons.dashboard, Icons.dashboard_outlined, 'Requests'),
                ),
                Expanded(
                  child: customNavigationDestination(
                      context,
                      ref,
                      railIdx,
                      1,
                      Icons.laptop_windows,
                      Icons.laptop_windows_outlined,
                      'Variables'),
                ),
                Expanded(
                  child: customNavigationDestination(context, ref, railIdx, 2,
                      Icons.help, Icons.help_outline, 'About',
                      isNavigator: true, onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const PageBase(
                                title: 'About',
                                scaffoldBody: IntroPage(),
                              )),
                    );
                  }),
                ),
                Expanded(
                  child: customNavigationDestination(context, ref, railIdx, 3,
                      Icons.settings, Icons.settings_outlined, 'Settings',
                      isNavigator: true, onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const PageBase(
                                title: 'Settings',
                                scaffoldBody: SettingsPage(),
                              )),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget customNavigationDestination(
  BuildContext context,
  WidgetRef ref,
  int railIdx,
  int buttonIdx,
  IconData selectedIcon,
  IconData icon,
  String label, {
  bool isNavigator = false,
  Function()? onTap,
}) {
  bool isSelected = railIdx == buttonIdx;
  return Tooltip(
    message: label,
    triggerMode: TooltipTriggerMode.longPress,
    verticalOffset: 42,
    child: GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: isSelected
          ? null
          : () {
              if (!isNavigator) {
                ref.read(navRailIndexStateProvider.notifier).state = buttonIdx;
              }
              onTap?.call();
            },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Ink(
            width: 65,
            height: 32,
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.secondaryContainer
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: isSelected
                  ? null
                  : () {
                      if (!isNavigator) {
                        ref.read(navRailIndexStateProvider.notifier).state =
                            buttonIdx;
                      }
                      onTap?.call();
                    },
              child: Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected
                    ? Theme.of(context).colorScheme.onSecondaryContainer
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.65),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onSecondaryContainer
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.65),
                ),
          ),
        ],
      ),
    ),
  );
}
