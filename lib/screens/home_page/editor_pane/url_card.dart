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
                    APIType.mqtt => const MqttVersionDropdown(),
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
                ],
              )
            : Row(
                children: [
                  switch (apiType) {
                    APIType.rest => const DropdownButtonHTTPMethod(),
                    APIType.graphql => kSizedBoxEmpty,
                    APIType.ai => const AIModelSelector(),
                    APIType.mqtt => const MqttVersionDropdown(),
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
                  kHSpacer20,
                  SizedBox(
                    height: 36,
                    child: apiType == APIType.mqtt
                        ? const MqttConnectButton()
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
    final requestModel = ref
        .read(collectionStateNotifierProvider.notifier)
        .getRequestModel(selectedId!)!;
    return EnvURLField(
      selectedId: selectedId,
      initialValue: switch (requestModel.apiType) {
        APIType.ai => requestModel.aiRequestModel?.url,
        APIType.mqtt => requestModel.mqttRequestModel?.url,
        _ => requestModel.httpRequestModel?.url,
      },
      onChanged: (value) {
        if (requestModel.apiType == APIType.ai) {
          ref.read(collectionStateNotifierProvider.notifier).update(
              aiRequestModel:
                  requestModel.aiRequestModel?.copyWith(url: value));
        } else if (requestModel.apiType == APIType.mqtt) {
          ref.read(collectionStateNotifierProvider.notifier).update(
              mqttRequestModel:
                  requestModel.mqttRequestModel?.copyWith(url: value));
        } else {
          ref.read(collectionStateNotifierProvider.notifier).update(url: value);
        }
      },
      onFieldSubmitted: (value) {
        if (requestModel.apiType == APIType.mqtt) {
          ref.read(collectionStateNotifierProvider.notifier).connectMqtt();
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
        ref.read(collectionStateNotifierProvider.notifier).update(
              mqttRequestModel:
                  requestModel?.mqttRequestModel?.copyWith(clientId: value),
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
    );
  }
}
