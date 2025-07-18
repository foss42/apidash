import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/models/models.dart';
import '../../common_widgets/common_widgets.dart';
import '../../../models/mqtt_request_model.dart';
import '../../../services/mqtt_service.dart' show MQTTConnectionState;

class EditorPaneRequestURLCard extends ConsumerWidget {
  const EditorPaneRequestURLCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectedIdStateProvider);
    final selectedRequestModel = ref.watch(selectedRequestModelProvider);
    final apiType = ref
        .watch(selectedRequestModelProvider.select((value) => value?.apiType));
    final mqttModel = selectedRequestModel?.mqttRequestModel;
    final mqttState = selectedRequestModel?.mqttConnectionState;
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
        child: Row(
          children: [
            switch (apiType) {
              APIType.rest => const DropdownButtonHTTPMethod(),
              _ => const SizedBox.shrink(),
            },
            if (apiType == APIType.rest) kHSpacer5,
            Expanded(
              child: switch (apiType) {
                APIType.mqtt => EnvURLField(
                  selectedId: ref.watch(selectedIdStateProvider)!,
                  initialValue: mqttModel?.brokerUrl,
                  onChanged: (value) {
                    ref.read(collectionStateNotifierProvider.notifier).updateMQTTState(
                      id: ref.watch(selectedIdStateProvider),
                      mqttRequestModel: mqttModel!.copyWith(brokerUrl: value),
                    );
                  },
                  onFieldSubmitted: (value) {
                    ref.read(collectionStateNotifierProvider.notifier).updateMQTTState(
                      id: ref.watch(selectedIdStateProvider),
                      mqttRequestModel: mqttModel!.copyWith(brokerUrl: value),
                    );
                    ref.read(collectionStateNotifierProvider.notifier).sendRequest();
                  },
                  focusNode: null,
                  decoration: const InputDecoration(
                    hintText: 'Broker URL',
                    labelText: 'Broker URL',
                    border: InputBorder.none,
                  ),
                ),
                _ => EnvURLField(
                  selectedId: ref.watch(selectedIdStateProvider)!,
                  initialValue: ref
                      .read(collectionStateNotifierProvider.notifier)
                      .getRequestModel(ref.watch(selectedIdStateProvider)!)
                      ?.httpRequestModel
                      ?.url,
                  onChanged: (value) {
                    ref.read(collectionStateNotifierProvider.notifier).update(url: value);
                  },
                  onFieldSubmitted: (value) {
                    ref.read(collectionStateNotifierProvider.notifier).sendRequest();
                  },
                  focusNode: null,
                ),
              },
            ),
            if (apiType == APIType.mqtt && mqttModel != null) ...[
              kHSpacer20,
              SizedBox(
                width: 220,
                child: Row(
                  children: [
                    SizedBox(
                      width: 70,
                      child: TextField(
                        controller: TextEditingController(text: mqttModel.port.toString()),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Port',
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        ),
                        onChanged: (val) {
                          final port = int.tryParse(val) ?? mqttModel.port;
                          ref.read(collectionStateNotifierProvider.notifier).updateMQTTState(
                            id: ref.watch(selectedIdStateProvider),
                            mqttRequestModel: mqttModel.copyWith(port: port),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: TextEditingController(text: mqttModel.clientId),
                        decoration: const InputDecoration(
                          labelText: 'Client ID',
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        ),
                        onChanged: (val) {
                          ref.read(collectionStateNotifierProvider.notifier).updateMQTTState(
                            id: ref.watch(selectedIdStateProvider),
                            mqttRequestModel: mqttModel.copyWith(clientId: val),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
            kHSpacer20,
            const SizedBox(
              height: 36,
              child: SendRequestButton(),
            ),
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
    return EnvURLField(
      selectedId: selectedId!,
      initialValue: ref
          .read(collectionStateNotifierProvider.notifier)
          .getRequestModel(selectedId)
          ?.httpRequestModel
          ?.url,
      onChanged: (value) {
        ref.read(collectionStateNotifierProvider.notifier).update(url: value);
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

    return SendButton(
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
