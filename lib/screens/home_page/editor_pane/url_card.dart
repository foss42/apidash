import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import '../../common_widgets/common_widgets.dart';

class EditorPaneRequestURLCard extends ConsumerWidget {
  const EditorPaneRequestURLCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectedIdStateProvider);
    final apiType = ref
        .watch(selectedRequestModelProvider.select((value) => value?.apiType));
    return Card(
      color: kColorTransparent,
      surfaceTintColor: kColorTransparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        borderRadius: kBorderRadius12,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: !context.isMediumWindow ? 20 : 6,
        ),
        child: context.isMediumWindow
            ? Row(
                children: [
                  switch (apiType) {
                    APIType.rest => const DropdownButtonHTTPMethod(),
                    APIType.graphql => kSizedBoxEmpty,
                    APIType.ai => const AIModelSelector(),
                    APIType.websocket => kSizedBoxEmpty,
                    null => kSizedBoxEmpty,
                  },
                  switch (apiType) {
                    APIType.rest => kHSpacer5,
                    _ => kHSpacer8,
                  },
                  const Expanded(
                    child: URLTextField(),
                  ),
                ],
              )
            : Row(
                children: [
                  switch (apiType) {
                    APIType.rest => const DropdownButtonHTTPMethod(),
                    APIType.graphql => kSizedBoxEmpty,
                    APIType.ai => const AIModelSelector(),
                    APIType.websocket => kSizedBoxEmpty,
                    null => kSizedBoxEmpty,
                  },
                  switch (apiType) {
                    APIType.rest => kHSpacer20,
                    _ => kHSpacer8,
                  },
                  const Expanded(
                    child: URLTextField(),
                  ),
                  kHSpacer20,
                  const SizedBox(
                    height: 36,
                    child: SendRequestButton(),
                  )
                ],
              ),
      ),
    );
  }
}

class DropdownButtonHTTPMethod extends ConsumerWidget {
  const DropdownButtonHTTPMethod({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final method = ref.watch(selectedRequestModelProvider
        .select((value) => value?.httpRequestModel?.method));
    return DropdownButtonHttpMethod(
      method: method,
      onChanged: (HTTPVerb? value) {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(method: value);
      },
    );
  }
}

class URLTextField extends ConsumerWidget {
  const URLTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    ref.watch(selectedRequestModelProvider
        .select((value) => value?.aiRequestModel?.url));
    ref.watch(selectedRequestModelProvider
        .select((value) => value?.httpRequestModel?.url));
    final requestModel = ref
        .read(collectionStateNotifierProvider.notifier)
        .getRequestModel(selectedId!)!;
    return EnvURLField(
      selectedId: selectedId,
      initialValue: switch (requestModel.apiType) {
        APIType.ai => requestModel.aiRequestModel?.url,
        APIType.websocket => requestModel.webSocketRequestModel?.url,
        _ => requestModel.httpRequestModel?.url,
      },
      onChanged: (value) {
        if (requestModel.apiType == APIType.ai) {
          ref.read(collectionStateNotifierProvider.notifier).update(
              aiRequestModel:
                  requestModel.aiRequestModel?.copyWith(url: value));
        } else if (requestModel.apiType == APIType.websocket) {
          ref.read(collectionStateNotifierProvider.notifier).update(
              webSocketRequestModel: (requestModel.webSocketRequestModel ??
                      const WebSocketRequestModel())
                  .copyWith(url: value));
        } else {
          ref.read(collectionStateNotifierProvider.notifier).update(url: value);
        }
      },
      onFieldSubmitted: (value) {
        ref.read(collectionStateNotifierProvider.notifier).sendRequest();
      },
    );
  }
}

class SendRequestButton extends ConsumerWidget {
  final Function()? onTap;
  const SendRequestButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectedIdStateProvider);
    final isWorking = ref.watch(
        selectedRequestModelProvider.select((value) => value?.isWorking));
    final isStreaming = ref.watch(
        selectedRequestModelProvider.select((value) => value?.isStreaming));
    final responseStatus = ref.watch(
        selectedRequestModelProvider.select((value) => value?.responseStatus));

    final isConnected = responseStatus == 101;
    final apiType = ref
        .watch(selectedRequestModelProvider.select((value) => value?.apiType));

    if (apiType == APIType.websocket) {
      return SendButton(
        isStreaming: isConnected,
        isWorking: isWorking ?? false,
        onTap: () {
          final id = ref.read(selectedIdStateProvider);
          if (id != null) {
            ref
                .read(collectionStateNotifierProvider.notifier)
                .connectWebSocket(id);
          }
        },
        onCancel: () {
          final id = ref.read(selectedIdStateProvider);
          if (id != null) {
            ref
                .read(collectionStateNotifierProvider.notifier)
                .disconnectWebSocket(id);
          }
        },
        text: isConnected ? "Disconnect" : "Connect",
        icon: isConnected ? Icons.stop : Icons.play_arrow,
      );
    }

    return SendButton(
      isStreaming: isStreaming ?? false,
      isWorking: isWorking ?? false,
      onTap: () {
        onTap?.call();
        ref.read(collectionStateNotifierProvider.notifier).sendRequest();
      },
      onCancel: () {
        ref.read(collectionStateNotifierProvider.notifier).cancelRequest();
      },
    );
  }
}
