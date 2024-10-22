import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/widgets/widgets.dart';

class SidebarFilter extends StatelessWidget {
  const SidebarFilter({
    super.key,
    this.onFilterFieldChanged,
    this.filterHintText,
  });

  final Function(String)? onFilterFieldChanged;
  final String? filterHintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: kBorderRadius8,
        border: Border.all(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
      ),
      child: Row(
        children: [
          kHSpacer5,
          Icon(
            Icons.filter_alt,
            size: 18,
            color: Theme.of(context).colorScheme.secondary,
          ),
          kHSpacer5,
          Expanded(
            child: RawTextField(
              style: Theme.of(context).textTheme.bodyMedium,
              hintText: filterHintText ?? "Filter by name",
              onChanged: onFilterFieldChanged,
            ),
          ),
        ],
      ),
    );
  }
}
