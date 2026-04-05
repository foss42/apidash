import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
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
                    APIType.grpc => kSizedBoxEmpty,
                    APIType.mqtt => const MqttVersionDropdown(),
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
                  if (apiType == APIType.mqtt) ...[
                    kHSpacer10,
                    const SizedBox(
                      width: 120,
                      child: MqttClientIdField(),
                    ),
                  ],
                  if (apiType == APIType.grpc) ...[
                    kHSpacer10,
                    const SizedBox(
                      width: 80,
                      child: GrpcPortField(),
                    ),
                  ],
                ],
              )
            : Row(
                children: [
                  switch (apiType) {
                    APIType.rest => const DropdownButtonHTTPMethod(),
                    APIType.graphql => kSizedBoxEmpty,
                    APIType.ai => const AIModelSelector(),
                    APIType.grpc => kSizedBoxEmpty,
                    APIType.mqtt => const MqttVersionDropdown(),
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
                  if (apiType == APIType.mqtt) ...[
                    kHSpacer10,
                    const SizedBox(
                      width: 150,
                      child: MqttClientIdField(),
                    ),
                  ],
                  if (apiType == APIType.grpc) ...[
                    kHSpacer10,
                    const SizedBox(
                      width: 80,
                      child: GrpcPortField(),
                    ),
                  ],
                  kHSpacer20,
                  SizedBox(
                    height: 36,
                    child: apiType == APIType.mqtt
                        ? const MqttConnectButton()
                        : apiType == APIType.websocket
                            ? const WsConnectButton()
                            : apiType == APIType.grpc
                                ? const GrpcConnectButton()
                                : const SendRequestButton(),
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
    ref.watch(selectedRequestModelProvider
        .select((value) => value?.mqttRequestModel?.url));
    ref.watch(selectedRequestModelProvider
        .select((value) => value?.grpcRequestModel?.host));
    final requestModel = ref
        .read(collectionStateNotifierProvider.notifier)
        .getRequestModel(selectedId!)!;
    return EnvURLField(
      selectedId: selectedId,
      initialValue: switch (requestModel.apiType) {
        APIType.ai => requestModel.aiRequestModel?.url,
        APIType.mqtt => requestModel.mqttRequestModel?.url,
        APIType.grpc => requestModel.grpcRequestModel?.host,
        _ => requestModel.httpRequestModel?.url,
      },
      onChanged: (value) {
        // Always read the LATEST model to avoid reverting concurrent field edits
        // (e.g. clientId field changing the model between our last build and now).
        final current = ref
            .read(collectionStateNotifierProvider.notifier)
            .getRequestModel(selectedId!);
        if (current == null) return;
        if (current.apiType == APIType.ai) {
          ref.read(collectionStateNotifierProvider.notifier).update(
              aiRequestModel:
                  current.aiRequestModel?.copyWith(url: value));
        } else if (current.apiType == APIType.mqtt) {
          ref.read(collectionStateNotifierProvider.notifier).update(
              mqttRequestModel:
                  current.mqttRequestModel?.copyWith(url: value));
        } else if (current.apiType == APIType.grpc) {
          ref.read(collectionStateNotifierProvider.notifier).update(
              grpcRequestModel:
                  current.grpcRequestModel?.copyWith(host: value));
        } else {
          ref.read(collectionStateNotifierProvider.notifier).update(url: value);
        }
      },
      onFieldSubmitted: (value) {
        if (requestModel.apiType == APIType.mqtt) {
          ref.read(collectionStateNotifierProvider.notifier).connectMqtt();
        } else if (requestModel.apiType == APIType.grpc) {
          ref.read(collectionStateNotifierProvider.notifier).connectGrpc();
        } else {
          ref.read(collectionStateNotifierProvider.notifier).sendRequest();
        }
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

class MqttVersionDropdown extends ConsumerWidget {
  const MqttVersionDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mqttVersion = ref.watch(selectedRequestModelProvider
        .select((value) => value?.mqttRequestModel?.mqttVersion));
    return ADPopupMenu<MqttVersion>(
      tooltip: kLabelMqttVersion,
      width: 80,
      value: mqttVersion?.label ?? MqttVersion.v311.label,
      values: MqttVersion.values.map((e) => (e, e.label)),
      onChanged: (MqttVersion? value) {
        if (value == MqttVersion.v5) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(kMsgMqttV5NotSupported)),
          );
          return;
        }
        final requestModel = ref.read(selectedRequestModelProvider);
        ref.read(collectionStateNotifierProvider.notifier).update(
              mqttRequestModel:
                  requestModel?.mqttRequestModel?.copyWith(mqttVersion: value!),
            );
      },
      isOutlined: true,
    );
  }
}

class MqttClientIdField extends ConsumerWidget {
  const MqttClientIdField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    ref.watch(selectedRequestModelProvider
        .select((value) => value?.mqttRequestModel?.clientId));
    final requestModel = ref
        .read(collectionStateNotifierProvider.notifier)
        .getRequestModel(selectedId!);
    return EnvironmentTriggerField(
      keyId: "mqtt-clientid-$selectedId",
      initialValue: requestModel?.mqttRequestModel?.clientId ?? "",
      style: kCodeStyle,
      decoration: InputDecoration(
        hintText: kHintMqttClientId,
        hintStyle: kCodeStyle.copyWith(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        border: InputBorder.none,
      ),
      onChanged: (value) {
        // Read the latest model so we don't revert URL/other fields changed
        // between this widget's last build and when the user typed here.
        final latest = ref
            .read(collectionStateNotifierProvider.notifier)
            .getRequestModel(selectedId!);
        ref.read(collectionStateNotifierProvider.notifier).update(
              mqttRequestModel:
                  latest?.mqttRequestModel?.copyWith(clientId: value),
            );
      },
      optionsWidthFactor: 1,
    );
  }
}

class MqttConnectButton extends ConsumerWidget {
  const MqttConnectButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    if (selectedId == null) return kSizedBoxEmpty;

    final connectionInfo = ref.watch(mqttConnectionProvider(selectedId));
    final isConnected =
        connectionInfo.state == MqttConnectionState.connected;
    final isConnecting =
        connectionInfo.state == MqttConnectionState.connecting;

    return ADFilledButton(
      isTonal: isConnected,
      items: [
        Text(
          isConnecting
              ? kLabelMqttConnecting
              : isConnected
                  ? kLabelDisconnect
                  : kLabelConnect,
          style: kTextStyleButton,
        ),
        kHSpacer6,
        Icon(
          size: 16,
          isConnected ? Icons.link_off : Icons.link,
        ),
      ],
      onPressed: isConnecting
          ? null
          : () {
              if (isConnected) {
                ref
                    .read(collectionStateNotifierProvider.notifier)
                    .disconnectMqtt();
              } else {
                ref
                    .read(collectionStateNotifierProvider.notifier)
                    .connectMqtt();
              }
            },
    );
  }
}

class WsConnectButton extends ConsumerWidget {
  const WsConnectButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    if (selectedId == null) return const SizedBox.shrink();

    final wsState = ref.watch(wsStateProvider(selectedId));
    final isConnected = wsState.status == WsConnectionStatus.connected;
    final isConnecting = wsState.status == WsConnectionStatus.connecting;

    return ADFilledButton(
      isTonal: isConnected,
      items: [
        Text(
          isConnecting
              ? kLabelWsConnecting
              : isConnected
                  ? kLabelDisconnect
                  : kLabelConnect,
          style: kTextStyleButton,
        ),
        kHSpacer6,
        Icon(
          size: 16,
          isConnected ? Icons.link_off : Icons.link,
        ),
      ],
      onPressed: isConnecting
          ? null
          : () {
              if (isConnected) {
                ref.read(wsStateProvider(selectedId).notifier).disconnect();
              } else {
                final url = ref
                    .read(collectionStateNotifierProvider.notifier)
                    .getRequestModel(selectedId)
                    ?.httpRequestModel
                    ?.url;
                ref
                    .read(wsStateProvider(selectedId).notifier)
                    .connect(url ?? '');
              }
            },
    );
  }
}

class GrpcPortField extends ConsumerWidget {
  const GrpcPortField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    ref.watch(selectedRequestModelProvider
        .select((value) => value?.grpcRequestModel?.port));
    final requestModel = ref
        .read(collectionStateNotifierProvider.notifier)
        .getRequestModel(selectedId!);
    final port = requestModel?.grpcRequestModel?.port ?? 50051;
    return TextFormField(
      key: Key("grpc-port-$selectedId"),
      initialValue: port.toString(),
      style: kCodeStyle,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: kHintGrpcPort,
        hintStyle: kCodeStyle.copyWith(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        border: InputBorder.none,
      ),
      onChanged: (value) {
        final p = int.tryParse(value);
        if (p != null) {
          // Always read the CURRENT model inline to avoid stale closure.
          final currentModel = ref
              .read(collectionStateNotifierProvider.notifier)
              .getRequestModel(selectedId);
          ref.read(collectionStateNotifierProvider.notifier).update(
                grpcRequestModel:
                    currentModel?.grpcRequestModel?.copyWith(port: p),
              );
        }
      },
    );
  }
}

class GrpcConnectButton extends ConsumerWidget {
  const GrpcConnectButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    if (selectedId == null) return kSizedBoxEmpty;

    final connectionInfo = ref.watch(grpcConnectionProvider(selectedId));
    final isConnected =
        connectionInfo.state == GrpcConnectionState.connected;
    final isConnecting =
        connectionInfo.state == GrpcConnectionState.connecting;

    return ADFilledButton(
      isTonal: isConnected,
      items: [
        Text(
          isConnecting
              ? kLabelGrpcConnecting
              : isConnected
                  ? kLabelDisconnect
                  : kLabelConnect,
          style: kTextStyleButton,
        ),
        kHSpacer6,
        Icon(
          size: 16,
          isConnected ? Icons.link_off : Icons.link,
        ),
      ],
      onPressed: isConnecting
          ? null
          : () {
              if (isConnected) {
                ref
                    .read(collectionStateNotifierProvider.notifier)
                    .disconnectGrpc();
              } else {
                ref
                    .read(collectionStateNotifierProvider.notifier)
                    .connectGrpc();
              }
            },
    );
  }
}
