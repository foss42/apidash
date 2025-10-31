import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'package:better_networking/better_networking.dart';
import '../common_widgets/common_widgets.dart';

class EnvironmentAuthEditor extends ConsumerWidget {
  const EnvironmentAuthEditor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final environment = ref.watch(selectedEnvironmentModelProvider);
    
    if (environment == null) {
      return const SizedBox.shrink();
    }

    final defaultAuthModel = environment.defaultAuthModel;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Default Authentication",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Set default authentication for all requests using this environment",
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          AuthPage(
            authModel: defaultAuthModel,
            readOnly: false,
            onChangedAuthType: (newType) {
              if (newType != null) {
                final updatedAuthModel = defaultAuthModel?.copyWith(type: newType) ?? 
                    AuthModel(type: newType);
                ref
                    .read(environmentsStateNotifierProvider.notifier)
                    .updateEnvironment(
                      environment.id,
                      values: environment.values,
                      defaultAuthModel: updatedAuthModel,
                    );
              }
            },
            updateAuthData: (model) {
              ref
                  .read(environmentsStateNotifierProvider.notifier)
                  .updateEnvironment(
                    environment.id,
                    values: environment.values,
                    defaultAuthModel: model,
                  );
            },
          ),
        ],
      ),
    );
  }
}