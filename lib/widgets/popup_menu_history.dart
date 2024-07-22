import 'package:flutter/material.dart';
import 'package:apidash/extensions/extensions.dart';
import 'package:apidash/consts.dart';

class HistoryRetentionPopupMenu extends StatelessWidget {
  const HistoryRetentionPopupMenu({
    super.key,
    required this.value,
    required this.onChanged,
    this.items,
  });

  final HistoryRetentionPeriod value;
  final void Function(HistoryRetentionPeriod value) onChanged;
  final List<HistoryRetentionPeriod>? items;
  @override
  Widget build(BuildContext context) {
    final double boxLength = context.isCompactWindow ? 110 : 130;
    return PopupMenuButton(
      tooltip: "Select retention period",
      surfaceTintColor: kColorTransparent,
      constraints: BoxConstraints(minWidth: boxLength),
      itemBuilder: (BuildContext context) {
        return [
          ...items!.map((period) {
            return PopupMenuItem(
              value: period,
              child: Text(
                period.label,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
            );
          })
        ];
      },
      onSelected: onChanged,
      child: Container(
        width: boxLength,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value.label,
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
