import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:better_networking/better_networking.dart';
import 'package:apidash/providers/providers.dart';
import '../../common_widgets/auth/auth_page.dart';

class EnvironmentAuthPane extends ConsumerWidget {
  const EnvironmentAuthPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final environmentModel = ref.watch(selectedEnvironmentModelProvider);
    final authModel = environmentModel?.authModel;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Environment Authentication',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Configure authentication for all requests in this environment. Requests without authentication will inherit these credentials.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            AuthPage(
              authModel: authModel ?? const AuthModel(type: APIAuthType.none),
              onChangedAuthType: (newType) {
                if (environmentModel != null) {
                  ref
                      .read(environmentsStateNotifierProvider.notifier)
                      .updateEnvironment(
                        environmentModel.id,
                        authModel: AuthModel(type: newType!),
                      );
                }
              },
              updateAuthData: (newAuthModel) {
                if (environmentModel != null && newAuthModel != null) {
                  ref
                      .read(environmentsStateNotifierProvider.notifier)
                      .updateEnvironment(
                        environmentModel.id,
                        authModel: newAuthModel,
                      );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
