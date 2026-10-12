import 'dart:convert';
import 'package:apidash/services/services.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/foundation.dart';
import '../models/models.dart';

/// Builds the metadata map for a gRPC call by merging the user's Metadata-table
/// entries with headers derived from the request's [AuthModel].
///
/// Precedence: user metadata entries are applied first, then auth-derived
/// headers are merged on top — so an auth entry OVERRIDES a manual metadata
/// entry sharing the same (case-insensitive) key. This makes the first-class
/// Auth tab the source of truth and stops a stale hand-typed `authorization`
/// row from silently defeating it. Entries with different keys always coexist.
///
/// Keys are lower-cased (HTTP/2 / gRPC header semantics) so a collision resolves
/// deterministically here, before the grpc package's own metadata sanitizer
/// (which also lower-cases) runs.
///
/// Token formatting is delegated to [handleAuth] — the exact helper the HTTP
/// path uses — so bearer/basic/api-key/jwt/etc. are formatted identically. Only
/// header-targeted auth maps to gRPC; query-param auth (api-key/jwt set to
/// `query`) has no gRPC equivalent and is ignored.
Future<Map<String, String>> buildGrpcMetadata(
  GrpcRequestModel grpcModel,
) async {
  final merged = <String, String>{};

  grpcModel.metadataMap.forEach((name, value) {
    final key = name.trim().toLowerCase();
    if (key.isNotEmpty) merged[key] = value;
  });

  final authModel = grpcModel.authModel;
  if (authModel != null && authModel.type != APIAuthType.none) {
    final authed = await handleAuth(
      HttpRequestModel(url: grpcModel.url, headers: const []),
      authModel,
    );
    for (final header in (authed.headers ?? const <NameValueModel>[])) {
      final key = header.name.trim().toLowerCase();
      if (key.isNotEmpty) merged[key] = header.value;
    }
  }

  return merged;
}

/// Reflection-only service/method discovery for the URL-bar "Reflect" button
/// (shown whenever no method is selected). Connects, lists services via
/// server reflection, loads the first service's methods, and stamps
/// `useReflection: true` as the active discovery source. It never invokes an
/// RPC. On an empty result the real reflection failure ([lastError]) is
/// surfaced through the same messageHistory error channel the streaming
/// onError path uses, instead of a silent empty dropdown.
Future<void> reflectGrpcServices(
  String requestId, {
  bool mounted = true,
  RequestModel? Function(String)? getRequestModelFromState,
  RequestUpdater? update,
}) async {
  final requestModel = getRequestModelFromState?.call(requestId);
  final grpcModel = requestModel?.grpcRequestModel;
  if (requestModel == null || grpcModel == null) return;

  await ConnectionManager.instance.connectGrpc(requestId, grpcModel);
  // Guard: the notifier may have been disposed while awaiting the handshake.
  if (!mounted) return;

  // Reflection may require auth on secured servers, so thread the same
  // metadata the actual RPC uses.
  final metadata = await buildGrpcMetadata(grpcModel);
  if (!mounted) return;

  final services = await GrpcReflectionService.listServices(
    requestId,
    grpcModel,
    metadata: metadata,
  );
  if (!mounted) return;

  if (services.isNotEmpty) {
    final methodsResult = await GrpcReflectionService.getMethodsForService(
      requestId,
      grpcModel,
      services.first,
      metadata: metadata,
    );
    if (!mounted) return;
    final methods = methodsResult[services.first] ?? <String>[];

    final latest = getRequestModelFromState?.call(requestId);
    final latestGrpc = latest?.grpcRequestModel;
    if (latest != null && latestGrpc != null) {
      update?.call(
        id: requestId,
        grpcRequestModel: latestGrpc.copyWith(
          availableServices: services,
          service: services.first,
          availableMethods: methods,
          method: null,
          parameters: const <GrpcParameterModel>[],
          useReflection: true,
        ),
      );
    }
  } else {
    // Empty result with no feedback is the exact bug: surface WHY (wrong
    // reflection version, TLS mismatch, refused, reflection disabled).
    final err = GrpcReflectionService.lastError;
    final errorMsg = WebSocketMessage(
      payload: err != null
          ? "Reflection failed: $err"
          : "No services found. Enable reflection on the server or select a .proto file.",
      timestamp: DateTime.now(),
      outgoing: false,
      messageType: WebSocketMessageType.error,
    );
    final latest = getRequestModelFromState?.call(requestId);
    final latestGrpc = latest?.grpcRequestModel;
    if (latest != null && latestGrpc != null) {
      update?.call(
        id: requestId,
        grpcRequestModel: latestGrpc.copyWith(
          messageHistory: [...latestGrpc.messageHistory, errorMsg],
        ),
      );
    }
  }
}

Future<void> connectGrpc(
  String requestId,
  RequestModel requestModel,
  GrpcRequestModel grpcModel, {
  String? historyId,
  bool mounted = true,
  RequestModel? Function(String)? getRequestModelFromState,
  RequestUpdater? update,
  void Function(String, RequestModel)? updateStateRequestModel,
  void Function(String, GrpcRequestModel)? updateGrpcHistoryRecord,
}) async {
  try {
    // Mark in-flight AND stamp sendingTime so the response pane's sending
    // animation shows a live elapsed timer (mirrors WS/HTTP). Without
    // sendingTime the timer is stuck at 0ms.
    final connectingReq = getRequestModelFromState?.call(requestId);
    if (connectingReq != null) {
      updateStateRequestModel?.call(
        requestId,
        connectingReq.copyWith(isWorking: true, sendingTime: DateTime.now()),
      );
    }

    await ConnectionManager.instance.connectGrpc(requestId, grpcModel);

    // Guard: the notifier may have been disposed while awaiting the gRPC
    // channel handshake; the `state` reads/writes below would throw otherwise.
    if (!mounted) return;

    String host = grpcModel.url.trim();
    int port = 50051;
    if (host.contains(':')) {
      final parts = host.split(':');
      host = parts[0].trim();
      final p = int.tryParse(parts[1].trim());
      if (p != null) port = p;
    }

    final msg = WebSocketMessage(
      payload: "Connected to gRPC host: $host:$port",
      timestamp: DateTime.now(),
      outgoing: false,
      messageType: WebSocketMessageType.connected,
    );

    final currentRequest = getRequestModelFromState?.call(requestId);
    if (currentRequest != null && currentRequest.grpcRequestModel != null) {
      final currentGrpcModel = currentRequest.grpcRequestModel!;
      final isActualRequest =
          grpcModel.service != null && grpcModel.method != null;
      updateStateRequestModel?.call(
        requestId,
        currentRequest.copyWith(
          isWorking: isActualRequest,
          isStreaming: isActualRequest,
          responseStatus: isActualRequest ? 0 : currentRequest.responseStatus,
          message: isActualRequest ? "" : currentRequest.message,
          httpResponseModel: isActualRequest
              ? null
              : currentRequest.httpResponseModel,
          grpcRequestModel: currentGrpcModel.copyWith(
            messageHistory: isActualRequest
                ? [msg]
                : currentGrpcModel.messageHistory,
          ),
        ),
      );

      debugPrint("gRPC: Host established. Checking for method invocation...");

      // Build call metadata once (auth headers + custom metadata). Reflection
      // needs it too: a server that requires auth rejects unauthenticated
      // ServerReflectionInfo calls, so it is threaded through the reflection
      // helpers as well as the actual RPC below.
      final grpcMetadata = await buildGrpcMetadata(grpcModel);
      // Guard: disposed while building auth metadata; state writes below throw.
      if (!mounted) return;

      if (grpcModel.useReflection ||
          (grpcModel.service == null && grpcModel.method == null)) {
        debugPrint("gRPC: Fetching services via reflection...");
        final services = await GrpcReflectionService.listServices(
          requestId,
          grpcModel,
          metadata: grpcMetadata,
        );
        // Guard: disposed while awaiting reflection; state access below throws.
        if (!mounted) return;
        if (services.isNotEmpty) {
          final latestRequest = getRequestModelFromState?.call(requestId);
          if (latestRequest != null && latestRequest.grpcRequestModel != null) {
            updateStateRequestModel?.call(
              requestId,
              latestRequest.copyWith(
                grpcRequestModel: latestRequest.grpcRequestModel!.copyWith(
                  useReflection: true,
                  availableServices: services,
                ),
              ),
            );
          }
        } else if (GrpcReflectionService.lastError != null) {
          // Reflection produced no services. Surface WHY (wrong reflection
          // version, TLS mismatch, connection refused, reflection disabled)
          // through the same message-history error channel the streaming
          // onError path uses, instead of a silent empty dropdown.
          final reflectionErrorMsg = WebSocketMessage(
            payload: "Reflection failed: ${GrpcReflectionService.lastError}",
            timestamp: DateTime.now(),
            outgoing: false,
            messageType: WebSocketMessageType.error,
          );
          final currentReq = getRequestModelFromState?.call(requestId);
          if (currentReq != null && currentReq.grpcRequestModel != null) {
            update?.call(
              id: requestId,
              grpcRequestModel: currentReq.grpcRequestModel!.copyWith(
                messageHistory: [
                  ...currentReq.grpcRequestModel!.messageHistory,
                  reflectionErrorMsg,
                ],
              ),
            );
          }
        }
      }

      if (grpcModel.service != null && grpcModel.method != null) {
        debugPrint(
          "gRPC: Invoking method ${grpcModel.service}/${grpcModel.method}",
        );

        GrpcMethodSchema? methodSchema;
        if (grpcModel.useReflection) {
          methodSchema = await GrpcReflectionService.getMethodSchema(
            requestId,
            grpcModel,
            grpcModel.service!,
            grpcModel.method!,
            metadata: grpcMetadata,
          );
        }
        // Guard: disposed while awaiting the method schema.
        if (!mounted) return;

        final startTime = DateTime.now();
        final requestData = grpcModel.parameters.isNotEmpty
            ? GrpcUtils.paramsToBytes(grpcModel.parameters)
            : utf8.encode(grpcModel.requestBody);

        final call = ConnectionManager.instance.callGrpcMethod(
          requestId,
          grpcModel.service!,
          grpcModel.method!,
          requestData,
          metadata: grpcMetadata,
          streamingType: grpcModel.streamingType,
        );

        // For client/bidi streaming the request stream stays open; record
        // the first message that was just sent so the user has feedback.
        final keepsRequestStreamOpen =
            grpcModel.streamingType == GrpcStreamingType.client ||
            grpcModel.streamingType == GrpcStreamingType.bidi;
        if (keepsRequestStreamOpen) {
          final sentPreview = grpcModel.parameters.isNotEmpty
              ? GrpcUtils.paramsToJson(grpcModel.parameters)
              : grpcModel.requestBody;
          final sentMsg = WebSocketMessage(
            payload: "Sent:\n$sentPreview",
            timestamp: DateTime.now(),
            outgoing: true,
            messageType: WebSocketMessageType.sent,
          );
          final reqNow = getRequestModelFromState?.call(requestId);
          final grpcNow = reqNow?.grpcRequestModel;
          if (reqNow != null && grpcNow != null) {
            updateStateRequestModel?.call(
              requestId,
              reqNow.copyWith(
                grpcRequestModel: grpcNow.copyWith(
                  messageHistory: [...grpcNow.messageHistory, sentMsg],
                ),
              ),
            );
          }
        }

        Map<String, String> initialMetadata = {};
        Map<String, String> trailingMetadata = {};

        call.headers
            .then((headers) {
              initialMetadata = headers;
            })
            .catchError((_) {});

        call.trailers
            .then((trailers) {
              trailingMetadata = trailers;
            })
            .catchError((_) {});

        call.response.listen(
          (data) {
            // Guard: stream events can arrive after the notifier is disposed
            // (free-floating subscription); touching `state` then throws.
            if (!mounted) return;
            final duration = DateTime.now().difference(startTime);
            final payload = GrpcUtils.decodeBinaryResponse(
              data,
              schema: methodSchema,
            );
            final responseMsg = WebSocketMessage(
              payload: "Response (${duration.inMilliseconds}ms):\n$payload",
              timestamp: DateTime.now(),
              outgoing: false,
              messageType: WebSocketMessageType.received,
            );

            final currentReq = getRequestModelFromState?.call(requestId);
            if (currentReq != null) {
              final grpcReqModel = currentReq.grpcRequestModel;
              if (grpcReqModel != null) {
                final receivedCount = grpcReqModel.messageHistory
                    .where(
                      (m) => m.messageType == WebSocketMessageType.received,
                    )
                    .length;

                update?.call(
                  id: requestId,
                  isWorking: false,
                  isStreaming: false,
                  responseStatus: receivedCount == 0
                      ? 200
                      : currentReq.responseStatus,
                  httpResponseModel: receivedCount == 0
                      ? HttpResponseModel(
                          body: payload,
                          bodyBytes: utf8.encode(payload),
                          time: duration,
                          headers: initialMetadata.map(
                            (k, v) => MapEntry("[Initial] $k", v),
                          ),
                          // The metadata we sent → shown as "Request Headers".
                          requestHeaders: grpcMetadata,
                        )
                      : currentReq.httpResponseModel,
                  grpcRequestModel: grpcReqModel.copyWith(
                    messageHistory: [
                      ...grpcReqModel.messageHistory,
                      responseMsg,
                    ],
                  ),
                );
              }
            }
          },
          onDone: () {
            // Guard: onDone fires asynchronously after the call completes and
            // may run after the notifier is disposed; touching `state` throws.
            if (!mounted) return;
            // The call has ended: close any still-open client/bidi request
            // stream so `hasGrpcRequestStream` is false and the Body-tab Send
            // button no longer pushes into a dead call (no-op for unary/server).
            ConnectionManager.instance.finishGrpcSending(requestId);
            final currentReq = getRequestModelFromState?.call(requestId);
            if (currentReq != null) {
              final responseModel = currentReq.httpResponseModel;
              final finalHeaders = {
                ...initialMetadata.map((k, v) => MapEntry("[Initial] $k", v)),
                ...trailingMetadata.map((k, v) => MapEntry("[Trailing] $k", v)),
              };

              update?.call(
                id: requestId,
                isWorking: false,
                isStreaming: false,
                httpResponseModel: responseModel?.copyWith(
                  headers: finalHeaders,
                ),
              );
            }
            if (historyId != null) {
              updateGrpcHistoryRecord?.call(
                historyId,
                getRequestModelFromState?.call(requestId)?.grpcRequestModel ??
                    grpcModel,
              );
            }
          },
          onError: (e) {
            // Guard: onError can fire after dispose (call failing while the tab
            // is torn down); touching `state` then throws "used after dispose".
            if (!mounted) return;
            // The call has ended in error: close any open client/bidi request
            // stream so the Body-tab Send button no longer targets a dead call.
            ConnectionManager.instance.finishGrpcSending(requestId);
            final errorMsg = WebSocketMessage(
              payload: "RPC Error: ${e.toString()}",
              timestamp: DateTime.now(),
              outgoing: false,
              messageType: WebSocketMessageType.error,
            );

            final currentReq = getRequestModelFromState?.call(requestId);
            if (currentReq != null && currentReq.grpcRequestModel != null) {
              final currentGrpc = currentReq.grpcRequestModel!;
              update?.call(
                id: requestId,
                isWorking: false,
                isStreaming: false,
                responseStatus: 400,
                message: "",
                httpResponseModel: HttpResponseModel(
                  body: e.toString(),
                  bodyBytes: utf8.encode(e.toString()),
                  time: Duration.zero,
                  requestHeaders: grpcMetadata,
                ),
                grpcRequestModel: currentGrpc.copyWith(
                  messageHistory: [...currentGrpc.messageHistory, errorMsg],
                ),
              );
            }
            if (historyId != null) {
              updateGrpcHistoryRecord?.call(
                historyId,
                getRequestModelFromState?.call(requestId)?.grpcRequestModel ??
                    grpcModel,
              );
            }
          },
        );
      } else {
        final latestRequest = getRequestModelFromState?.call(requestId);
        if (latestRequest != null) {
          updateStateRequestModel?.call(
            requestId,
            latestRequest.copyWith(isWorking: false, isStreaming: false),
          );
        }
        ConnectionManager.instance.disconnectGrpc(requestId);
      }
    }
  } catch (e) {
    final errorMsg = WebSocketMessage(
      payload: "Connection Error: ${e.toString()}",
      timestamp: DateTime.now(),
      outgoing: false,
      messageType: WebSocketMessageType.error,
    );

    final currentRequest = getRequestModelFromState?.call(requestId);
    if (currentRequest != null && currentRequest.grpcRequestModel != null) {
      final currentGrpcModel = currentRequest.grpcRequestModel!;
      updateStateRequestModel?.call(
        requestId,
        currentRequest.copyWith(
          isWorking: false,
          responseStatus: 400,
          message: "",
          httpResponseModel: HttpResponseModel(
            body: e.toString(),
            bodyBytes: utf8.encode(e.toString()),
            time: Duration.zero,
          ),
          grpcRequestModel: currentGrpcModel.copyWith(
            messageHistory: [...currentGrpcModel.messageHistory, errorMsg],
          ),
        ),
      );
    }
    if (historyId != null) {
      updateGrpcHistoryRecord?.call(
        historyId,
        getRequestModelFromState?.call(requestId)?.grpcRequestModel ??
            grpcModel,
      );
    }
  }
}
