import 'package:flutter/material.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';

class EditorTitle extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !showMenu,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: Colors.transparent,
          child: ItemCardMenu(
            offset: const Offset(0, 40),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            splashRadius: 0,
            tooltip: title,
            onSelected: onSelected,
            child: Ink(
              color: Theme.of(context)
                  .colorScheme
                  .secondaryContainer
                  .withOpacity(0.3),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 1,
                    ),
                  ),
                  showMenu
                      ? const Icon(
                          Icons.more_vert_rounded,
                          size: 20,
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
