import 'package:flutter/material.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';

class EditorTitle extends ConsumerWidget {
  const EditorTitle({
    super.key,
    required this.title,
    this.showMenu = true,
    this.onSelected,
  });
  final String title;
  final bool showMenu;
  final Function(ItemMenuOption)? onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    double scaleFactor = settings.scaleFactor;

    return IgnorePointer(
      ignoring: !showMenu,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8 * scaleFactor), // Scale border radius
        child: Material(
          color: Colors.transparent,
          child: ItemCardMenu(
            offset: Offset(0, 40 * scaleFactor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8 * scaleFactor), // Scale shape radius
            ),
            splashRadius: 0,
            tooltip: title,
            onSelected: onSelected,
            child: Ink(
              color: Theme.of(context)
                  .colorScheme
                  .secondaryContainer
                  .withOpacity(0.3),
              padding: EdgeInsets.symmetric(
                horizontal: 12.0 * scaleFactor,
                vertical: 6 * scaleFactor,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontSize: 16 * scaleFactor), // Scale text size
                      maxLines: 1,
                    ),
                  ),
                  showMenu
                      ? Icon(
                    Icons.more_vert_rounded,
                    size: 20 * scaleFactor, // Scale icon size
                  )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
