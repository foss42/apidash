import 'package:apidash/utils/file_utils.dart' show getNewUuid;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';

/// One integrated PTY session, usually tied to a [collectionId] (Bruno-style).
@immutable
class ShellTerminalSession {
  const ShellTerminalSession({
    required this.id,
    required this.collectionId,
    required this.label,
    required this.workingDirectory,
  });

  final String id;
  final String collectionId;
  final String label;
  final String workingDirectory;

  ShellTerminalSession copyWith({
    String? id,
    String? collectionId,
    String? label,
    String? workingDirectory,
  }) {
    return ShellTerminalSession(
      id: id ?? this.id,
      collectionId: collectionId ?? this.collectionId,
      label: label ?? this.label,
      workingDirectory: workingDirectory ?? this.workingDirectory,
    );
  }
}

@immutable
class ShellTerminalSessionsState {
  const ShellTerminalSessionsState({
    this.sessions = const [],
    this.activeSessionId,
  });

  final List<ShellTerminalSession> sessions;
  final String? activeSessionId;
}

class ShellTerminalSessionsNotifier extends StateNotifier<ShellTerminalSessionsState> {
  ShellTerminalSessionsNotifier() : super(const ShellTerminalSessionsState());

  /// Creates or updates the session for [collectionId] and selects it.
  void upsertAndActivate({
    required String collectionId,
    required String workingDirectory,
    required String label,
  }) {
    final path = workingDirectory.trim();
    if (path.isEmpty) return;

    final existingIdx =
        state.sessions.indexWhere((s) => s.collectionId == collectionId);
    final id = existingIdx >= 0 ? state.sessions[existingIdx].id : getNewUuid();
    final session = ShellTerminalSession(
      id: id,
      collectionId: collectionId,
      label: label.trim().isNotEmpty ? label.trim() : 'Collection',
      workingDirectory: path,
    );

    final next = [...state.sessions];
    if (existingIdx >= 0) {
      next[existingIdx] = session;
    } else {
      next.add(session);
    }
    state = ShellTerminalSessionsState(sessions: next, activeSessionId: id);
  }

  void activate(String sessionId) {
    if (!state.sessions.any((s) => s.id == sessionId)) return;
    state = ShellTerminalSessionsState(
      sessions: state.sessions,
      activeSessionId: sessionId,
    );
  }

  void remove(String sessionId) {
    final filtered =
        state.sessions.where((s) => s.id != sessionId).toList(growable: false);
    var active = state.activeSessionId;
    if (active == sessionId) {
      active = filtered.isEmpty ? null : filtered.first.id;
    }
    state = ShellTerminalSessionsState(sessions: filtered, activeSessionId: active);
  }
}

final shellTerminalSessionsNotifierProvider =
    StateNotifierProvider<ShellTerminalSessionsNotifier, ShellTerminalSessionsState>(
  (ref) => ShellTerminalSessionsNotifier(),
);
