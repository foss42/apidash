import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'aireq_authorization.dart';
import 'aireq_configs.dart';
import 'aireq_prompt.dart';

class EditAIRequestPane extends ConsumerWidget {
  const EditAIRequestPane({
    super.key,
    this.showViewCodeButton = true,
  });

  final bool showViewCodeButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final codePaneVisible = ref.watch(codePaneVisibleStateProvider);
    final tabIndex = ref.watch(
        selectedRequestModelProvider.select((value) => value?.requestTabIndex));

    return RequestPane(
      selectedId: selectedId,
      showViewCodeButton: showViewCodeButton,
      codePaneVisible: codePaneVisible,
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
        false,
        false,
        false,
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
