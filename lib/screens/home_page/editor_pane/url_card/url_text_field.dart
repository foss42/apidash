import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import '../../../common_widgets/common_widgets.dart';

class URLTextField extends ConsumerWidget {
  const URLTextField({super.key});
  //TODO : A better way to use hintText for each protocol
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final apiType = ref.watch(
      selectedRequestModelProvider.select((value) => value?.apiType),
    );
    ref.watch(
      selectedRequestModelProvider.select(
        (value) => value?.aiRequestModel?.url,
      ),
    );
    ref.watch(
      selectedRequestModelProvider.select(
        (value) => value?.httpRequestModel?.url,
      ),
    );
    ref.watch(
      selectedRequestModelProvider.select(
        (value) => value?.wsRequestModel?.url,
      ),
    );
    final requestModel = ref
        .read(collectionStateNotifierProvider.notifier)
        .getRequestModel(selectedId!)!;

    return EnvURLField(
      // ValueKey encodes both the selected request and its protocol type.
      // This forces Flutter to discard the old widget and create a fresh one
      // whenever the user switches between requests or between protocol types,
      // ensuring that `initialValue` is re-applied correctly instead of being
      // stuck on the value from the previous protocol's form state.
      key: ValueKey('${selectedId}_${apiType?.name}'),
      selectedId: selectedId,
      initialValue: switch (requestModel.apiType) {
        APIType.ai => requestModel.aiRequestModel?.url,
        APIType.websocket => requestModel.wsRequestModel?.url,
        _ => requestModel.httpRequestModel?.url,
      },
      hintText: switch (requestModel.apiType) {
        APIType.websocket => kHintTextWsCard,
        _ => kHintTextUrlCard,
      },
      onChanged: (value) {
        // Re-read the latest model here: the build-time `requestModel` goes
        // stale when non-watched fields change (e.g. a live WS appending to
        // messageHistory), and writing a stale sub-model back clobbers them.
        final notifier = ref.read(collectionStateNotifierProvider.notifier);
        final latestModel = ref.read(selectedRequestModelProvider);
        if (latestModel == null) return;
        if (latestModel.apiType == APIType.ai) {
          notifier.update(
            aiRequestModel: latestModel.aiRequestModel?.copyWith(url: value),
          );
        } else if (latestModel.apiType == APIType.websocket) {
          final wsModel = latestModel.wsRequestModel;
          if (wsModel != null) {
            notifier.update(wsRequestModel: wsModel.copyWith(url: value));
          }
        } else {
          notifier.update(url: value);
        }
      },
      onFieldSubmitted: (value) {
        ref.read(collectionStateNotifierProvider.notifier).sendRequest();
      },
      onCurlDetected: (curlText) async {
        final messenger = ScaffoldMessenger.maybeOf(context);
        final url = ref
            .read(collectionStateNotifierProvider.notifier)
            .applyCurlToSelectedRequest(curlText);
        if (url != null) {
          messenger?.showSnackBar(getSnackBar(kMsgCurlPasteApplied));
          return url;
        }
        messenger?.showSnackBar(
          getSnackBar(kMsgCurlPasteFailed, small: false),
        );
        return null;
      },
    );
  }
}
