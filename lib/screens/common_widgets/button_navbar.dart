import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';

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
    final bool isSelected = railIdx == buttonIdx;
    final Size size = isCompact ? const Size(56, 32) : const Size(65, 32);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: isSelected
            ? null
            : () {
                if (buttonIdx != null) {
                  ref.read(navRailIndexStateProvider.notifier).state =
                      buttonIdx!;
                  if (railIdx > 1 && buttonIdx! <= 1) {
                    ref.read(leftDrawerStateProvider.notifier).state = false;
                  }
                }
                onTap?.call();
              },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: isSelected
                  ? TextButton.styleFrom(
                      fixedSize: size,
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                    )
                  : TextButton.styleFrom(
                      fixedSize: size,
                    ),
              onPressed: isSelected
                  ? null
                  : () {
                      if (buttonIdx != null) {
                        ref.read(navRailIndexStateProvider.notifier).state =
                            buttonIdx!;
                        if (railIdx > 1 && buttonIdx! <= 1) {
                          ref.read(leftDrawerStateProvider.notifier).state =
                              false;
                        }
                      }
                      onTap?.call();
                    },
              child: Icon(
                isSelected ? selectedIcon : icon,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
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
