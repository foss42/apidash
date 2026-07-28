import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/grpc_request_model.dart';
import 'package:file_selector/file_selector.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash/services/connection_manager.dart';
import 'package:apidash/utils/grpc_utils.dart';
import 'package:apidash/services/grpc_reflection_service.dart';
import 'request_metadata_grpc.dart';
import 'request_parameters_grpc.dart';
import 'request_auth_grpc.dart';

class EditGrpcRequestPane extends ConsumerStatefulWidget {
  const EditGrpcRequestPane({
    super.key,
    this.showViewCodeButton = true,
  });

  final bool showViewCodeButton;

  @override
  ConsumerState<EditGrpcRequestPane> createState() =>
      _EditGrpcRequestPaneState();
}

class _EditGrpcRequestPaneState extends ConsumerState<EditGrpcRequestPane> {
  final TextEditingController _bodyController = TextEditingController();

  @override
  void dispose() {
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final requestModel = ref.watch(selectedRequestModelProvider);
    final grpcModel = requestModel?.grpcRequestModel;

    if (grpcModel == null) return kSizedBoxEmpty;

    if (_bodyController.text != grpcModel.requestBody) {
      _bodyController.text = grpcModel.requestBody;
    }

    final requestId = requestModel?.id;
    // grpcModel != null implies requestModel (and its id) is non-null; the
    // guard just narrows the type for the streaming send affordance below.
    if (requestId == null) return kSizedBoxEmpty;
    final isClientOrBidi =
        grpcModel.streamingType == GrpcStreamingType.client ||
            grpcModel.streamingType == GrpcStreamingType.bidi;
    final hasOpenGrpcStream =
        ConnectionManager.instance.hasGrpcRequestStream(requestId);

    return DefaultTabController(
      length: 5,
      child: Column(
        children: [
          TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor:
                Theme.of(context).colorScheme.onSurfaceVariant,
            tabs: const [
              Tab(text: "Invocation"),
              Tab(text: "Body"),
              Tab(text: "Metadata"),
              Tab(text: "Auth"),
              Tab(text: "Settings"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Invocation Tab
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Select Service",
                                    style: kTextStyleButtonSmall),
                                kVSpacer5,
                                ADDropdownButton<String>(
                                  isExpanded: true,
                                  value: grpcModel.service,
                                  values: grpcModel.availableServices
                                      .map((s) => (s, s)),
                                  onChanged: (val) async {
                                    if (val != null) {
                                      List<String> methods = [];
                                      if (grpcModel.useReflection &&
                                          requestModel != null) {
                                        await ConnectionManager.instance
                                            .connectGrpc(
                                                requestModel.id, grpcModel);
                                        final result =
                                            await GrpcReflectionService
                                                .getMethodsForService(
                                                    requestModel.id,
                                                    grpcModel,
                                                    val);
                                        methods = result[val] ?? [];
                                      }
                                      ref
                                          .read(collectionStateNotifierProvider
                                              .notifier)
                                          .update(
                                            grpcRequestModel:
                                                grpcModel.copyWith(
                                              service: val,
                                              availableMethods: methods,
                                              method: null,
                                            ),
                                          );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          kHSpacer20,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Select Method",
                                    style: kTextStyleButtonSmall),
                                kVSpacer5,
                                ADDropdownButton<String>(
                                  isExpanded: true,
                                  value: grpcModel.method,
                                  values: grpcModel.availableMethods
                                      .map((m) => (m, m)),
                                  onChanged: (val) async {
                                    if (val != null) {
                                      List<GrpcParameterModel> params = [];
                                      if (grpcModel.protoFile != null) {
                                        final result =
                                            await GrpcUtils.parseProtoFile(
                                                grpcModel.protoFile!);
                                        final methodMappings = result['methods']
                                            as Map<String, dynamic>?;
                                        final messageFields =
                                            result['messageFields']
                                                as Map<String, dynamic>?;

                                        if (methodMappings != null &&
                                            messageFields != null) {
                                          final requestType = (methodMappings[
                                                      "${grpcModel.service}/$val"]
                                                  as List<String>?)
                                              ?.first;
                                          if (requestType != null) {
                                            params = (messageFields[requestType]
                                                    as List<
                                                        GrpcParameterModel>?) ??
                                                [];
                                          }
                                        }
                                      } else if (grpcModel.useReflection &&
                                          requestModel != null &&
                                          grpcModel.service != null) {
                                        params = await GrpcReflectionService
                                            .getParamsForMethod(
                                                requestModel.id,
                                                grpcModel,
                                                grpcModel.service!,
                                                val);
                                      }

                                      ref
                                          .read(collectionStateNotifierProvider
                                              .notifier)
                                          .update(
                                            grpcRequestModel:
                                                grpcModel.copyWith(
                                              method: val,
                                              parameters: params,
                                              requestBody:
                                                  GrpcUtils.paramsToJson(
                                                      params),
                                            ),
                                          );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      kVSpacer20,
                      Row(
                        children: [
                          const Text("Type: ", style: kTextStyleButtonSmall),
                          kHSpacer10,
                          ADDropdownButton<GrpcStreamingType>(
                            value: grpcModel.streamingType,
                            values: const [
                              (GrpcStreamingType.unary, "Unary"),
                              (GrpcStreamingType.client, "Client streaming"),
                              (GrpcStreamingType.server, "Server streaming"),
                              (GrpcStreamingType.bidi, "Bidirectional"),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                ref
                                    .read(collectionStateNotifierProvider
                                        .notifier)
                                    .update(
                                      grpcRequestModel: grpcModel.copyWith(
                                          streamingType: val),
                                    );
                              }
                            },
                          ),
                        ],
                      ),
                      kVSpacer20,
                      const Text("Request Parameters (Form)",
                          style: kTextStyleButtonSmall),
                      kVSpacer10,
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).colorScheme.outlineVariant),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const EditGrpcRequestParameters(),
                        ),
                      ),
                    ],
                  ),
                ),
                // Body Tab
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Request Body (JSON)",
                          style: kTextStyleButtonSmall),
                      kVSpacer10,
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: _bodyController,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          style: kCodeStyle,
                          decoration: InputDecoration(
                            hintText: "Enter request body (JSON)...",
                            hintStyle: kCodeStyle,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onChanged: (val) {
                            ref
                                .read(collectionStateNotifierProvider.notifier)
                                .update(
                                  grpcRequestModel:
                                      grpcModel.copyWith(requestBody: val),
                                );
                          },
                        ),
                      ),
                      if (isClientOrBidi) ...[
                        kVSpacer10,
                        Row(
                          children: [
                            OutlinedButton.icon(
                              icon: const Icon(Icons.send, size: 16),
                              label: const Text("Send message"),
                              onPressed: hasOpenGrpcStream
                                  ? () {
                                      ref
                                          .read(collectionStateNotifierProvider
                                              .notifier)
                                          .sendGrpcMessage(requestId);
                                    }
                                  : null,
                            ),
                            kHSpacer10,
                            OutlinedButton.icon(
                              icon: const Icon(Icons.done_all, size: 16),
                              label: const Text("Finish sending"),
                              onPressed: hasOpenGrpcStream
                                  ? () {
                                      ref
                                          .read(collectionStateNotifierProvider
                                              .notifier)
                                          .finishGrpcSending(requestId);
                                      setState(() {});
                                    }
                                  : null,
                            ),
                          ],
                        ),
                        kVSpacer5,
                        Text(
                          hasOpenGrpcStream
                              ? "Streaming active — edit the params/body, then Send. Finish sending to half-close the request stream."
                              : "Start a ${grpcModel.streamingType == GrpcStreamingType.client ? 'client' : 'bidirectional'}-streaming call (Send in the URL bar) to push more messages here.",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
                // Metadata Tab
                const EditGrpcRequestMetadata(),
                // Auth Tab
                const EditGrpcRequestAuth(),
                // Settings Tab
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: [
                      Row(
                        children: [
                          const Text("Port: "),
                          SizedBox(
                            width: 100,
                            child: TextFormField(
                              initialValue: () {
                                String url = grpcModel.url;
                                if (url.contains(':')) {
                                  return url.split(':')[1];
                                }
                                return '50051';
                              }(),
                              decoration: const InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (val) {
                                final port = int.tryParse(val.trim()) ?? 50051;
                                String url = grpcModel.url;
                                String host = url.contains(':') ? url.split(':')[0] : url;
                                ref
                                    .read(collectionStateNotifierProvider
                                        .notifier)
                                    .update(
                                      grpcRequestModel:
                                          grpcModel.copyWith(url: '$host:$port'),
                                    );
                              },
                            ),
                          ),
                        ],
                      ),
                      kVSpacer20,
                      SwitchListTile(
                        title: const Text("Use TLS"),
                        value: grpcModel.useTLS,
                        onChanged: (val) {
                          ref
                              .read(collectionStateNotifierProvider.notifier)
                              .update(
                                grpcRequestModel: grpcModel.copyWith(useTLS: val),
                              );
                        },
                      ),
                      kVSpacer20,
                      SwitchListTile(
                        title: const Text("Use Reflection"),
                        subtitle: const Text("Discover services from server"),
                        value: grpcModel.useReflection,
                        onChanged: (val) {
                          ref
                              .read(collectionStateNotifierProvider.notifier)
                              .update(
                                grpcRequestModel:
                                    grpcModel.copyWith(useReflection: val),
                              );
                        },
                      ),
                      kVSpacer20,
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Proto File",
                                    style: kTextStyleButtonSmall),
                                Text(
                                  grpcModel.protoFile ??
                                      "No Proto file selected",
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              const XTypeGroup typeGroup = XTypeGroup(
                                label: 'Proto Files',
                                extensions: <String>['proto'],
                              );
                              final XFile? file = await openFile(
                                  acceptedTypeGroups: <XTypeGroup>[typeGroup]);
                              if (file != null) {
                                ref
                                    .read(collectionStateNotifierProvider
                                        .notifier)
                                    .update(
                                      grpcRequestModel: grpcModel.copyWith(
                                          protoFile: file.path),
                                    );
                              }
                            },
                            icon: const Icon(Icons.file_open),
                            label: const Text("Select .proto"),
                          ),
                        ],
                      ),
                      kVSpacer20,
                      ElevatedButton.icon(
                        onPressed: () async {
                          if (grpcModel.useReflection && requestModel != null) {
                            // Ensure connected
                            await ConnectionManager.instance
                                .connectGrpc(requestModel.id, grpcModel);

                            final services =
                                await GrpcReflectionService.listServices(
                                    requestModel.id, grpcModel);
                            List<String> methods = [];
                            if (services.isNotEmpty) {
                              final res = await GrpcReflectionService
                                  .getMethodsForService(requestModel.id,
                                      grpcModel, services.first);
                              methods = res[services.first] ?? [];
                            }

                            ref
                                .read(collectionStateNotifierProvider.notifier)
                                .update(
                                  grpcRequestModel: grpcModel.copyWith(
                                    availableServices: services,
                                    service: services.isNotEmpty
                                        ? services.first
                                        : null,
                                    availableMethods: methods,
                                    parameters: [],
                                  ),
                                );
                          } else if (grpcModel.protoFile != null) {
                            final result = await GrpcUtils.parseProtoFile(
                                grpcModel.protoFile!);
                            final services =
                                (result['services'] as List<String>?) ?? [];
                            final methods =
                                (result['methods'] as Map<String, dynamic>?) ?? {};

                            ref
                                .read(collectionStateNotifierProvider.notifier)
                                .update(
                                  grpcRequestModel: grpcModel.copyWith(
                                    availableServices: services,
                                    service: services.isNotEmpty
                                        ? services.first
                                        : null,
                                    availableMethods: services.isNotEmpty
                                        ? (methods[services.first]
                                                as List<String>?) ??
                                            []
                                        : [],
                                    method: null,
                                    parameters: [],
                                  ),
                                );
                          } else {
                            // No reflection enabled and no proto file selected:
                            // there is nothing to discover. Show a real empty
                            // state instead of mock services.
                            ref
                                .read(collectionStateNotifierProvider.notifier)
                                .update(
                                  grpcRequestModel: grpcModel.copyWith(
                                    availableServices: const <String>[],
                                    availableMethods: const <String>[],
                                    service: null,
                                    method: null,
                                    parameters: const <GrpcParameterModel>[],
                                  ),
                                );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "No services found. Enable Reflection or select a .proto file."),
                                  duration: Duration(milliseconds: 2500),
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text("Fetch Services"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
