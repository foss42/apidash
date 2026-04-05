import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'grpc_message_tab.dart';
import 'grpc_metadata_tab.dart';
import 'grpc_service_def_tab.dart';
import 'grpc_settings_tab.dart';

class EditGrpcRequestPane extends ConsumerWidget {
  const EditGrpcRequestPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final codePaneVisible = ref.watch(codePaneVisibleStateProvider);
    final tabIndex = ref.watch(
        selectedRequestModelProvider.select((value) => value?.requestTabIndex));

    final grpcModel = ref.watch(selectedRequestModelProvider
        .select((value) => value?.grpcRequestModel));
    final hasMetadata = (grpcModel?.metadata ?? []).isNotEmpty;

    var currentTabIndex = tabIndex ?? 0;
    if (currentTabIndex >= 4) {
      currentTabIndex = 0;
    }

    return Column(
      children: [
        Expanded(
          child: RequestPane(
            selectedId: selectedId,
            codePaneVisible: codePaneVisible,
            tabIndex: currentTabIndex,
            onPressedCodeButton: () {
              ref.read(codePaneVisibleStateProvider.notifier).state =
                  !codePaneVisible;
            },
            onTapTabBar: (index) {
              ref
                  .read(collectionStateNotifierProvider.notifier)
                  .update(requestTabIndex: index);
            },
            showViewCodeButton: false,
            tabLabels: const [
              kLabelGrpcMessage,
              kLabelGrpcMetadata,
              kLabelGrpcServiceDef,
              kLabelGrpcSettings,
            ],
            showIndicators: [
              false,
              hasMetadata,
              false,
              false,
            ],
            children: const [
              GrpcMessageTab(),
              GrpcMetadataTab(),
              GrpcServiceDefTab(),
              GrpcSettingsTab(),
            ],
          ),
        ),
        GrpcBottomBar(selectedId: selectedId),
      ],
    );
  }
}

class GrpcBottomBar extends ConsumerWidget {
  const GrpcBottomBar({super.key, this.selectedId});
  final String? selectedId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (selectedId == null) return kSizedBoxEmpty;

    final connectionInfo = ref.watch(grpcConnectionProvider(selectedId!));
    final isConnected =
        connectionInfo.state == GrpcConnectionState.connected;
    final services = connectionInfo.services;
    final selectedService =
        ref.watch(grpcSelectedServiceProvider(selectedId!));
    final selectedMethod =
        ref.watch(grpcSelectedMethodProvider(selectedId!));
    final isInvoking = ref.watch(grpcIsInvokingProvider(selectedId!));

    // Build method list for selected service
    List<GrpcMethodInfo> methods = [];
    if (selectedService != null) {
      for (final svc in services) {
        if (svc.serviceName == selectedService) {
          methods = svc.methods;
          break;
        }
      }
    }

    void doInvoke() {
      ref.read(collectionStateNotifierProvider.notifier).invokeGrpc();
    }

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.enter, meta: true): () {
          if (isConnected && !isInvoking) doInvoke();
        },
        const SingleActivator(LogicalKeyboardKey.enter, control: true): () {
          if (isConnected && !isInvoking) doInvoke();
        },
      },
      child: Focus(
        autofocus: true,
        child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
        ),
      ),
      child: Row(
        children: [
          // Service selector
          Expanded(
            flex: 2,
            child: ADPopupMenu<String>(
              tooltip: kLabelGrpcService,
              width: 200,
              value: selectedService != null
                  ? _shortName(selectedService)
                  : kMsgGrpcSelectService,
              values: services.map(
                  (s) => (s.serviceName, _shortName(s.serviceName))),
              onChanged: (String? value) {
                if (value != null) {
                  ref
                      .read(grpcSelectedServiceProvider(selectedId!).notifier)
                      .state = value;
                  // Auto-select first method
                  for (final svc in services) {
                    if (svc.serviceName == value && svc.methods.isNotEmpty) {
                      ref
                          .read(
                              grpcSelectedMethodProvider(selectedId!).notifier)
                          .state = svc.methods.first.methodName;
                      break;
                    }
                  }
                }
              },
              isOutlined: true,
            ),
          ),
          kHSpacer8,
          // Method selector
          Expanded(
            flex: 2,
            child: ADPopupMenu<String>(
              tooltip: kLabelGrpcMethod,
              width: 200,
              value: selectedMethod ?? kMsgGrpcSelectMethod,
              values:
                  methods.map((m) => (m.methodName, m.methodName)),
              onChanged: (String? value) {
                if (value != null) {
                  ref
                      .read(grpcSelectedMethodProvider(selectedId!).notifier)
                      .state = value;
                }
              },
              isOutlined: true,
            ),
          ),
          kHSpacer10,
          // Invoke button
          SizedBox(
            height: 32,
            child: ADFilledButton(
              onPressed: isConnected && !isInvoking ? doInvoke : null,
              items: [
                Icon(size: 16, isInvoking ? Icons.hourglass_top : Icons.send),
                kHSpacer4,
                Text(
                  isInvoking ? kLabelGrpcInvoking : kLabelGrpcInvoke,
                  style: kTextStyleButton,
                ),
              ],
            ),
          ),
          kHSpacer8,
          Text(
            '\u2318\u21b5',
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
    ),
      ),
    );
  }

  /// Extracts just the service name from fully-qualified "package.ServiceName"
  String _shortName(String fullName) {
    final parts = fullName.split('.');
    return parts.last;
  }
}
