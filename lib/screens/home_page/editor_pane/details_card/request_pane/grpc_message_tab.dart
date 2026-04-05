import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';

class GrpcMessageTab extends ConsumerWidget {
  const GrpcMessageTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    if (selectedId == null) return kSizedBoxEmpty;

    final darkMode = ref.watch(settingsProvider.select(
      (value) => value.isDark,
    ));

    return Padding(
      padding: kPt5o10,
      child: JsonTextFieldEditor(
        key: Key("$selectedId-grpc-json-body"),
        fieldKey: "$selectedId-grpc-json-body-editor-$darkMode",
        isDark: darkMode,
        initialValue: ref.read(grpcRequestBodyProvider(selectedId)),
        onChanged: (String value) {
          ref
              .read(grpcRequestBodyProvider(selectedId).notifier)
              .state = value;
        },
        hintText: kHintGrpcMessageBody,
      ),
    );
  }
}
