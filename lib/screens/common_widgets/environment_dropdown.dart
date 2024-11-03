import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';

class EnvironmentDropdown extends ConsumerWidget {
  const EnvironmentDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final environments = ref.watch(environmentsStateNotifierProvider);
    final environmentsList = environments?.values.toList();
    environmentsList
        ?.removeWhere((element) => element.id == kGlobalEnvironmentId);
    final activeEnvironment = ref.watch(activeEnvironmentIdStateProvider);
    return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          borderRadius: kBorderRadius8,
        ),
        child: EnvironmentPopupMenu(
          value: environments?[activeEnvironment],
          items: environmentsList,
          onChanged: (value) {
            ref.read(activeEnvironmentIdStateProvider.notifier).state =
                value?.id;
            ref
                .read(settingsProvider.notifier)
                .update(activeEnvironmentId: value?.id);
            ref.read(hasUnsavedChangesProvider.notifier).state = true;
          },
        ));
  }
}
