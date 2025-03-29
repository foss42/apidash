import 'package:apidash/consts.dart';
import 'package:apidash/providers/auth_providers.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/request_auth.dart';
import 'package:apidash_core/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'request_headers.dart';
import 'request_body.dart';

class EditGraphQLRequestPane extends ConsumerWidget {
  const EditGraphQLRequestPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    var tabIndex = ref.watch(
        selectedRequestModelProvider.select((value) => value?.requestTabIndex));
    final codePaneVisible = ref.watch(codePaneVisibleStateProvider);
    final headerLength = ref.watch(selectedRequestModelProvider
            .select((value) => value?.httpRequestModel?.headersMap.length)) ??
        0;
    final hasAuth = ref.watch(authTypeProvider) != AuthType.none &&
        (ref.watch(authDataProvider)?.isNotEmpty ?? false);
    final hasQuery = ref.watch(selectedRequestModelProvider
            .select((value) => value?.httpRequestModel?.hasQuery)) ??
        false;
    if (tabIndex >= 2) {
      tabIndex = 0;
    }
    return RequestPane(
      selectedId: selectedId,
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
      ],
      tabLabels: const [
        kLabelHeaders,
        kLabelAuth,
        kLabelQuery,
      ],
      children: const [
        EditRequestHeaders(),
        EditRequestAuth(),
        EditRequestBody(),
      ],
    );
  }
}
