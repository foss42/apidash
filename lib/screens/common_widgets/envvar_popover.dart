import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_providers.dart';
import 'common_widgets.dart';

class EnvVarPopover extends ConsumerWidget {
  const EnvVarPopover({
    super.key,
    required this.suggestion,
    required this.scope,
  });

  final EnvironmentVariableSuggestion suggestion;
  final String scope;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    double scaleFactor = settings.scaleFactor;

    return Material(
      type: MaterialType.card,
      borderRadius: kBorderRadius8,
      elevation: 8,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 200 * scaleFactor),
        child: Ink(
          padding: kP8*scaleFactor, // Scale padding
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: kBorderRadius8,
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  EnvVarIndicator(suggestion: suggestion),
                  SizedBox(width: 10 * scaleFactor), // Scale horizontal spacing
                  Text(
                    suggestion.variable.key,
                    style: TextStyle(fontSize: 14 * scaleFactor), // Scale font size
                  ),
                ],
              ),
              SizedBox(height: 5 * scaleFactor), // Scale vertical spacing
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'VALUE',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: 12 * scaleFactor, // Scale font size
                    ),
                  ),
                  SizedBox(width: 10 * scaleFactor), // Scale horizontal spacing
                  Text(
                    suggestion.variable.value,
                    style: TextStyle(fontSize: 14 * scaleFactor), // Scale font size
                  ),
                ],
              ),
              SizedBox(height: 5 * scaleFactor), // Scale vertical spacing
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'SCOPE',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: 12 * scaleFactor, // Scale font size
                    ),
                  ),
                  SizedBox(width: 10 * scaleFactor), // Scale horizontal spacing
                  Text(
                    scope,
                    style: TextStyle(fontSize: 14 * scaleFactor), // Scale font size
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
