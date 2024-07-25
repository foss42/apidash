import 'package:flutter/material.dart';
import 'package:apidash/extensions/extensions.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';

class EnvironmentPopupMenu extends StatelessWidget {
  const EnvironmentPopupMenu({
    super.key,
    this.value,
    this.onChanged,
    this.items,
  });

  final EnvironmentModel? value;
  final void Function(EnvironmentModel? value)? onChanged;
  final List<EnvironmentModel>? items;
  final EnvironmentModel? noneEnvironmentModel = null;
  @override
  Widget build(BuildContext context) {
    final valueName = getEnvironmentTitle(value?.name);
    final textClipLength = context.isCompactWindow ? 6 : 10;
    final double boxLength = context.isCompactWindow ? 100 : 130;
    return PopupMenuButton(
      tooltip: "Select Environment",
      surfaceTintColor: kColorTransparent,
      constraints: BoxConstraints(minWidth: boxLength),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            value: noneEnvironmentModel,
            onTap: () {
              onChanged?.call(null);
            },
            child: const Text("None"),
          ),
          ...items!.map((EnvironmentModel environment) {
            final name = getEnvironmentTitle(environment.name).clip(30);
            return PopupMenuItem(
              value: environment,
              child: Text(
                name,
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
              value == null ? "None" : valueName.clip(textClipLength),
              softWrap: false,
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
