import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

enum GrpcConnectionState {
  disconnected,
  connecting,
  connected,
  error,
}

class GrpcConnectionInfo {
  final GrpcConnectionState state;
  final String? errorMessage;
  final List<GrpcServiceInfo> services;

  const GrpcConnectionInfo({
    this.state = GrpcConnectionState.disconnected,
    this.errorMessage,
    this.services = const [],
  });

  GrpcConnectionInfo copyWith({
    GrpcConnectionState? state,
    String? errorMessage,
    List<GrpcServiceInfo>? services,
  }) {
    return GrpcConnectionInfo(
      state: state ?? this.state,
      errorMessage: errorMessage ?? this.errorMessage,
      services: services ?? this.services,
    );
  }
}

/// Per-request gRPC connection state.
final grpcConnectionProvider =
    StateProvider.family<GrpcConnectionInfo, String>((ref, requestId) {
  return const GrpcConnectionInfo();
});

/// Per-request selected service name.
final grpcSelectedServiceProvider =
    StateProvider.family<String?, String>((ref, requestId) => null);

/// Per-request selected method name.
final grpcSelectedMethodProvider =
    StateProvider.family<String?, String>((ref, requestId) => null);

/// gRPC response messages collected during a call.
class GrpcResponseNotifier extends StateNotifier<List<GrpcCallResult>> {
  GrpcResponseNotifier() : super([]);

  void addResult(GrpcCallResult result) {
    state = [...state, result];
  }

  void clear() {
    state = [];
  }

  void setResults(List<GrpcCallResult> results) {
    state = results;
  }
}

final grpcResponseProvider = StateNotifierProvider.family<GrpcResponseNotifier,
    List<GrpcCallResult>, String>((ref, requestId) {
  return GrpcResponseNotifier();
});

/// Whether a gRPC call is currently in progress.
final grpcIsInvokingProvider =
    StateProvider.family<bool, String>((ref, requestId) => false);

/// Per-request gRPC request body (JSON string for editing).
final grpcRequestBodyProvider =
    StateProvider.family<String, String>((ref, requestId) => "{}");
