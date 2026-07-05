import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/models/models.dart';
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
                    APIType.mqtt => const DropdownButtonMQTTVersion(),
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
                    APIType.mqtt => const DropdownButtonMQTTVersion(),
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

/// MQTT protocol-version selector shown inline in the URL card, in the slot
/// otherwise used by the HTTP method dropdown. One click switches the whole
/// request between MQTT 3.1.1 and MQTT 5.0 (which gates the v5-only fields in
/// the request pane via progressive disclosure).
class DropdownButtonMQTTVersion extends ConsumerWidget {
  const DropdownButtonMQTTVersion({super.key});

  static const _options = <MQTTVersion, String>{
    MQTTVersion.v3_1_1: 'MQTT 3.1.1',
    MQTTVersion.v5: 'MQTT 5.0',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final version = ref.watch(selectedRequestModelProvider
        .select((value) => value?.mqttRequestModel?.version));
    // The model also allows a legacy `v3`; collapse it onto `v3_1_1` for the
    // selector (we only surface the two first-class choices to the user).
    final effective =
        version == MQTTVersion.v5 ? MQTTVersion.v5 : MQTTVersion.v3_1_1;
    // Use the same design-system dropdown as the HTTP method (GET/POST) selector
    // so it looks identical and sits in the same URL-card slot.
    return ADDropdownButton<MQTTVersion>(
      value: effective,
      values: _options.entries.map((e) => (e.key, e.value)),
      dropdownMenuItemPadding:
          EdgeInsets.only(left: context.isMediumWindow ? 8 : 16),
      onChanged: (value) {
        if (value == null) return;
        final mqttModel =
            ref.read(selectedRequestModelProvider)?.mqttRequestModel;
        if (mqttModel == null) return;
        ref.read(collectionStateNotifierProvider.notifier).update(
              mqttRequestModel: mqttModel.copyWith(version: value),
            );
      },
    );
  }
}

class URLTextField extends ConsumerWidget {
  const URLTextField({
    super.key,
  });
//TODO : A better way to use hintText for each protocol 
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
        .select((value) => value?.wsRequestModel?.url));
    ref.watch(selectedRequestModelProvider
        .select((value) => value?.mqttRequestModel?.brokerUrl));
    final requestModel = ref
        .read(collectionStateNotifierProvider.notifier)
        .getRequestModel(selectedId!)!;

    String? urlValue;
    switch (requestModel.apiType) {
      case APIType.ai:
        urlValue = requestModel.aiRequestModel?.url;
        break;
      case APIType.websocket:
        urlValue = requestModel.wsRequestModel?.url;
        break;
      case APIType.mqtt:
        urlValue = requestModel.mqttRequestModel?.brokerUrl;
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
        APIType.mqtt => "mqtt://...",
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
              aiRequestModel: latestModel.aiRequestModel?.copyWith(url: value));
        } else if (latestModel.apiType == APIType.websocket) {
          final wsModel = latestModel.wsRequestModel;
          if (wsModel != null) {
            notifier.update(wsRequestModel: wsModel.copyWith(url: value));
          }
        } else if (latestModel.apiType == APIType.mqtt) {
          final mqttModel = latestModel.mqttRequestModel;
          if (mqttModel != null) {
            String brokerUrl = value;
            int port = mqttModel.port;
            bool useTLS = mqttModel.useTLS;
            bool useWebSocket = mqttModel.useWebSocket;

            try {
              final uriStr = brokerUrl.contains('://') ? brokerUrl : 'mqtt://$brokerUrl';
              final uri = Uri.parse(uriStr);
              if (uri.hasPort && uri.port > 0 && uri.port <= 65535) {
                port = uri.port;
                if (uri.scheme == 'mqtts' || uri.scheme == 'wss') useTLS = true;
                if (uri.scheme == 'mqtt' || uri.scheme == 'ws') useTLS = false;
                if (uri.scheme == 'ws' || uri.scheme == 'wss') useWebSocket = true;
                if (uri.scheme == 'mqtt' || uri.scheme == 'mqtts') useWebSocket = false;

                // Safely strip port if it was pasted (length jumped by >1 character)
                if ((value.length - mqttModel.brokerUrl.length).abs() > 1) {
                  brokerUrl = brokerUrl.replaceFirst(':${uri.port}', '');
                }
              }
            } catch (_) {}

            ref.read(collectionStateNotifierProvider.notifier).update(
                mqttRequestModel: mqttModel.copyWith(
                  brokerUrl: brokerUrl,
                  port: port,
                  useTLS: useTLS,
                  useWebSocket: useWebSocket,
                ));
          }
        } else {
          notifier.update(url: value);
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

    final apiType = ref.watch(
        selectedRequestModelProvider.select((value) => value?.apiType));

    return SendButton(
      isStreaming: isStreaming ?? false,
      isWorking: isWorking ?? false,
      sendLabel: apiType == APIType.websocket || apiType == APIType.mqtt ? "Connect" : kLabelSend,
      activeLabel: apiType == APIType.websocket || apiType == APIType.mqtt ? "Disconnect" : null,
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
