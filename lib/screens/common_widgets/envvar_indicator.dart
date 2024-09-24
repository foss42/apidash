import 'package:flutter/material.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/consts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/settings_providers.dart';

class EnvVarIndicator extends ConsumerWidget {
  const EnvVarIndicator({super.key, required this.suggestion});

  final EnvironmentVariableSuggestion suggestion;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    double scaleFactor = settings.scaleFactor;
    final isUnknown = suggestion.isUnknown;
    final isGlobal = suggestion.environmentId == kGlobalEnvironmentId;
    return Container(
      padding: kP4*scaleFactor,
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
        size: 16*scaleFactor,
      ),
    );
  }
}
