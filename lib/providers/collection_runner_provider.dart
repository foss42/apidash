import 'package:flutter_riverpod/flutter_riverpod.dart';

enum RunMode {
  functional,
  performance,
}

class CollectionRunConfig {
  final RunMode mode;
  final int iterations;
  final int delayMs;
  final Set<String> selectedRequestIds;
  // Performance test specific settings
  final int virtualUsers;
  final int durationSeconds;
  final bool rampUp;
  final int rampUpDurationSeconds;

  const CollectionRunConfig({
    required this.mode,
    required this.iterations,
    required this.delayMs,
    required this.selectedRequestIds,
    this.virtualUsers = 50,
    this.durationSeconds = 5,
    this.rampUp = true,
    this.rampUpDurationSeconds = 2,
  });

  CollectionRunConfig copyWith({
    RunMode? mode,
    int? iterations,
    int? delayMs,
    Set<String>? selectedRequestIds,
    int? virtualUsers,
    int? durationSeconds,
    bool? rampUp,
    int? rampUpDurationSeconds,
  }) {
    return CollectionRunConfig(
      mode: mode ?? this.mode,
      iterations: iterations ?? this.iterations,
      delayMs: delayMs ?? this.delayMs,
      selectedRequestIds: selectedRequestIds ?? this.selectedRequestIds,
      virtualUsers: virtualUsers ?? this.virtualUsers,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      rampUp: rampUp ?? this.rampUp,
      rampUpDurationSeconds: rampUpDurationSeconds ?? this.rampUpDurationSeconds,
    );
  }
}

final collectionRunConfigProvider = StateNotifierProvider<CollectionRunConfigNotifier, CollectionRunConfig>((ref) {
  return CollectionRunConfigNotifier();
});

class CollectionRunConfigNotifier extends StateNotifier<CollectionRunConfig> {
  CollectionRunConfigNotifier()
      : super(const CollectionRunConfig(
          mode: RunMode.functional,
          iterations: 1,
          delayMs: 0,
          selectedRequestIds: {},
        ));

  void setMode(RunMode mode) {
    state = state.copyWith(mode: mode);
  }

  void setIterations(int iterations) {
    state = state.copyWith(iterations: iterations);
  }

  void setDelay(int delayMs) {
    state = state.copyWith(delayMs: delayMs);
  }

  void setVirtualUsers(int virtualUsers) {
    state = state.copyWith(virtualUsers: virtualUsers);
  }

  void setDurationSeconds(int durationSeconds) {
    state = state.copyWith(durationSeconds: durationSeconds);
  }

  void setRampUp(bool rampUp) {
    state = state.copyWith(rampUp: rampUp);
  }

  void setRampUpDurationSeconds(int rampUpDurationSeconds) {
    state = state.copyWith(rampUpDurationSeconds: rampUpDurationSeconds);
  }

  void toggleRequest(String requestId) {
    final newSelectedIds = Set<String>.from(state.selectedRequestIds);
    if (newSelectedIds.contains(requestId)) {
      newSelectedIds.remove(requestId);
    } else {
      newSelectedIds.add(requestId);
    }
    state = state.copyWith(selectedRequestIds: newSelectedIds);
  }

  void selectAllRequests(List<String> requestIds) {
    state = state.copyWith(selectedRequestIds: Set<String>.from(requestIds));
  }

  void deselectAllRequests() {
    state = state.copyWith(selectedRequestIds: {});
  }
} 