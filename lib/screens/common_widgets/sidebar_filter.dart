import 'package:flutter/material.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/settings_providers.dart';

class SidebarFilter extends ConsumerWidget {
  const SidebarFilter({
    super.key,
    this.onFilterFieldChanged,
    this.filterHintText,
  });

  final Function(String)? onFilterFieldChanged;
  final String? filterHintText;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    double scaleFactor = settings.scaleFactor;
    return Container(
      margin: EdgeInsets.only(right: 8*scaleFactor),
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
            size: 18*scaleFactor,
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
