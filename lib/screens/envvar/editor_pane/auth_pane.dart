import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import '../../common_widgets/common_widgets.dart';

class EditEnvironmentAuth extends ConsumerWidget {
  const EditEnvironmentAuth({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedEnvironmentIdStateProvider);
    final selectedEnvironment = ref.watch(selectedEnvironmentModelProvider);
    final currentAuthData = selectedEnvironment?.authModel;

    return AuthPage(
      authModel: currentAuthData,
      readOnly: false,
      onChangedAuthType: (newType) {
        if (newType != null) {
          ref.read(environmentsStateNotifierProvider.notifier).updateEnvironment(
                selectedId!,
                authModel: currentAuthData?.copyWith(type: newType) ??
                    AuthModel(type: newType),
              );
        }
      },
      updateAuthData: (model) {
        if (model == null) {
          ref.read(environmentsStateNotifierProvider.notifier).updateEnvironment(
                selectedId!,
                authModel: AuthModel(type: APIAuthType.none),
              );
        } else {
          ref.read(environmentsStateNotifierProvider.notifier).updateEnvironment(
                selectedId!,
                authModel: model,
              );
        }
      },
    );
  }
}
