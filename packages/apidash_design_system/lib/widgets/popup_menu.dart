// import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash_design_system/ui/design_system_provider.dart';
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
  });

  final String? value;
  final Iterable<(T, String?)> values;
  final void Function(T? value)? onChanged;
  final String? tooltip;
  final double? width;
  final bool isOutlined;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final ds = DesignSystemProvider.of(context);
    final double containerWidth = width ?? 220;
    var popup = PopupMenuButton<T>(
      tooltip: tooltip,
      surfaceTintColor: kColorTransparent,
      constraints: BoxConstraints(minWidth: containerWidth),
      itemBuilder: (BuildContext context) => values
          .map((item) => PopupMenuItem<T>(
                value: item.$1,
                child: Text(
                  item.$2 ?? "",
                  style: kTextStylePopupMenuItem(ds.scaleFactor),
                ),
              ))
          .toList(),
      onSelected: onChanged,
      child: Container(
        width: containerWidth*ds.scaleFactor,
        padding: kP8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value ?? "",
                style: kTextStylePopupMenuItem(ds.scaleFactor),
                softWrap: false,
                overflow: TextOverflow.clip,
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
