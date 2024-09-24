import 'package:flutter/material.dart';

class ScaleFactorPopupMenu extends StatelessWidget {
  const ScaleFactorPopupMenu({
    super.key,
    required this.value,
    this.onChanged,
    this.items,
  });

  final int value;
  final void Function(int? value)? onChanged;
  final List<int>? items;

  @override
  Widget build(BuildContext context) {
    final double boxLength = 150 * MediaQuery.of(context).textScaleFactor;  // Adjusting box size based on scale
    return PopupMenuButton<int>(
      tooltip: "Select UI Scale Factor",
      surfaceTintColor: Colors.transparent,
      constraints: BoxConstraints(minWidth: boxLength),
      itemBuilder: (BuildContext context) => items!
          .map((item) => PopupMenuItem<int>(
        value: item,
        child: Text(
          '$item%',
          style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize),
        ),
      ))
          .toList(),
      onSelected: onChanged,
      child: Container(
        width: boxLength,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '$value%',
                style: Theme.of(context).textTheme.bodyMedium,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(
              Icons.unfold_more,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
