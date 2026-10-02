import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart';
import '../../common_widgets/common_widgets.dart';
import 'ai_history_page.dart';
import 'ws_history_page.dart';
import 'his_scripts_tab.dart';

class HistoryRequestPane extends ConsumerWidget {
  const HistoryRequestPane({super.key, this.isCompact = false});

  final bool isCompact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedHistoryIdStateProvider);
    final codePaneVisible = ref.watch(historyCodePaneVisibleStateProvider);
    final apiType = ref.watch(
      selectedHistoryRequestModelProvider.select(
        (value) => value?.metaData.apiType,
      ),
    );

    final headers =
        ref.watch(
          selectedHistoryRequestModelProvider.select((value) {
            return switch (apiType) {
              APIType.ai => <NameValueModel>[],
              APIType.grpc => <NameValueModel>[],
              APIType.websocket => value?.wsRequestModel?.headers,
              _ => value?.httpRequestModel?.headers,
            };
          }),
        ) ??
        [];
    final headerLength = headers.length;

    final params =
        ref.watch(
          selectedHistoryRequestModelProvider.select((value) {
            return switch (apiType) {
              APIType.ai => <NameValueModel>[],
              APIType.grpc => <NameValueModel>[],
              APIType.websocket => value?.wsRequestModel?.params,
              _ => value?.httpRequestModel?.params,
            };
          }),
        ) ??
        <NameValueModel>[];
    final paramLength = params.length;

    final hasBody =
        ref.watch(
          selectedHistoryRequestModelProvider.select((value) {
            if (apiType == APIType.ai ||
                apiType == APIType.websocket ||
                apiType == APIType.mqtt ||
                apiType == APIType.grpc) {
              return false;
            }
            return value?.httpRequestModel?.hasBody;
          }),
        ) ??
        false;

    final hasQuery =
        ref.watch(
          selectedHistoryRequestModelProvider.select((value) {
            if (apiType == APIType.ai ||
                apiType == APIType.websocket ||
                apiType == APIType.mqtt ||
                apiType == APIType.grpc) {
              return false;
            }
            return value?.httpRequestModel?.hasQuery;
          }),
        ) ??
        false;

    final scriptsLength =
        ref.watch(
          selectedHistoryRequestModelProvider.select(
            (value) => value?.preRequestScript?.length,
          ),
        ) ??
        ref.watch(
          selectedHistoryRequestModelProvider.select(
            (value) => value?.postRequestScript?.length,
          ),
        ) ??
        0;

    final hasAuth = ref.watch(
      selectedHistoryRequestModelProvider.select(
        (value) => value?.authModel?.type != APIAuthType.none,
      ),
    );

    final authModel = ref.watch(
      selectedHistoryRequestModelProvider.select((value) => value?.authModel),
    );

    // MQTT read-only view data. Mirrors the WebSocket case (which shows
    // read-only RequestDataTables), but MQTT has no params/headers — instead we
    // surface the broker/connection + settings summary, the subscribed topics,
    // and the v5 user properties, all as read-only key/value tables.
    final mqttModel = ref.watch(
      selectedHistoryRequestModelProvider.select(
        (value) => value?.mqttRequestModel,
      ),
    );

    List<NameValueModel> mqttConnection = <NameValueModel>[];
    List<NameValueModel> mqttTopics = <NameValueModel>[];
    List<NameValueModel> mqttProperties = <NameValueModel>[];
    if (mqttModel != null) {
      mqttConnection = mqttModel.getConnectionData();
      for (final topic in mqttModel.subscribedTopics) {
        if (topic.name.isNotEmpty) {
          mqttTopics.add(NameValueModel(name: topic.name, value: topic.value));
        }
      }
      for (final property in mqttModel.userProperties) {
        if (property.name.isNotEmpty) {
          mqttProperties.add(
            NameValueModel(name: property.name, value: property.value),
          );
        }
      }
    }

    final grpcRequestModel = ref.watch(
      selectedHistoryRequestModelProvider.select(
        (value) => value?.grpcRequestModel,
      ),
    );

    final grpcInfo = <NameValueModel>[
      if ((grpcRequestModel?.url ?? '').isNotEmpty)
        NameValueModel(name: 'Target', value: grpcRequestModel!.url),
      if ((grpcRequestModel?.service ?? '').isNotEmpty)
        NameValueModel(name: 'Service', value: grpcRequestModel!.service!),
      if ((grpcRequestModel?.method ?? '').isNotEmpty)
        NameValueModel(name: 'Method', value: grpcRequestModel!.method!),
    ];

    final grpcMetadata = grpcRequestModel?.metadata ?? <NameValueModel>[];
    final grpcParameters = grpcRequestModel?.nvParameters ?? <NameValueModel>[];

    final codeButtonTooltip = apiType == null
        ? null
        : apiType.hasNativeCodegen
        ? kTooltipViewCode
        : apiType.codegenViaDashbotMessage;

    return switch (apiType) {
      APIType.rest => RequestPane(
        key: const Key("history-request-pane-rest"),
        codeButtonTooltip: codeButtonTooltip,
        selectedId: selectedId,
        codePaneVisible: codePaneVisible,
        onPressedCodeButton: () {
          ref.read(historyCodePaneVisibleStateProvider.notifier).state =
              !codePaneVisible;
        },
        showViewCodeButton: !isCompact,
        showIndicators: [
          paramLength > 0,
          hasAuth,
          headerLength > 0,
          hasBody,
          scriptsLength > 0,
        ],
        tabLabels: const [
          kLabelURLParams,
          kLabelAuth,
          kLabelHeaders,
          kLabelBody,
          kLabelScripts,
        ],
        children: [
          RequestDataTable(rows: params, keyName: kNameURLParam),
          AuthPage(authModel: authModel, readOnly: true),
          RequestDataTable(rows: headers, keyName: kNameHeader),
          const HisRequestBody(),
          const HistoryScriptsTab(),
        ],
      ),
      APIType.graphql => RequestPane(
        key: const Key("history-request-pane-graphql"),
        codeButtonTooltip: codeButtonTooltip,
        selectedId: selectedId,
        codePaneVisible: codePaneVisible,
        onPressedCodeButton: () {
          ref.read(historyCodePaneVisibleStateProvider.notifier).state =
              !codePaneVisible;
        },
        showViewCodeButton: !isCompact,
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
        children: [
          RequestDataTable(rows: headers, keyName: kNameHeader),
          AuthPage(authModel: authModel, readOnly: true),
          const HisRequestBody(),
          const HistoryScriptsTab(),
        ],
      ),
      APIType.ai => RequestPane(
        key: const Key("history-request-pane-ai"),
        codeButtonTooltip: codeButtonTooltip,
        selectedId: selectedId,
        codePaneVisible: codePaneVisible,
        onPressedCodeButton: () {
          ref.read(historyCodePaneVisibleStateProvider.notifier).state =
              !codePaneVisible;
        },
        showViewCodeButton: !isCompact,
        showIndicators: [false, false, false],
        tabLabels: const [
          kLabelPrompts,
          kLabelAuthorization,
          kLabelConfiguration,
        ],
        children: [
          const HisAIRequestPromptSection(),
          const HisAIRequestAuthorizationSection(),
          const HisAIRequestConfigSection(),
        ],
      ),
      APIType.websocket => RequestPane(
        key: const Key("history-request-pane-websocket"),
        codeButtonTooltip: codeButtonTooltip,
        selectedId: selectedId,
        codePaneVisible: codePaneVisible,
        onPressedCodeButton: () {
          ref.read(historyCodePaneVisibleStateProvider.notifier).state =
              !codePaneVisible;
        },
        // No WebSocket codegen yet: the button stays visible so the tooltip
        // and the code pane can say so, like AI and GraphQL above.
        showViewCodeButton: !isCompact,
        showIndicators: [paramLength > 0, headerLength > 0, true],
        tabLabels: const [kLabelURLParams, kLabelHeaders, kLabelSettings],
        children: [
          RequestDataTable(rows: params, keyName: kNameURLParam),
          RequestDataTable(rows: headers, keyName: kNameHeader),
          const HisWebSocketConfigSection(),
        ],
      ),
      APIType.mqtt => RequestPane(
        key: const Key("history-request-pane-mqtt"),
        codeButtonTooltip: codeButtonTooltip,
        selectedId: selectedId,
        codePaneVisible: codePaneVisible,
        onPressedCodeButton: () {
          ref.read(historyCodePaneVisibleStateProvider.notifier).state =
              !codePaneVisible;
        },
        showViewCodeButton: !isCompact,
        showIndicators: [
          mqttConnection.isNotEmpty,
          mqttTopics.isNotEmpty,
          mqttProperties.isNotEmpty,
        ],
        tabLabels: const ["Connection", "Topics", "Properties"],
        children: [
          RequestDataTable(rows: mqttConnection, keyName: "Setting"),
          RequestDataTable(rows: mqttTopics, keyName: "Topic"),
          RequestDataTable(rows: mqttProperties, keyName: "Property"),
        ],
      ),
      APIType.grpc => RequestPane(
        key: const Key("history-request-pane-grpc"),
        codeButtonTooltip: codeButtonTooltip,
        selectedId: selectedId,
        codePaneVisible: codePaneVisible,
        onPressedCodeButton: () {
          ref.read(historyCodePaneVisibleStateProvider.notifier).state =
              !codePaneVisible;
        },
        showViewCodeButton: !isCompact,
        showIndicators: [
          grpcInfo.isNotEmpty,
          grpcMetadata.isNotEmpty,
          grpcParameters.isNotEmpty,
        ],
        tabLabels: const ['Info', 'Metadata', 'Message'],
        children: [
          RequestDataTable(rows: grpcInfo, keyName: 'Field'),
          RequestDataTable(rows: grpcMetadata, keyName: 'Metadata'),
          RequestDataTable(rows: grpcParameters, keyName: 'Parameter'),
        ],
      ),
      _ => kSizedBoxEmpty,
    };
  }
}

class HisRequestBody extends ConsumerWidget {
  const HisRequestBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedHistoryModel = ref.watch(selectedHistoryRequestModelProvider);
    final apiType = selectedHistoryModel?.metaData.apiType;
    final requestModel = selectedHistoryModel?.httpRequestModel;
    final contentType = requestModel?.bodyContentType;

    return switch (apiType) {
      APIType.rest => Column(
        children: [
          kVSpacer5,
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.labelLarge,
              children: [
                const TextSpan(text: kLabelContentType),
                TextSpan(
                  text: contentType?.name ?? kLabelDefaultContentType,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          kVSpacer5,
          Expanded(
            child: switch (contentType) {
              ContentType.formdata => Padding(
                padding: kPh4,
                child: RequestFormDataTable(rows: requestModel?.formData ?? []),
              ),
              ContentType.json => Padding(
                padding: kPt5o10,
                child: JsonTextFieldEditor(
                  key: Key("${selectedHistoryModel?.historyId}-json-body"),
                  fieldKey:
                      "${selectedHistoryModel?.historyId}-json-body-viewer",
                  initialValue: requestModel?.body,
                  readOnly: true,
                  isDark: Theme.of(context).brightness == Brightness.dark,
                ),
              ),
              _ => Padding(
                padding: kPt5o10,
                child: TextFieldEditor(
                  key: Key("${selectedHistoryModel?.historyId}-body"),
                  fieldKey: "${selectedHistoryModel?.historyId}-body-viewer",
                  initialValue: requestModel?.body,
                  readOnly: true,
                ),
              ),
            },
          ),
        ],
      ),
      APIType.graphql => Padding(
        padding: kPt5o10,
        child: TextFieldEditor(
          key: Key("${selectedHistoryModel?.historyId}-query"),
          fieldKey: "${selectedHistoryModel?.historyId}-query-viewer",
          initialValue: requestModel?.query,
          readOnly: true,
        ),
      ),
      _ => kSizedBoxEmpty,
    };
  }
}
