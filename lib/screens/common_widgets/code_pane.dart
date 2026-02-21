import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/providers/providers.dart';
import 'package:apidash/dashbot/utils/show_dashbot.dart';

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

    // TODO: Add AI Request Codegen
    if (selectedRequestModel?.apiType == APIType.ai) {
      return Padding(
        padding: kPh20v10,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Code generation for AI API calls is available via DashBot.",
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              kVSpacer20,
              FilledButton.icon(
                onPressed: () async {
                  showDashbotWindow(context, ref);
                  await Future.delayed(const Duration(milliseconds: 100));
                  ref.read(dashbotActiveRouteProvider.notifier).goToChat();
                  ref
                      .read(chatViewmodelProvider.notifier)
                      .sendTaskMessage(ChatMessageType.generateCode);
                },
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Generate Code with DashBot'),
              ),
            ],
          ),
        ),
      );
    }

    final defaultUriScheme =
        ref.watch(settingsProvider.select((value) => value.defaultUriScheme));

    var envMap = ref.watch(availableEnvironmentVariablesStateProvider);
    var activeEnvId = ref.watch(activeEnvironmentIdStateProvider);

    final substitutedRequestModel = selectedRequestModel?.copyWith(
        httpRequestModel: substituteHttpRequestModel(
            selectedRequestModel.httpRequestModel!, envMap, activeEnvId));

    final code = codegen.getCode(
        codegenLanguage, substitutedRequestModel!, defaultUriScheme);

    // TODO: Add GraphQL Codegen
    if (substitutedRequestModel.apiType == APIType.graphql) {
      return const ErrorMessage(
        message: "Code generation for GraphQL is currently not available.",
      );
    }
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
