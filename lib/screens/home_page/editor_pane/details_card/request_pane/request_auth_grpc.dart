import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/providers/providers.dart';
import '../../../../common_widgets/common_widgets.dart';

/// gRPC Auth editor. Reuses the same [AuthPage] widget REST/GraphQL use, but
/// binds it to the request's `grpcRequestModel.authModel` (gRPC requests have
/// no `httpRequestModel`, so [EditAuthType] cannot be reused directly).
class EditGrpcRequestAuth extends ConsumerWidget {
  const EditGrpcRequestAuth({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grpcModel = ref.watch(
      selectedRequestModelProvider.select((r) => r?.grpcRequestModel),
    );
    if (grpcModel == null) {
      return const SizedBox.shrink();
    }

    return AuthPage(
      authModel: grpcModel.authModel,
      onChangedAuthType: (newType) {
        if (newType == null) return;
        final grpc = ref.read(selectedRequestModelProvider)?.grpcRequestModel;
        if (grpc == null) return;
        ref.read(collectionStateNotifierProvider.notifier).update(
              grpcRequestModel: grpc.copyWith(
                authModel:
                    (grpc.authModel ?? const AuthModel(type: APIAuthType.none))
                        .copyWith(type: newType),
              ),
            );
      },
      updateAuthData: (model) {
        final grpc = ref.read(selectedRequestModelProvider)?.grpcRequestModel;
        if (grpc == null) return;
        ref.read(collectionStateNotifierProvider.notifier).update(
              grpcRequestModel: grpc.copyWith(
                authModel: model ?? const AuthModel(type: APIAuthType.none),
              ),
            );
      },
    );
  }
}
