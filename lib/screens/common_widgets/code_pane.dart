import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/dashbot/dashbot.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';

final Codegen codegen = Codegen();

class CodePane extends ConsumerWidget {
  const CodePane({super.key, this.isHistoryRequest = false});

  final bool isHistoryRequest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CodegenLanguage codegenLanguage = ref.watch(
      codegenLanguageStateProvider,
    );

    final selectedHistoryRequestModel = ref.watch(
      selectedHistoryRequestModelProvider,
    );

    final selectedRequestModel = isHistoryRequest
        ? getRequestModelFromHistoryModel(selectedHistoryRequestModel!)
        : ref.watch(selectedRequestModelProvider);

    // In History, anything without native codegen is handed to DashBot.
    final apiType = selectedRequestModel?.apiType;
    if (isHistoryRequest && apiType != null && !apiType.hasNativeCodegen) {
      return CodegenUnavailable(apiType: apiType);
    }

    // TODO: Add AI Request Codegen
    if (selectedRequestModel?.apiType == APIType.ai) {
      return const ErrorMessage(message: kMsgCodegenAINotAvailable);
    }

    // TODO: Add WebSocket Codegen
    // WebSocket (and any non-http type) has no `httpRequestModel`, so guard
    // before the `.httpRequestModel!` dereference below to avoid a null-check
    // crash when viewing code for a WebSocket history entry.
    if (selectedRequestModel?.apiType == APIType.websocket ||
        (selectedRequestModel != null &&
            selectedRequestModel.httpRequestModel == null)) {
      return const ErrorMessage(message: kMsgCodegenWebSocketNotAvailable);
    }

    final defaultUriScheme = ref.watch(
      settingsProvider.select((value) => value.defaultUriScheme),
    );

    var envMap = ref.watch(availableEnvironmentVariablesStateProvider);
    var activeEnvId = ref.watch(activeEnvironmentIdStateProvider);

    final substitutedRequestModel = selectedRequestModel?.copyWith(
      httpRequestModel: substituteHttpRequestModel(
        selectedRequestModel.httpRequestModel!,
        envMap,
        activeEnvId,
      ),
    );

    final code = codegen.getCode(
      codegenLanguage,
      substitutedRequestModel!,
      defaultUriScheme,
    );

    // TODO: Add GraphQL Codegen
    if (substitutedRequestModel.apiType == APIType.graphql) {
      return const ErrorMessage(message: kMsgCodegenGraphQLNotAvailable);
    }
    if (code == null) {
      return const ErrorMessage(message: kMsgCodegenError);
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

/// History code pane for API types without native codegen: says the code
/// comes from DashBot and starts its generate-code task for that entry.
class CodegenUnavailable extends ConsumerWidget {
  const CodegenUnavailable({super.key, required this.apiType});

  final APIType apiType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDashBotEnabled = ref.watch(
      settingsProvider.select((value) => value.isDashBotEnabled),
    );
    return Padding(
      padding: kPh20v10,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SelectableText(
              apiType.codegenViaDashbotMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            if (isDashBotEnabled) ...[
              kVSpacer20,
              ADFilledButton(
                isTonal: true,
                icon: Icons.auto_awesome,
                label: kLabelGenerateCodeDashbot,
                onPressed: () {
                  ref.read(dashbotActiveRouteProvider.notifier).goToChat();
                  ref
                      .read(chatViewmodelProvider.notifier)
                      .sendTaskMessage(apiType.dashbotCodegenTask);
                  ref.read(dashbotWindowNotifierProvider.notifier).show();
                  showDashbotWindow(context, ref);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
