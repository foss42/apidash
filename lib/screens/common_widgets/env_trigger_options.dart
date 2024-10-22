import 'package:apidash/consts.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/utils.dart';

import 'envvar_indicator.dart';

class EnvironmentTriggerOptions extends ConsumerWidget {
  const EnvironmentTriggerOptions({
    super.key,
    required this.query,
    required this.onSuggestionTap,
  });

  final String query;
  final ValueSetter<EnvironmentVariableSuggestion> onSuggestionTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final envMap = ref.watch(availableEnvironmentVariablesStateProvider);
    final activeEnvironmentId = ref.watch(activeEnvironmentIdStateProvider);
    final suggestions =
        getEnvironmentTriggerSuggestions(query, envMap, activeEnvironmentId);
    return suggestions == null || suggestions.isEmpty
        ? const SizedBox.shrink()
        : ClipRRect(
            borderRadius: kBorderRadius8,
            child: Material(
              type: MaterialType.card,
              elevation: 8,
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxHeight: kSuggestionsMenuMaxHeight),
                child: Ink(
                  width: kSuggestionsMenuWidth,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: kBorderRadius8,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: suggestions.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 2),
                    itemBuilder: (context, index) {
                      final suggestion = suggestions[index];
                      return ListTile(
                        dense: true,
                        leading: EnvVarIndicator(suggestion: suggestion),
                        title: Text(suggestion.variable.key),
                        subtitle: Text(suggestion.variable.value),
                        onTap: () => onSuggestionTap(suggestion),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
  }
}
