import 'package:apidash_core/apidash_core.dart';
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
    ref.watch(
      selectedRequestModelProvider.select(
        (value) => value?.mqttRequestModel?.brokerUrl,
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
        APIType.mqtt => requestModel.mqttRequestModel?.brokerUrl,
        _ => requestModel.httpRequestModel?.url,
      },
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
            aiRequestModel: latestModel.aiRequestModel?.copyWith(url: value),
          );
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
              final uriStr =
                  brokerUrl.contains('://') ? brokerUrl : 'mqtt://$brokerUrl';
              final uri = Uri.parse(uriStr);
              if (uri.hasPort && uri.port > 0 && uri.port <= 65535) {
                port = uri.port;
                if (uri.scheme == 'mqtts' || uri.scheme == 'wss') useTLS = true;
                if (uri.scheme == 'mqtt' || uri.scheme == 'ws') useTLS = false;
                if (uri.scheme == 'ws' || uri.scheme == 'wss') {
                  useWebSocket = true;
                }
                if (uri.scheme == 'mqtt' || uri.scheme == 'mqtts') {
                  useWebSocket = false;
                }

                // Safely strip port if it was pasted (length jumped by >1 char).
                if ((value.length - mqttModel.brokerUrl.length).abs() > 1) {
                  brokerUrl = brokerUrl.replaceFirst(':${uri.port}', '');
                }
              }
            } catch (_) {}

            notifier.update(
              mqttRequestModel: mqttModel.copyWith(
                brokerUrl: brokerUrl,
                port: port,
                useTLS: useTLS,
                useWebSocket: useWebSocket,
              ),
            );
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
