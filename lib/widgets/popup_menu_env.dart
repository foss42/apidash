import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/utils/utils.dart';
import '../consts.dart';

class EnvironmentPopupMenu extends StatelessWidget {
  const EnvironmentPopupMenu({
    super.key,
    this.value,
    this.options,
    this.onChanged,
  });

  final EnvironmentModel? value;
  final void Function(EnvironmentModel? value)? onChanged;
  final List<EnvironmentModel>? options;

  @override
  Widget build(BuildContext context) {
    final double width = context.isCompactWindow ? 100 : 130;

    // Use PopupMenuButton directly to customize the items
    return PopupMenuButton<EnvironmentModel>(
      tooltip: "Select Environment",
      surfaceTintColor: kColorTransparent,
      constraints: BoxConstraints(minWidth: width),
      itemBuilder: (BuildContext context) => options?.map((e) {
            final label = (e.id == kGlobalEnvironmentId)
                ? "None"
                : getEnvironmentTitle(e.name).clip(30);
            final Color? bgColor = e.color != null
                ? Color(int.parse(e.color!.substring(1), radix: 16))
                : null;
            return PopupMenuItem<EnvironmentModel>(
              value: e,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: bgColor?.withOpacity(0.2), 
                  borderRadius: kBorderRadius8,
                ),
                child: Text(
                  label,
                  style: kTextStylePopupMenuItem.copyWith(
                    color: bgColor != null
                        ? Theme.of(context).colorScheme.onSurface
                        : null, // Ensure text is readable
                  ),
                ),
              ),
            );
          }).toList() ??
          [],
      onSelected: onChanged,
      child: Container(
        width: width,
        padding: kP8,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          borderRadius: kBorderRadius8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                (value == null || value?.id == kGlobalEnvironmentId)
                    ? "None"
                    : getEnvironmentTitle(value?.name),
                style: kTextStylePopupMenuItem,
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
