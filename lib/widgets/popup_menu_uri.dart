import 'package:apidash/consts.dart';
import 'package:apidash/extensions/extensions.dart';
import 'package:flutter/material.dart';

class URIPopupMenu extends StatelessWidget {
  const URIPopupMenu({
    super.key,
    required this.value,
    this.onChanged,
    this.items,
  });

  final String value;
  final void Function(String? value)? onChanged;
  final List<String>? items;
  @override
  Widget build(BuildContext context) {
    final double boxLength = context.isCompactWindow ? 90 : 130;
    return PopupMenuButton(
      tooltip: "Select URI Scheme",
      surfaceTintColor: kColorTransparent,
      constraints: BoxConstraints(minWidth: boxLength),
      itemBuilder: (BuildContext context) => items!
          .map((item) => PopupMenuItem(
                value: item,
                child: Text(
                  item,
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
              value,
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
