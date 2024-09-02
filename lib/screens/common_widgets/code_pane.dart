import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';

final Codegen codegen = Codegen();

class CodePane extends ConsumerWidget {
  const CodePane({
    super.key,
    this.isHistoryRequest = false,
  });

  final bool isHistoryRequest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CodegenLanguage codegenLanguage =
        ref.watch(codegenLanguageStateProvider);

    final selectedHistoryRequestModel =
        ref.watch(selectedHistoryRequestModelProvider);

    final selectedRequestModel = isHistoryRequest
        ? getRequestModelFromHistoryModel(selectedHistoryRequestModel!)
        : ref.watch(selectedRequestModelProvider);
    final defaultUriScheme =
        ref.watch(settingsProvider.select((value) => value.defaultUriScheme));

    var envMap = ref.watch(availableEnvironmentVariablesStateProvider);
    var activeEnvId = ref.watch(activeEnvironmentIdStateProvider);

    final substitutedRequestModel = selectedRequestModel?.copyWith(
        httpRequestModel: substituteHttpRequestModel(
            selectedRequestModel.httpRequestModel!, envMap, activeEnvId));

    final code = codegen.getCode(
        codegenLanguage, substitutedRequestModel!, defaultUriScheme);
    if (code == null) {
      return const ErrorMessage(
        message: "An error was encountered while generating code. $kRaiseIssue",
      );
    }
    return ViewCodePane(
      code: code,
      codegenLanguage: codegenLanguage,
      onChangedCodegenLanguage: (CodegenLanguage? value) {
        ref.read(codegenLanguageStateProvider.notifier).state = value!;
      },
    );
  }
}
