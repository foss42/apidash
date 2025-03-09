import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';

class EnvironmentDropdown extends ConsumerWidget {
  const EnvironmentDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final environments = ref.watch(environmentsStateNotifierProvider);
    final environmentSequence = ref.watch(environmentSequenceProvider);
    final environmentsList =
        environmentSequence.map((e) => environments?[e]).nonNulls.toList();

    final activeEnvironment = ref.watch(activeEnvironmentIdStateProvider);
    return EnvironmentPopupMenu(
      value: environments?[activeEnvironment],
      options: environmentsList,
      onChanged: (value) {
        if (value != null) {
          ref.read(activeEnvironmentIdStateProvider.notifier).state = value.id;
          ref
              .read(settingsProvider.notifier)
              .update(activeEnvironmentId: value.id);
          ref.read(hasUnsavedChangesProvider.notifier).state = true;
        }
      },
    );
  }
}
