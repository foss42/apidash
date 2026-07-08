import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/models/models.dart';
import '../../constants.dart';
import '../../models/models.dart';
import '../../prompts/prompts.dart' as dash;

class PromptBuilder {
  String buildSystemPrompt(
    RequestModel? req,
    ChatMessageType type, {
    String? overrideLanguage,
    List<ChatMessage> history = const [],
  }) {
    final historyBlock = buildHistoryBlock(history);
    final contextBlock = buildContextBlock(req);
    final task = buildTaskPrompt(req, type, overrideLanguage: overrideLanguage);
    return [
      ?task,
      ?contextBlock,
      if (historyBlock.isNotEmpty) historyBlock,
    ].join('\n\n');
  }

  String buildHistoryBlock(List<ChatMessage> messages, {int maxTurns = 8}) {
    if (messages.isEmpty) return '';
    final start = messages.length > maxTurns ? messages.length - maxTurns : 0;
    final recent = messages.sublist(start);
    final buf = StringBuffer('''<conversation_context>
\tOnly use the following short chat history to maintain continuity. Do not repeat it back.
\t''');
    for (final m in recent) {
      final role = m.role == MessageRole.user ? 'user' : 'assistant';
      buf.writeln('- $role: ${m.content}');
    }
    buf.writeln('</conversation_context>');
    return buf.toString();
  }

  String? buildContextBlock(RequestModel? req) {
    if (req?.apiType == APIType.websocket) {
      return _buildWsContextBlock(req!);
    }
    final http = req?.httpRequestModel;
    if (req == null || http == null) return null;
    final headers = http.headersMap.entries
        .map((e) => '"${e.key}": "${e.value}"')
        .join(', ');
    return '''<request_context>
  Request Name: ${req.name}
\tURL: ${http.url}
\tMethod: ${http.method.name.toUpperCase()}
  Status: ${req.responseStatus ?? ''}
\tContent-Type: ${http.bodyContentType.name}
\tHeaders: { $headers }
\tBody: ${http.body ?? ''}
  Response: ${req.httpResponseModel?.body ?? ''}
\t</request_context>''';
  }

  String? _buildWsContextBlock(RequestModel req) {
    final ws = req.wsRequestModel;
    if (ws == null) return null;
    final headers =
        rowsToMap(
          getEnabledRows(ws.headers, ws.isHeaderEnabledList),
        )?.entries.map((e) => '"${e.key}": "${e.value}"').join(', ') ??
        '';
    final params =
        rowsToMap(
          getEnabledRows(ws.params, ws.isParamEnabledList),
        )?.entries.map((e) => '"${e.key}": "${e.value}"').join(', ') ??
        '';
    final heartbeat = _wsHeartbeatSummary(ws);
    return '''<request_context>
  Request Name: ${req.name}
\tType: WebSocket connection
\tURL: ${ws.url}
\tConnection Status: ${_deriveWsConnectionStatus(req, ws)}
\tHeaders: { $headers }
\tURL Parameters: { $params }
\tHeartbeat: $heartbeat
\tAuto Reconnect: ${ws.autoReconnect ? 'on' : 'off'}
\t${_buildWsStatsLine(ws.messageHistory)}
\tMessage Log:
${formatWsMessageLog(ws.messageHistory)}
\t</request_context>''';
  }

  String _wsHeartbeatSummary(WebSocketRequestModel ws) {
    final heartbeatParts = <String>[
      if (ws.enableHeartbeat)
        'keep-alive ping every ${ws.heartbeatInterval} seconds',
      if (ws.enableMessageHeartbeat)
        'repeating message "${ws.messageHeartbeatPayload}" every ${ws.messageHeartbeatInterval} seconds',
    ];
    return heartbeatParts.isEmpty ? 'off' : heartbeatParts.join('; ');
  }

  /// Derives a plain-language connection status for a WebSocket request.
  ///
  /// Never uses [RequestModel.responseStatus] — it is not set by WS flows.
  /// Live state comes from [RequestModel.isStreaming]; otherwise the last
  /// lifecycle event in the message history decides.
  String _deriveWsConnectionStatus(RequestModel req, WebSocketRequestModel ws) {
    return _deriveConnectionState(req.isStreaming, ws.messageHistory);
  }

  String _deriveConnectionState(
    bool isStreaming,
    List<WebSocketMessage> history,
  ) {
    if (isStreaming) return 'Currently connected';
    final lifecycle = history
        .where(
          (m) =>
              m.messageType == WebSocketMessageType.connected ||
              m.messageType == WebSocketMessageType.error ||
              m.messageType == WebSocketMessageType.disconnected,
        )
        .toList();
    if (lifecycle.isEmpty) return 'Never connected';
    // Look at the most recent lifecycle events: an error just before the
    // closing "disconnected" event means the last attempt failed.
    for (final m in lifecycle.reversed) {
      switch (m.messageType) {
        case WebSocketMessageType.error:
          return 'Last attempt failed';
        case WebSocketMessageType.disconnected:
          continue;
        default:
          return 'Connection was closed';
      }
    }
    return 'Connection was closed';
  }

  /// Computes plain-language connection health statistics from a
  /// WebSocket-style message history.
  ///
  /// A session is the span from a `connected` event to the next
  /// `disconnected` event. An `error` inside a span marks that session as
  /// ended with an error; an `error` outside any span counts as a failed
  /// connection attempt. If the history ends inside a span and [isStreaming]
  /// is true, that session is reported as ongoing, measured up to the last
  /// timestamp in the history.
  ///
  /// Deliberately reports NO latency metric: the history carries no
  /// round-trip data, so none is fabricated. Pure and deterministic
  /// (never reads the wall clock), so it is directly unit-testable.
  String buildWsConnectionHealthStats(
    List<WebSocketMessage> history, {
    bool isStreaming = false,
  }) {
    if (history.isEmpty) return 'No connection activity yet.';
    final sessionLines = <String>[];
    var completedSessions = 0;
    var ongoingSessions = 0;
    var failedAttempts = 0;
    var sent = 0, received = 0, errors = 0, connects = 0, disconnects = 0;
    var totalConnected = Duration.zero;
    var connectedTimeKnown = true;

    DateTime? openStart;
    var openStarted = false;
    var openHadError = false;
    DateTime? lastTimestamp;

    void closeSession(DateTime? end, {required bool hadError}) {
      completedSessions++;
      final n = completedSessions + ongoingSessions;
      final endText = hadError ? 'ended with an error' : 'ended normally';
      if (openStart != null && end != null) {
        final d = end.difference(openStart);
        totalConnected += d;
        sessionLines.add(
          '- Session $n: lasted ${_formatDurationPlain(d)}, $endText',
        );
      } else {
        connectedTimeKnown = false;
        sessionLines.add('- Session $n: duration unknown, $endText');
      }
    }

    for (final m in history) {
      if (m.timestamp != null) lastTimestamp = m.timestamp;
      switch (m.messageType) {
        case WebSocketMessageType.sent:
          sent++;
        case WebSocketMessageType.received:
          received++;
        case WebSocketMessageType.connected:
          connects++;
          if (openStarted) {
            // A new connect without a recorded close: close the previous
            // span at the new connect time so no time is double-counted.
            closeSession(m.timestamp, hadError: openHadError);
          }
          openStarted = true;
          openStart = m.timestamp;
          openHadError = false;
        case WebSocketMessageType.error:
          errors++;
          if (openStarted) {
            openHadError = true;
          } else {
            failedAttempts++;
          }
        case WebSocketMessageType.disconnected:
          disconnects++;
          if (openStarted) {
            closeSession(m.timestamp, hadError: openHadError);
            openStarted = false;
            openStart = null;
            openHadError = false;
          }
      }
    }

    if (openStarted) {
      if (isStreaming) {
        ongoingSessions++;
        final n = completedSessions + ongoingSessions;
        if (openStart != null && lastTimestamp != null) {
          final d = lastTimestamp.difference(openStart);
          totalConnected += d;
          sessionLines.add(
            '- Session $n: still connected, '
            '${_formatDurationPlain(d)} so far',
          );
        } else {
          connectedTimeKnown = false;
          sessionLines.add('- Session $n: still connected, duration unknown');
        }
      } else {
        closeSession(lastTimestamp, hadError: openHadError);
        final last = sessionLines.removeLast();
        sessionLines.add('$last (no clean end recorded)');
      }
    }

    final lines = <String>[
      'Connection health stats:',
      '- Sessions: ${completedSessions + ongoingSessions} '
          '($completedSessions completed, $ongoingSessions ongoing)',
      ...sessionLines,
      if (failedAttempts > 0)
        '- Failed connection attempts (never connected): $failedAttempts',
      '- Totals: $sent sent, $received received, '
          '$connects connects, $disconnects disconnects, $errors errors',
      ?_messageRateLine(sent + received, totalConnected, connectedTimeKnown),
      '- Current state: ${_deriveConnectionState(isStreaming, history)}',
    ];
    return lines.join('\n');
  }

  String? _messageRateLine(
    int messages,
    Duration connectedTime,
    bool connectedTimeKnown,
  ) {
    if (!connectedTimeKnown || connectedTime.inSeconds <= 0 || messages == 0) {
      return null;
    }
    final rate = messages * 60 / connectedTime.inSeconds;
    if (rate < 1) {
      return '- Rough message rate: fewer than 1 message per minute';
    }
    final rounded = rate.round();
    final unit = rounded == 1 ? 'message' : 'messages';
    return '- Rough message rate: about $rounded $unit per minute';
  }

  String _formatDurationPlain(Duration d) {
    if (d.inSeconds < 1) return 'less than a second';
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    final parts = <String>[
      if (h > 0) '$h hour${h == 1 ? '' : 's'}',
      if (m > 0) '$m minute${m == 1 ? '' : 's'}',
      if (s > 0 && h == 0) '$s second${s == 1 ? '' : 's'}',
    ];
    return parts.join(' ');
  }

  String _buildWsStatsLine(List<WebSocketMessage> history) {
    var sent = 0, received = 0, errors = 0, connects = 0, disconnects = 0;
    for (final m in history) {
      switch (m.messageType) {
        case WebSocketMessageType.sent:
          sent++;
        case WebSocketMessageType.received:
          received++;
        case WebSocketMessageType.error:
          errors++;
        case WebSocketMessageType.connected:
          connects++;
        case WebSocketMessageType.disconnected:
          disconnects++;
      }
    }
    return 'Stats: $sent sent, $received received, '
        '$connects connects, $disconnects disconnects, $errors errors';
  }

  /// Formats a WebSocket-style message history into a chronological log.
  ///
  /// Keeps ALL lifecycle events (connected / error / disconnected) and only
  /// the last [maxMessages] sent/received messages. Payloads longer than
  /// [maxPayloadChars] are truncated with a suffix noting the original size.
  /// Protocol-agnostic: MQTT reuses [WebSocketMessage] so this works there too.
  String formatWsMessageLog(
    List<WebSocketMessage> history, {
    int maxMessages = 20,
    int maxPayloadChars = 300,
  }) {
    if (history.isEmpty) return '(no messages yet)';
    bool isData(WebSocketMessage m) =>
        m.messageType == WebSocketMessageType.sent ||
        m.messageType == WebSocketMessageType.received;
    final dataIndices = <int>[
      for (var i = 0; i < history.length; i++)
        if (isData(history[i])) i,
    ];
    final keptDataIndices = dataIndices.length > maxMessages
        ? dataIndices.sublist(dataIndices.length - maxMessages).toSet()
        : dataIndices.toSet();
    final lines = <String>[];
    final droppedCount = dataIndices.length - keptDataIndices.length;
    final firstKeptDataIndex = keptDataIndices.isEmpty
        ? -1
        : keptDataIndices.reduce((a, b) => a < b ? a : b);
    for (var i = 0; i < history.length; i++) {
      final m = history[i];
      if (isData(m) && !keptDataIndices.contains(i)) continue;
      if (droppedCount > 0 && i == firstKeptDataIndex) {
        lines.add('… [$droppedCount earlier messages omitted]');
      }
      final ts = m.timestamp?.toIso8601String() ?? 'unknown-time';
      final label = switch (m.messageType) {
        WebSocketMessageType.sent => 'SENT',
        WebSocketMessageType.received => 'RECEIVED',
        WebSocketMessageType.connected => 'CONNECTED',
        WebSocketMessageType.error => 'ERROR',
        WebSocketMessageType.disconnected => 'DISCONNECTED',
      };
      var payload = m.payload;
      if (payload.length > maxPayloadChars) {
        payload =
            '${payload.substring(0, maxPayloadChars)}'
            '… [truncated, ${m.payload.length} chars total]';
      }
      lines.add('[$ts] $label: $payload');
    }
    return lines.join('\n');
  }

  String? buildTaskPrompt(
    RequestModel? req,
    ChatMessageType type, {
    String? overrideLanguage,
  }) {
    if (req == null) return null;
    final http = req.httpRequestModel;
    final resp = req.httpResponseModel;
    final prompts = dash.DashbotPrompts();
    switch (type) {
      case ChatMessageType.explainResponse:
        return prompts.explainApiResponsePrompt(
          url: http?.url,
          method: http?.method.name.toUpperCase(),
          responseStatus: req.responseStatus,
          bodyContentType: http?.bodyContentType.name,
          message: resp?.body,
          headersMap: http?.headersMap,
          body: http?.body,
        );
      case ChatMessageType.debugError:
        return prompts.debugApiErrorPrompt(
          url: http?.url,
          method: http?.method.name.toUpperCase(),
          responseStatus: req.responseStatus,
          bodyContentType: http?.bodyContentType.name,
          message: resp?.body,
          headersMap: http?.headersMap,
          body: http?.body,
        );
      case ChatMessageType.generateTest:
        return prompts.generateTestCasesPrompt(
          url: http?.url,
          method: http?.method.name.toUpperCase(),
          headersMap: http?.headersMap,
          body: http?.body,
        );
      case ChatMessageType.generateDoc:
        return prompts.generateDocumentationPrompt(
          url: http?.url,
          method: http?.method.name.toUpperCase(),
          responseStatus: req.responseStatus,
          bodyContentType: http?.bodyContentType.name,
          message: resp?.body,
          headersMap: http?.headersMap,
          body: http?.body,
        );
      case ChatMessageType.generateCode:
        if (overrideLanguage == null || overrideLanguage.isEmpty) {
          return prompts.codeGenerationIntroPrompt(
            url: http?.url,
            method: http?.method.name.toUpperCase(),
            headersMap: http?.headersMap,
            body: http?.body,
            bodyContentType: http?.bodyContentType.name,
            paramsMap: http?.paramsMap,
            authType: http?.authModel?.type.name,
          );
        } else {
          return prompts.generateCodePrompt(
            url: http?.url,
            method: http?.method.name.toUpperCase(),
            headersMap: http?.headersMap,
            body: http?.body,
            bodyContentType: http?.bodyContentType.name,
            paramsMap: http?.paramsMap,
            authType: http?.authModel?.type.name,
            language: overrideLanguage,
          );
        }
      case ChatMessageType.importCurl:
        return null;
      case ChatMessageType.importOpenApi:
        return null;
      case ChatMessageType.explainWsConnection:
        final ws = req.wsRequestModel;
        return prompts.explainWsConnectionPrompt(
          url: ws?.url,
          connectionStatus: ws == null
              ? null
              : _deriveWsConnectionStatus(req, ws),
          headersMap: ws == null
              ? null
              : rowsToMap(getEnabledRows(ws.headers, ws.isHeaderEnabledList)),
          messageLog: ws == null ? null : formatWsMessageLog(ws.messageHistory),
        );
      case ChatMessageType.debugWsConnection:
        final ws = req.wsRequestModel;
        return prompts.debugWsConnectionPrompt(
          url: ws?.url,
          connectionStatus: ws == null
              ? null
              : _deriveWsConnectionStatus(req, ws),
          headersMap: ws == null
              ? null
              : rowsToMap(getEnabledRows(ws.headers, ws.isHeaderEnabledList)),
          messageLog: ws == null ? null : formatWsMessageLog(ws.messageHistory),
        );
      case ChatMessageType.findInWsMessages:
        final ws = req.wsRequestModel;
        return prompts.findInWsMessagesPrompt(
          url: ws?.url,
          connectionStatus: ws == null
              ? null
              : _deriveWsConnectionStatus(req, ws),
          headersMap: ws == null
              ? null
              : rowsToMap(getEnabledRows(ws.headers, ws.isHeaderEnabledList)),
          // Search task: raise the message cap so the model can look
          // further back, and shorten payload snippets to compensate.
          messageLog: ws == null
              ? null
              : formatWsMessageLog(
                  ws.messageHistory,
                  maxMessages: 150,
                  maxPayloadChars: 150,
                ),
        );
      case ChatMessageType.explainWsMessage:
        final wsMsg = req.wsRequestModel;
        return prompts.explainWsMessagePrompt(
          url: wsMsg?.url,
          connectionStatus: wsMsg == null
              ? null
              : _deriveWsConnectionStatus(req, wsMsg),
          headersMap: wsMsg == null
              ? null
              : rowsToMap(
                  getEnabledRows(wsMsg.headers, wsMsg.isHeaderEnabledList),
                ),
          messageLog: wsMsg == null
              ? null
              : formatWsMessageLog(wsMsg.messageHistory),
        );
      case ChatMessageType.debugWsMessage:
        final wsFail = req.wsRequestModel;
        return prompts.debugWsMessagePrompt(
          url: wsFail?.url,
          connectionStatus: wsFail == null
              ? null
              : _deriveWsConnectionStatus(req, wsFail),
          headersMap: wsFail == null
              ? null
              : rowsToMap(
                  getEnabledRows(wsFail.headers, wsFail.isHeaderEnabledList),
                ),
          messageLog: wsFail == null
              ? null
              : formatWsMessageLog(wsFail.messageHistory),
        );
      case ChatMessageType.wsConnectionHealth:
        final wsHealth = req.wsRequestModel;
        return prompts.wsConnectionHealthPrompt(
          url: wsHealth?.url,
          connectionStatus: wsHealth == null
              ? null
              : _deriveWsConnectionStatus(req, wsHealth),
          healthStats: wsHealth == null
              ? null
              : buildWsConnectionHealthStats(
                  wsHealth.messageHistory,
                  isStreaming: req.isStreaming,
                ),
          messageLog: wsHealth == null
              ? null
              : formatWsMessageLog(wsHealth.messageHistory),
        );
      case ChatMessageType.summarizeWsMessages:
        final ws = req.wsRequestModel;
        return prompts.summarizeWsMessagesPrompt(
          url: ws?.url,
          connectionStatus: ws == null
              ? null
              : _deriveWsConnectionStatus(req, ws),
          headersMap: ws == null
              ? null
              : rowsToMap(getEnabledRows(ws.headers, ws.isHeaderEnabledList)),
          // Summary task: look further back than the default context block,
          // with shorter payload snippets to compensate.
          messageLog: ws == null
              ? null
              : formatWsMessageLog(
                  ws.messageHistory,
                  maxMessages: 100,
                  maxPayloadChars: 150,
                ),
        );
      case ChatMessageType.generateWsDoc:
        final wsDoc = req.wsRequestModel;
        return prompts.generateWsDocumentationPrompt(
          url: wsDoc?.url,
          connectionStatus: wsDoc == null
              ? null
              : _deriveWsConnectionStatus(req, wsDoc),
          headersMap: wsDoc == null
              ? null
              : rowsToMap(
                  getEnabledRows(wsDoc.headers, wsDoc.isHeaderEnabledList),
                ),
          paramsMap: wsDoc == null
              ? null
              : rowsToMap(
                  getEnabledRows(wsDoc.params, wsDoc.isParamEnabledList),
                ),
          settingsSummary: wsDoc == null
              ? null
              : 'Heartbeat: ${_wsHeartbeatSummary(wsDoc)}; '
                    'Auto Reconnect: ${wsDoc.autoReconnect ? 'on' : 'off'}',
          // Documentation task: look further back than the default context
          // block, with shorter payload snippets to compensate.
          messageLog: wsDoc == null
              ? null
              : formatWsMessageLog(
                  wsDoc.messageHistory,
                  maxMessages: 100,
                  maxPayloadChars: 150,
                ),
        );
      case ChatMessageType.generateWsTest:
        final wsTest = req.wsRequestModel;
        return prompts.generateWsTestsPrompt(
          url: wsTest?.url,
          connectionStatus: wsTest == null
              ? null
              : _deriveWsConnectionStatus(req, wsTest),
          headersMap: wsTest == null
              ? null
              : rowsToMap(
                  getEnabledRows(wsTest.headers, wsTest.isHeaderEnabledList),
                ),
          paramsMap: wsTest == null
              ? null
              : rowsToMap(
                  getEnabledRows(wsTest.params, wsTest.isParamEnabledList),
                ),
          settingsSummary: wsTest == null
              ? null
              : 'Heartbeat: ${_wsHeartbeatSummary(wsTest)}; '
                    'Auto Reconnect: ${wsTest.autoReconnect ? 'on' : 'off'}',
          // A handful of recent messages are enough to shape realistic
          // test messages and expected replies.
          messageLog: wsTest == null
              ? null
              : formatWsMessageLog(
                  wsTest.messageHistory,
                  maxMessages: 10,
                  maxPayloadChars: 150,
                ),
        );
      case ChatMessageType.generateWsCode:
        final ws = req.wsRequestModel;
        final headersMap = ws == null
            ? null
            : rowsToMap(getEnabledRows(ws.headers, ws.isHeaderEnabledList));
        if (overrideLanguage == null || overrideLanguage.isEmpty) {
          return prompts.wsCodeGenIntroPrompt(
            url: ws?.url,
            connectionStatus: ws == null
                ? null
                : _deriveWsConnectionStatus(req, ws),
            headersMap: headersMap,
          );
        }
        return prompts.generateWsCodePrompt(
          url: ws?.url,
          headersMap: headersMap,
          paramsMap: ws == null
              ? null
              : rowsToMap(getEnabledRows(ws.params, ws.isParamEnabledList)),
          settingsSummary: ws == null
              ? null
              : 'Heartbeat: ${_wsHeartbeatSummary(ws)}; '
                    'Auto Reconnect: ${ws.autoReconnect ? 'on' : 'off'}',
          // A few recent messages are enough to shape a realistic sample.
          messageLog: ws == null
              ? null
              : formatWsMessageLog(
                  ws.messageHistory,
                  maxMessages: 5,
                  maxPayloadChars: 150,
                ),
          language: overrideLanguage,
        );
      case ChatMessageType.general:
        return prompts.generalInteractionPrompt();
    }
  }

  String? detectLanguage(String text) {
    final t = text.toLowerCase();
    if (t.contains('python')) return 'Python (requests)';
    if (t.contains('dart')) return 'Dart (http)';
    if (t.contains('golang') || t.contains('go ')) return 'Go (net/http)';
    if (t.contains('javascript') || t.contains('js') || t.contains('fetch')) {
      return 'JavaScript (fetch)';
    }
    if (t.contains('curl')) return 'cURL';
    return null;
  }

  /// WebSocket variant of [detectLanguage]: maps a user message to a
  /// WebSocket client library label used by the WS codegen prompts.
  String? detectWsLanguage(String text) {
    final t = text.toLowerCase();
    if (t.contains('python')) return 'Python (websockets)';
    if (t.contains('dart') || t.contains('flutter')) {
      return 'Dart (web_socket_channel)';
    }
    if (t.contains('golang') || t.contains('go ')) {
      return 'Go (gorilla/websocket)';
    }
    if (t.contains('node')) return 'Node.js (ws)';
    if (t.contains('javascript') || t.contains('js') || t.contains('browser')) {
      return 'JavaScript (WebSocket)';
    }
    return null;
  }

  /// Generates appropriate user message text for different task types
  String getUserMessageForTask(ChatMessageType type) {
    switch (type) {
      case ChatMessageType.explainResponse:
        return "Can you explain this response for me?";
      case ChatMessageType.debugError:
        return "Can you help me debug this error?";
      case ChatMessageType.generateDoc:
        return "Can you generate documentation for this request?";
      case ChatMessageType.generateTest:
        return "Can you generate tests for this request?";
      case ChatMessageType.generateCode:
        return "Can you generate code for this request?";
      case ChatMessageType.importCurl:
        return "I'd like to import a cURL command";
      case ChatMessageType.importOpenApi:
        return "I'd like to import an OpenAPI specification";
      case ChatMessageType.explainWsConnection:
        return "Can you explain what's happening with this connection?";
      case ChatMessageType.debugWsConnection:
        return "My connection isn't working. Can you help me fix it?";
      case ChatMessageType.findInWsMessages:
        return "Help me find something in my messages.";
      case ChatMessageType.explainWsMessage:
        return "Can you explain the message I sent?";
      case ChatMessageType.debugWsMessage:
        return "Why did my message fail?";
      case ChatMessageType.wsConnectionHealth:
        return "How healthy is my connection?";
      case ChatMessageType.summarizeWsMessages:
        return "What is the server sending me?";
      case ChatMessageType.generateWsDoc:
        return "Can you generate documentation for this connection?";
      case ChatMessageType.generateWsTest:
        return "Can you generate tests for this connection?";
      case ChatMessageType.generateWsCode:
        return "Can you generate code for this connection?";
      case ChatMessageType.general:
        return "Hello";
    }
  }
}
