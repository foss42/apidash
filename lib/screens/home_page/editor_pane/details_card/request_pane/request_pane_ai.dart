import 'package:apidash/consts.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/ai_request_contents/aireq_authorization.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/ai_request_contents/aireq_configs.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/ai_request_contents/aireq_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'request_headers.dart';
import 'request_params.dart';
import 'request_body.dart';

class EditAIRequestPane extends ConsumerWidget {
  const EditAIRequestPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final codePaneVisible = ref.watch(codePaneVisibleStateProvider);
    final tabIndex = ref.watch(
        selectedRequestModelProvider.select((value) => value?.requestTabIndex));

    final headerLength = ref.watch(selectedRequestModelProvider
            .select((value) => value?.httpRequestModel?.headersMap.length)) ??
        0;
    final paramLength = ref.watch(selectedRequestModelProvider
            .select((value) => value?.httpRequestModel?.paramsMap.length)) ??
        0;
    final hasBody = ref.watch(selectedRequestModelProvider
            .select((value) => value?.httpRequestModel?.hasBody)) ??
        false;

    return RequestPane(
      selectedId: selectedId,
      codePaneVisible: false,
      tabIndex: tabIndex,
      onPressedCodeButton: () {
        ref.read(codePaneVisibleStateProvider.notifier).state =
            !codePaneVisible;
      },
      onTapTabBar: (index) {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(requestTabIndex: index);
      },
      showIndicators: [
        paramLength > 0,
        headerLength > 0,
        hasBody,
      ],
      tabLabels: const [
        "Prompt",
        "Authorization",
        "Configurations",
      ],
      children: const [
        AIRequestPromptSection(),
        AIRequestAuthorizationSection(),
        AIRequestConfigSection(),
      ],
    );
  }
}
