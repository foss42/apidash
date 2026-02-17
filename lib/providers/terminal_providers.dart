import 'package:apidash/terminal/terminal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:apidash_core/apidash_core.dart';

final terminalStateProvider =
    StateNotifierProvider<TerminalController, TerminalState>((ref) {
  return TerminalController();
});

class TerminalState {
  TerminalState({required this.entries})
      : index = {
          for (var i = 0; i < entries.length; i++) entries[i].id: i,
        };

  final List<TerminalEntry> entries; // newest first
  final Map<String, int> index;

  TerminalState copyWith({List<TerminalEntry>? entries}) {
    return TerminalState(entries: entries ?? this.entries);
  }
}

class TerminalController extends StateNotifier<TerminalState> {
  TerminalController() : super(TerminalState(entries: <TerminalEntry>[]));

  static const _uuid = Uuid();

  String _newId() => _uuid.v4();

  void clear() {
    state = TerminalState(entries: <TerminalEntry>[]);
  }

  String append(TerminalEntry entry) {
    final list = [entry, ...state.entries];
    state = TerminalState(entries: list);
    return entry.id;
  }

  void _updateById(String id, TerminalEntry Function(TerminalEntry) updater) {
    final idx = state.index[id];
    if (idx == null) return;
    final current = state.entries[idx];
    final updated = updater(current);
    final list = [...state.entries];
    list[idx] = updated;
    state = TerminalState(entries: list);
  }

  // Convenience builders
  String startNetwork({
    required APIType apiType,
    required HTTPVerb method,
    required String url,
    String? requestId,
    Map<String, String>? requestHeaders,
    String? requestBodyPreview,
    bool isStreaming = false,
  }) {
    final id = _newId();
    final entry = TerminalEntry(
      id: id,
      source: TerminalSource.network,
      level: TerminalLevel.info,
      requestId: requestId,
      network: NetworkLogData(
        phase: NetworkPhase.started,
        apiType: apiType,
        method: method,
        url: url,
        requestHeaders: requestHeaders,
        requestBodyPreview: requestBodyPreview,
        isStreaming: isStreaming,
        sentAt: DateTime.now(),
      ),
    );
    append(entry);
    return id;
  }

  void addNetworkChunk(String logId, BodyChunk chunk) {
    _updateById(logId, (e) {
      final n = e.network;
      if (n == null) return e;
      n.chunks.add(chunk);
      return e.copyWith(
        network: n.copyWith(phase: NetworkPhase.progress),
      );
    });
  }

  void completeNetwork(
    String logId, {
    int? statusCode,
    Map<String, String>? responseHeaders,
    String? responseBodyPreview,
    Duration? duration,
  }) {
    _updateById(logId, (e) {
      final n = e.network;
      if (n == null) return e;
      return e.copyWith(
        level: (statusCode != null && statusCode >= 400)
            ? TerminalLevel.error
            : TerminalLevel.info,
        network: n.copyWith(
          phase: NetworkPhase.completed,
          responseStatus: statusCode,
          responseHeaders: responseHeaders,
          responseBodyPreview: responseBodyPreview,
          duration: duration,
          completedAt: DateTime.now(),
        ),
      );
    });
  }

  void failNetwork(String logId, String message) {
    _updateById(logId, (e) {
      final n = e.network;
      if (n == null) return e;
      return e.copyWith(
        level: TerminalLevel.error,
        network: n.copyWith(
          phase: NetworkPhase.failed,
          errorMessage: message,
          completedAt: DateTime.now(),
        ),
      );
    });
  }

  void logJs({
    required String level,
    required List<String> args,
    String? stack,
    String? context,
    String? contextRequestId,
  }) {
    append(TerminalEntry(
      id: _newId(),
      source: TerminalSource.js,
      level: switch (level) {
        'warn' => TerminalLevel.warn,
        'error' || 'fatal' => TerminalLevel.error,
        _ => TerminalLevel.info,
      },
      requestId: contextRequestId,
      js: JsLogData(
        level: level,
        args: args,
        stack: stack,
        context: context,
        contextRequestId: contextRequestId,
      ),
    ));
  }

  void logSystem({
    required String category,
    required String message,
    String? stack,
    TerminalLevel level = TerminalLevel.info,
    List<String> tags = const <String>[],
  }) {
    append(TerminalEntry(
      id: _newId(),
      source: TerminalSource.system,
      level: level,
      tags: tags,
      system: SystemLogData(category: category, message: message, stack: stack),
    ));
  }

  // Serialization
  String serializeAll({List<TerminalEntry>? entries}) {
    final list = entries ?? state.entries;
    final buf = StringBuffer();
    for (final e in list) {
      final time = e.ts.toIso8601String();
      final title = titleFor(e);
      final sub = subtitleFor(e);
      buf.writeln('[$time] ${e.level.name.toUpperCase()} - $title');
      if (sub != null && sub.isNotEmpty) {
        buf.writeln('  $sub');
      }
    }
    return buf.toString();
  }

  String titleFor(TerminalEntry e) {
    switch (e.source) {
      case TerminalSource.network:
        final n = e.network!;
        final status = n.responseStatus != null ? ' — ${n.responseStatus}' : '';
        return '${n.method.name.toUpperCase()} ${n.url}$status';
      case TerminalSource.js:
        final j = e.js!;
        return 'JS ${j.level}';
      case TerminalSource.system:
        return 'System';
    }
  }

  String? subtitleFor(TerminalEntry e) {
    switch (e.source) {
      case TerminalSource.network:
        final n = e.network!;
        if (n.errorMessage != null) return n.errorMessage;
        return n.responseBodyPreview ?? n.requestBodyPreview;
      case TerminalSource.js:
        final j = e.js!;
        return j.args.join(' ');
      case TerminalSource.system:
        final s = e.system!;
        return s.message;
    }
    return null;
  }
}
