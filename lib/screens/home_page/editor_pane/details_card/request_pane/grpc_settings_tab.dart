import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';

class GrpcSettingsTab extends ConsumerWidget {
  const GrpcSettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    if (selectedId == null) return kSizedBoxEmpty;

    final grpcModel = ref.watch(selectedRequestModelProvider
        .select((value) => value?.grpcRequestModel));
    if (grpcModel == null) return kSizedBoxEmpty;

    return ListView(
      padding: kP8,
      children: [
        SwitchListTile(
          title: const Text(kLabelGrpcUseTls),
          subtitle: Text(
            grpcModel.useTls
                ? "Connection is encrypted (TLS/SSL)"
                : "Connection is plaintext (insecure)",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          value: grpcModel.useTls,
          onChanged: (value) {
            ref.read(collectionStateNotifierProvider.notifier).update(
                  grpcRequestModel: grpcModel.copyWith(useTls: value),
                );
          },
        ),
        const Divider(),
        SwitchListTile(
          title: const Text("Use Server Reflection"),
          subtitle: Text(
            grpcModel.useReflection
                ? "Discover services via gRPC server reflection"
                : "Load services from .pb descriptor file",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          value: grpcModel.useReflection,
          onChanged: (value) {
            ref.read(collectionStateNotifierProvider.notifier).update(
                  grpcRequestModel: grpcModel.copyWith(useReflection: value),
                );
          },
        ),
      ],
    );
  }
}
