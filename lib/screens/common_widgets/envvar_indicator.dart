import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/consts.dart';

class EnvVarIndicator extends StatelessWidget {
  const EnvVarIndicator({super.key, required this.suggestion});

  final EnvironmentVariableSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    final isUnknown = suggestion.isUnknown;
    final isGlobal = suggestion.environmentId == kGlobalEnvironmentId;
    return Container(
      padding: kP4,
      decoration: BoxDecoration(
        color: isUnknown
            ? Theme.of(context).colorScheme.errorContainer
            : isGlobal
                ? Theme.of(context).colorScheme.secondaryContainer
                : Theme.of(context).colorScheme.primaryContainer,
        borderRadius: kBorderRadius4,
      ),
      child: Icon(
        isUnknown
            ? Icons.block
            : isGlobal
                ? Icons.public
                : Icons.computer,
        size: 16,
      ),
    );
  }
}
