import 'package:flutter/material.dart';
import 'package:apidash/extensions/extensions.dart';
import 'package:apidash/consts.dart';

class CodegenPopupMenu extends StatelessWidget {
  const CodegenPopupMenu({
    super.key,
    required this.value,
    this.onChanged,
    this.items,
  });

  final CodegenLanguage value;
  final void Function(CodegenLanguage? value)? onChanged;
  final List<CodegenLanguage>? items;
  @override
  Widget build(BuildContext context) {
    final textClipLength = context.isCompactWindow ? 12 : 22;
    final double boxLength = context.isCompactWindow ? 150 : 220;
    return PopupMenuButton<CodegenLanguage>(
      tooltip: "Select Code Generation Language",
      surfaceTintColor: kColorTransparent,
      constraints: BoxConstraints(minWidth: boxLength),
      itemBuilder: (BuildContext context) => items!
          .map((item) => PopupMenuItem<CodegenLanguage>(
                value: item,
                child: Text(
                  item.label,
                  style: kTextStylePopupMenuItem,
                ),
              ))
          .toList(),
      onSelected: onChanged,
      child: Container(
        width: boxLength,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value.label.clip(textClipLength),
              style: kTextStylePopupMenuItem,
            ),
            const Icon(
              Icons.unfold_more,
              size: 16,
            )
          ],
        ),
      ),
    );
  }
}
