import 'package:apidash/models/environment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'package:collection/collection.dart';

class EnvironmentDropdown extends ConsumerWidget {
  const EnvironmentDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final environments = ref.watch(environmentsStateNotifierProvider);

    // Explicitly cast the environments list to List<EnvironmentModel>
    final List<EnvironmentModel>? environmentsList =
        environments?.values.toList();

    // Remove the global environment from the list
    environmentsList
        ?.removeWhere((element) => element.id == kGlobalEnvironmentId);

    final activeEnvironmentId = ref.watch(activeEnvironmentIdStateProvider);
    final activeEnvironment = environmentsList?.firstWhereOrNull(
      (env) => env.id == activeEnvironmentId,
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        borderRadius: kBorderRadius8,
      ),
      child: EnvironmentPopupMenu(
        value: activeEnvironment, // Set the value to the environment name
        items: environmentsList?.map((env) => env.name).toList().cast() ??
            [], // Provide an empty list if null
        onChanged: (value) {
          final selectedEnv = environmentsList?.firstWhereOrNull(
            (env) => env.name == value?.name,
          );
          if (selectedEnv != null) {
            ref.read(activeEnvironmentIdStateProvider.notifier).state =
                selectedEnv.id;
            ref
                .read(settingsProvider.notifier)
                .update(activeEnvironmentId: selectedEnv.id);
            ref.read(hasUnsavedChangesProvider.notifier).state = true;
          }
        },
      ),
    );
  }
}
