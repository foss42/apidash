import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/extensions/context_extensions.dart';
import 'package:apidash/providers/ui_providers.dart';

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
                  child: customNavigationDestination(
                    context,
                    ref,
                    railIdx,
                    2,
                    Icons.help,
                    Icons.help_outline,
                    'About',
                  ),
                ),
                Expanded(
                  child: customNavigationDestination(
                    context,
                    ref,
                    railIdx,
                    3,
                    Icons.settings,
                    Icons.settings_outlined,
                    'Settings',
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

class NavRail extends ConsumerWidget {
  const NavRail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final railIdx = ref.watch(navRailIndexStateProvider);
    return Material(
      type: MaterialType.transparency,
      child: Container(
        width: 70,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Theme.of(context).colorScheme.onInverseSurface,
              width: 1,
            ),
          ),
        ),
        child: Column(
          children: [
            customNavigationDestination(
              context,
              ref,
              railIdx,
              0,
              Icons.dashboard,
              Icons.dashboard_outlined,
              'Requests',
            ),
            const SizedBox(height: 16),
            customNavigationDestination(
              context,
              ref,
              railIdx,
              1,
              Icons.laptop_windows,
              Icons.laptop_windows_outlined,
              'Variables',
            ),
            const Expanded(child: SizedBox()),
            customNavigationDestination(
              context,
              ref,
              railIdx,
              2,
              Icons.help,
              Icons.help_outline,
              'About',
            ),
            const SizedBox(height: 24),
            customNavigationDestination(
              context,
              ref,
              railIdx,
              3,
              Icons.settings,
              Icons.settings_outlined,
              'Settings',
            ),
          ],
        ),
      ),
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
  bool showLabel = true,
  Function()? onTap,
}) {
  bool isSelected = railIdx == buttonIdx;
  return TooltipVisibility(
    visible: context.isCompactWindow,
    child: Tooltip(
      message: label,
      triggerMode: TooltipTriggerMode.longPress,
      verticalOffset: 42,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: isSelected
            ? null
            : () {
                ref.read(navRailIndexStateProvider.notifier).state = buttonIdx;
                if (railIdx > 1 && buttonIdx <= 1) {
                  ref.read(leftDrawerStateProvider.notifier).state = false;
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
                        ref.read(navRailIndexStateProvider.notifier).state =
                            buttonIdx;
                        if (railIdx > 1 && buttonIdx <= 1) {
                          ref.read(leftDrawerStateProvider.notifier).state =
                              false;
                        }
                        onTap?.call();
                      },
                child: Icon(
                  isSelected ? selectedIcon : icon,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onSecondaryContainer
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.65),
                ),
              ),
            ),
            showLabel ? const SizedBox(height: 4) : const SizedBox.shrink(),
            showLabel
                ? Text(
                    label,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.65),
                        ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    ),
  );
}
