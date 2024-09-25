import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/utils.dart';

class NavbarButton extends ConsumerWidget {
  const NavbarButton({
    super.key,
    required this.railIdx,
    this.buttonIdx,
    required this.selectedIcon,
    required this.icon,
    required this.label,
    this.showLabel = true,
    this.isCompact = false,
    this.onTap,
  });
  final int railIdx;
  final int? buttonIdx;
  final IconData selectedIcon;
  final IconData icon;
  final String label;
  final bool showLabel;
  final Function()? onTap;
  final bool isCompact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mobileScaffoldKeyNotifier =
        ref.watch(mobileScaffoldKeyStateProvider.notifier);
    final bool isSelected = railIdx == buttonIdx;
    var onPress = isSelected
        ? null
        : () {
            if (buttonIdx != null) {
              final scaffoldKey = getScaffoldKey(buttonIdx!);
              ref.watch(navRailIndexStateProvider.notifier).state = buttonIdx!;
              mobileScaffoldKeyNotifier.state = scaffoldKey;
              ref.read(leftDrawerStateProvider.notifier).state = false;
            }
            onTap?.call();
          };
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onPress,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: isCompact ? 36 : 36,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: isSelected
                      ? Theme.of(context).colorScheme.secondaryContainer
                      : null,
                ),
                onPressed: onPress,
                child: Icon(
                  isSelected ? selectedIcon : icon,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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
    );
  }
}
