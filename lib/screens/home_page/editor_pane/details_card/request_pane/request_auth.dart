import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/providers/providers.dart';
import '../../../../common_widgets/common_widgets.dart';

class EditAuthType extends ConsumerWidget {
  final bool readOnly;

  const EditAuthType({
    super.key,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRequest = ref.read(selectedRequestModelProvider);
    if (selectedRequest == null) {
      return const SizedBox.shrink();
    }

    ref.watch(
      selectedRequestModelProvider.select((request) =>
          request?.httpRequestModel?.authModel?.type ?? APIAuthType.none),
    );
    final currentAuthData = selectedRequest.httpRequestModel?.authModel;

    return AuthPage(
      authModel: currentAuthData,
      readOnly: readOnly,
      onChangedAuthType: (newType) {
        final selectedRequest = ref.read(selectedRequestModelProvider);
        if (newType != null) {
          ref.read(collectionStateNotifierProvider.notifier).update(
                authModel: selectedRequest?.httpRequestModel?.authModel
                        ?.copyWith(type: newType) ??
                    AuthModel(type: newType),
              );
        }
      },
      updateAuthData: (model) {
        if (model == null) {
          ref.read(collectionStateNotifierProvider.notifier).update(
                authModel: AuthModel(type: APIAuthType.none),
              );
        }
        ref.read(collectionStateNotifierProvider.notifier).update(
              authModel: model,
            );
      },
    );
  }
}
