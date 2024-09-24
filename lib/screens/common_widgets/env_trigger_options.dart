import 'package:apidash/consts.dart';
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
    final settings = ref.watch(settingsProvider);
    double scaleFactor = settings.scaleFactor;  // Fetching the scale factor
    final envMap = ref.watch(availableEnvironmentVariablesStateProvider);
    final activeEnvironmentId = ref.watch(activeEnvironmentIdStateProvider);
    final suggestions =
    getEnvironmentTriggerSuggestions(query, envMap, activeEnvironmentId);

    return suggestions == null || suggestions.isEmpty
        ? const SizedBox.shrink()
        : ClipRRect(
      borderRadius: kBorderRadius8 * scaleFactor,  // Scale border radius
      child: Material(
        type: MaterialType.card,
        elevation: 8 * scaleFactor,  // Scale elevation
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: kSuggestionsMenuMaxHeight * scaleFactor,  // Scale max height
          ),
          child: Ink(
            width: kSuggestionsMenuWidth * scaleFactor,  // Scale width
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: kBorderRadius8 * scaleFactor,  // Scale border radius
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: suggestions.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 2 * scaleFactor),  // Scale divider height
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16 * scaleFactor,  // Scale padding
                    vertical: 8 * scaleFactor,  // Scale padding
                  ),
                  leading: EnvVarIndicator(suggestion: suggestion),
                  title: Text(
                    suggestion.variable.key,
                    style: TextStyle(
                      fontSize: 14 * scaleFactor,  // Scale text size
                    ),
                  ),
                  subtitle: Text(
                    suggestion.variable.value,
                    style: TextStyle(
                      fontSize: 12 * scaleFactor,  // Scale subtitle text size
                    ),
                  ),
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
