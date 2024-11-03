import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/extensions/extensions.dart';

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
    final double boxLength = context.isCompactWindow ? 90 : 110;
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
            Expanded(
              child: Text(
                value,
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
  }
}
