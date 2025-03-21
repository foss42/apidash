import 'package:flutter/material.dart';
import '../tokens/tokens.dart';

class ADPopupMenu<T> extends StatelessWidget {
  const ADPopupMenu({
    super.key,
    this.value,
    required this.values,
    this.onChanged,
    this.tooltip,
    this.width,
    this.isOutlined = false,
    this.borderColor,
    this.itemColors,
    this.valueColor,
  });

  final String? value;
  final Iterable<(T, String?)> values;
  final void Function(T? value)? onChanged;
  final String? tooltip;
  final double? width;
  final bool isOutlined;
  final Color? borderColor;
  final List<Color?>? itemColors;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final double containerWidth = width ?? 220;
    var popup = PopupMenuButton<T>(
      tooltip: tooltip,
      surfaceTintColor: kColorTransparent,
      constraints: BoxConstraints(minWidth: containerWidth),
      itemBuilder: (BuildContext context) => List.generate(
        values.length,
        (index) {
          final item = values.elementAt(index);
          final Color? itemColor = itemColors != null && index < itemColors!.length
              ? itemColors![index]
              : null;

          return PopupMenuItem<T>(
            value: item.$1,
            child: Row(
              children: [
                if (itemColor != null)
                  Container(
                    width: 16,
                    height: 16,
                    margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                        color: itemColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                        width: 1,
                      ),
              ),
                  ),
                Expanded(
                child: Text(
                  item.$2 ?? "",
                  style: kTextStylePopupMenuItem,
                ),
              ),
              ],            ),
          );
        },
      ),
      onSelected: onChanged,
      child: Container(
        width: containerWidth,
        padding: kP8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (valueColor != null)
              Container(
                width: 16,
                height: 16,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: valueColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                    width: 1,
                  ),
                ),
              ),
            Expanded(
              child: Text(
                value ?? "",
                style: kTextStylePopupMenuItem,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(
              Icons.unfold_more,
              size: 16,
            )
          ],
        ),
      ),
    );
    if (isOutlined) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor ??
                Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          borderRadius: kBorderRadius8,
        ),
        child: popup,
      );
    }
    return popup;
  }
}
