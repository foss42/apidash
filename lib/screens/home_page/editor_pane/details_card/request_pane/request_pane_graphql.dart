import 'package:apidash/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'request_auth.dart';
import 'request_headers.dart';
import 'request_body.dart';
import 'request_scripts.dart';

class EditGraphQLRequestPane extends ConsumerWidget {
  const EditGraphQLRequestPane({
    super.key,
    this.showViewCodeButton = true,
  });

  final bool showViewCodeButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final tabIndex = ref.watch(
        selectedRequestModelProvider.select((value) => value?.requestTabIndex));
    final codePaneVisible = ref.watch(codePaneVisibleStateProvider);
    final headerLength = ref.watch(selectedRequestModelProvider
            .select((value) => value?.httpRequestModel?.headersMap.length)) ??
        0;
    final hasQuery = ref.watch(selectedRequestModelProvider
            .select((value) => value?.httpRequestModel?.hasQuery)) ??
        false;

    final scriptsLength = ref.watch(selectedRequestModelProvider
            .select((value) => value?.preRequestScript?.length)) ??
        ref.watch(selectedRequestModelProvider
            .select((value) => value?.postRequestScript?.length)) ??
        0;

    final hasAuth = ref.watch(selectedRequestModelProvider.select((value) =>
        value?.httpRequestModel?.authModel?.type != APIAuthType.none));

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
        headerLength > 0,
        hasAuth,
        hasQuery,
        scriptsLength > 0,
      ],
      tabLabels: const [
        kLabelHeaders,
        kLabelAuth,
        kLabelQuery,
        kLabelScripts,
      ],
      children: const [
        EditRequestHeaders(),
        EditAuthType(),
        EditRequestBody(),
        EditRequestScripts(),
      ],
    );
  }
}
