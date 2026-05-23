import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/models/protocols/websocket_model.dart';
import 'package:apidash/models/protocols/mqtt_model.dart';
import 'package:apidash/models/protocols/grpc_model.dart';

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
                    APIType.websocket ||
                    APIType.mqtt ||
                    APIType.grpc =>
                      kSizedBoxEmpty,

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
                    APIType.websocket ||
                    APIType.mqtt ||
                    APIType.grpc =>
                      kSizedBoxEmpty,

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
    final apiType = ref.watch(
        selectedRequestModelProvider.select((value) => value?.apiType));
    ref.watch(selectedRequestModelProvider
        .select((value) => value?.aiRequestModel?.url));
    ref.watch(selectedRequestModelProvider
        .select((value) => value?.httpRequestModel?.url));
    ref.watch(selectedRequestModelProvider
        .select((value) => value?.protocolModel));
    final requestModel = ref
        .read(collectionStateNotifierProvider.notifier)
        .getRequestModel(selectedId!)!;

    String? urlValue;
    switch (requestModel.apiType) {
      case APIType.ai:
        urlValue = requestModel.aiRequestModel?.url;
        break;
      case APIType.websocket:
        final pm = requestModel.protocolModel;
        urlValue = pm is WebSocketRequestModel ? pm.url : null;
        break;
      case APIType.mqtt:
        final pm = requestModel.protocolModel;
        urlValue = pm is MQTTRequestModel ? pm.brokerUrl : null;
        break;
      case APIType.grpc:
        final pm = requestModel.protocolModel;
        if (pm is GrpcRequestModel) {
          urlValue = pm.port == 50051 ? pm.host : '${pm.host}:${pm.port}';
        }
        break;
      default:
        urlValue = requestModel.httpRequestModel?.url;
    }

    return EnvURLField(
      // ValueKey encodes both the selected request and its protocol type.
      // This forces Flutter to discard the old widget and create a fresh one
      // whenever the user switches between requests or between protocol types,
      // ensuring that `initialValue` is re-applied correctly instead of being
      // stuck on the value from the previous protocol's form state.
      key: ValueKey('${selectedId}_${apiType?.name}'),
      selectedId: selectedId,
      initialValue: urlValue,
      hintText: switch (requestModel.apiType) {
        APIType.websocket => kHintTextWsCard,
        APIType.mqtt => kHintTextMqttCard,
        APIType.grpc => kHintTextGrpcCard,
        _ => kHintTextUrlCard,
      },
      onChanged: (value) {
        if (requestModel.apiType == APIType.ai) {
          ref.read(collectionStateNotifierProvider.notifier).update(
              aiRequestModel:
                  requestModel.aiRequestModel?.copyWith(url: value));
        } else if (requestModel.apiType == APIType.websocket) {
          final protocolModel = requestModel.protocolModel;
          if (protocolModel is WebSocketRequestModel) {
            ref.read(collectionStateNotifierProvider.notifier).update(
                protocolModel: protocolModel.copyWith(url: value));
          }
        } else if (requestModel.apiType == APIType.mqtt) {
          final protocolModel = requestModel.protocolModel;
          if (protocolModel is MQTTRequestModel) {
            ref.read(collectionStateNotifierProvider.notifier).update(
                protocolModel: protocolModel.copyWith(brokerUrl: value));
          }
        } else if (requestModel.apiType == APIType.grpc) {
          String host = value.trim();
          int port = 50051;
          if (host.contains(':')) {
            final parts = host.split(':');
            host = parts[0].trim();
            final p = int.tryParse(parts[1].trim());
            if (p != null) port = p;
          }
          final protocolModel = requestModel.protocolModel;
          if (protocolModel is GrpcRequestModel) {
            ref.read(collectionStateNotifierProvider.notifier).update(
                protocolModel: protocolModel.copyWith(host: host, port: port));
          }
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
