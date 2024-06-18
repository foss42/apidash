import 'package:apidash/consts.dart';
import 'package:apidash/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/utils/utils.dart';

class EnvironmentPopupMenu extends StatelessWidget {
  const EnvironmentPopupMenu({
    super.key,
    this.activeEnvironment,
    this.onChanged,
    this.environments,
  });

  final EnvironmentModel? activeEnvironment;
  final void Function(EnvironmentModel? value)? onChanged;
  final List<EnvironmentModel>? environments;
  final EnvironmentModel? noneEnvironmentModel = null;
  @override
  Widget build(BuildContext context) {
    final activeEnvironmentName = getEnvironmentTitle(activeEnvironment?.name);
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
          ...environments!.map((EnvironmentModel environment) {
            final name = getEnvironmentTitle(environment.name);
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
              activeEnvironment == null
                  ? "None"
                  : activeEnvironmentName.clip(textClipLength),
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
