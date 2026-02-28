import 'package:apidash_design_system/ui/design_system_provider.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'common_widgets.dart';

class EnvVarPopover extends StatelessWidget {
  const EnvVarPopover({
    super.key,
    required this.suggestion,
    required this.scope,
  });

  final EnvironmentVariableSuggestion suggestion;
  final String scope;

  @override
  Widget build(BuildContext context) {
    final ds = DesignSystemProvider.of(context);
    return Material(
      type: MaterialType.card,
      borderRadius: kBorderRadius8,
      elevation: 8,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 200*ds.scaleFactor),
        child: Ink(
          padding: kP8,
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
                  kHSpacer10(ds.scaleFactor),
                  Text(suggestion.variable.key),
                ],
              ),
              kVSpacer5(ds.scaleFactor),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'VALUE',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  kHSpacer10(ds.scaleFactor),
                  Text(suggestion.variable.value),
                ],
              ),
              kVSpacer5(ds.scaleFactor),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'SCOPE',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  kHSpacer10(ds.scaleFactor),
                  Text(scope),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
