import 'package:flutter/material.dart';
import 'package:apidash/extensions/extensions.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_providers.dart';

class EnvironmentPopupMenu extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    double scaleFactor = settings.scaleFactor;

    final valueName = getEnvironmentTitle(value?.name);
    final double boxLength = context.isCompactWindow ? 100 * scaleFactor : 130 * scaleFactor;

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
            child: Text(
              "None",
              style: TextStyle(fontSize: 14 * scaleFactor), // Scale font size
            ),
          ),
          ...items!.map((EnvironmentModel environment) {
            final name = getEnvironmentTitle(environment.name).clip(30);
            return PopupMenuItem(
              value: environment,
              child: Text(
                name,
                style: TextStyle(fontSize: 14 * scaleFactor), // Scale font size
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
        padding: const EdgeInsets.all(8.0 ), // Scale padding
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value == null ? "None" : valueName,
                style: TextStyle(fontSize: 14 * scaleFactor), // Scale font size
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.unfold_more,
              size: 16 * scaleFactor, // Scale icon size
            )
          ],
        ),
      ),
    );
  }
}
