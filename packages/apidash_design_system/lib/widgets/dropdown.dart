import 'package:flutter/material.dart';
import '../tokens/tokens.dart';

class ADDropdownButton<T> extends StatelessWidget {
  const ADDropdownButton({
    super.key,
    this.value,
    required this.values,
    this.onChanged,
    this.isExpanded = false,
    this.isDense = false,
    this.iconSize,
    this.fontSize,
    this.dropdownMenuItemPadding = kPs8,
    this.dropdownMenuItemtextStyle,
  });

  final T? value;
  final Iterable<(T, String?)> values;
  final void Function(T?)? onChanged;
  final bool isExpanded;
  final bool isDense;
  final double? iconSize;
  final double? fontSize;
  final EdgeInsetsGeometry dropdownMenuItemPadding;
  final TextStyle? Function(T)? dropdownMenuItemtextStyle;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    return DropdownButton<T>(
      isExpanded: isExpanded,
      isDense: isDense,
      focusColor: surfaceColor,
      value: value,
      icon: Icon(
        Icons.unfold_more_rounded,
        size: iconSize,
      ),
      elevation: 4,
      style: kCodeStyle.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontSize: fontSize ?? Theme.of(context).textTheme.bodyMedium?.fontSize,
      ),
      underline: Container(
        height: 0,
      ),
      onChanged: onChanged,
      borderRadius: kBorderRadius12,
      items: values.map<DropdownMenuItem<T>>(((T, String?) value) {
        return DropdownMenuItem<T>(
          value: value.$1,
          child: Padding(
            padding: dropdownMenuItemPadding,
            child: Text(
              value.$2 ?? value.$1.toString(),
              style:
                  dropdownMenuItemtextStyle?.call(value.$1) ?? kTextStyleButton,
              overflow: isExpanded ? TextOverflow.ellipsis : null,
              maxLines: isExpanded ? 1 : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}
