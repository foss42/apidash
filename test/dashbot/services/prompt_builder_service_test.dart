import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/models/models.dart';
import 'package:apidash/dashbot/services/services.dart';
import 'package:apidash/models/request_model.dart';
import 'package:apidash/models/ws_request_model.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';

void main() {
  group('PromptBuilder', () {
    late PromptBuilder builder;
    late RequestModel request;

    setUp(() {
      builder = PromptBuilder();
      final http = const HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.apidash.dev/users?size=2',
        headers: [NameValueModel(name: 'Accept', value: 'application/json')],
        isHeaderEnabledList: [true],
        bodyContentType: ContentType.json,
        body: '{"query":"q"}',
      );
      final resp = const HttpResponseModel(
        body: '{"status":"ok"}',
        statusCode: 200,
      );
      request = RequestModel(
        id: 'r1',
        name: 'Get Users',
        httpRequestModel: http,
        httpResponseModel: resp,
        responseStatus: 200,
      );
    });

    test('buildSystemPrompt includes url & method & body', () {
      final prompt = builder.buildSystemPrompt(
        request,
        ChatMessageType.explainResponse,
        history: const [],
      );
      expect(prompt, contains('https://api.apidash.dev/users'));
      expect(prompt.toUpperCase(), contains('GET'));
    });

    test('generateCode with override language uses language', () {
      final p = builder.buildTaskPrompt(
        request,
        ChatMessageType.generateCode,
        overrideLanguage: 'Python',
      );
      expect(p, isNotNull);
      expect(p!.toLowerCase(), contains('python'));
    });

    test('generateCode without override uses intro prompt', () {
      final p = builder.buildTaskPrompt(request, ChatMessageType.generateCode);
      expect(p, isNotNull);
      // Should contain URL and method.
      expect(p!, contains('https://api.apidash.dev/users'));
      expect(p.toUpperCase(), contains('GET'));
      // Should list available languages including python (requests) option.
      expect(p.toLowerCase(), contains('python (requests)'));
    });

    test('debugError task prompt', () {
      final p = builder.buildTaskPrompt(request, ChatMessageType.debugError);
      expect(p, isNotNull);
      expect(p!, contains('https://api.apidash.dev/users'));
      expect(p.toUpperCase(), contains('GET'));
    });

    test('generateDoc task prompt', () {
      final p = builder.buildTaskPrompt(request, ChatMessageType.generateDoc);
      expect(p, isNotNull);
      expect(p!, contains('https://api.apidash.dev/users'));
      expect(p.toUpperCase(), contains('GET'));
    });

    test('generateTest task prompt', () {
      final p = builder.buildTaskPrompt(request, ChatMessageType.generateTest);
      expect(p, isNotNull);
      expect(p!, contains('https://api.apidash.dev/users'));
      expect(p.toUpperCase(), contains('GET'));
    });

    test('importCurl returns null', () {
      final p = builder.buildTaskPrompt(request, ChatMessageType.importCurl);
      expect(p, isNull);
    });

    test('importOpenApi returns null', () {
      final p = builder.buildTaskPrompt(request, ChatMessageType.importOpenApi);
      expect(p, isNull);
    });

    test('general task prompt', () {
      final p = builder.buildTaskPrompt(request, ChatMessageType.general);
      expect(p, isNotNull);
      // General prompt likely generic; just ensure it's non-empty and does not lose context building.
      expect(p!.trim(), isNotEmpty);
    });

    group('history block', () {
      test('empty history returns empty string', () {
        expect(builder.buildHistoryBlock(const []), isEmpty);
      });

      test('non-empty history includes roles and content', () {
        final now = DateTime.now();
        final history = [
          ChatMessage(
            id: 'h1',
            role: MessageRole.user,
            content: 'Hello',
            timestamp: now,
          ),
          ChatMessage(
            id: 'h2',
            role: MessageRole.system,
            content: 'Hi there',
            timestamp: now.add(const Duration(seconds: 1)),
          ),
        ];
        final block = builder.buildHistoryBlock(history);
        expect(block, contains('<conversation_context>'));
        expect(block, contains('- user: Hello'));
        // system role still treated as assistant in output (non-user branch)
        expect(block, contains('- assistant: Hi there'));
        expect(block, contains('</conversation_context>'));
      });

      test('history truncation uses most recent maxTurns', () {
        final base = DateTime.now();
        final msgs = List.generate(10, (i) {
          return ChatMessage(
            id: 'm$i',
            role: i % 2 == 0 ? MessageRole.user : MessageRole.system,
            content: 'm$i',
            timestamp: base.add(Duration(seconds: i)),
          );
        });
        final block = builder.buildHistoryBlock(msgs); // default maxTurns = 8
        // Oldest two (m0, m1) should not appear.
        expect(block, isNot(contains('m0')));
        expect(block, isNot(contains('m1')));
        // Last message should appear.
        expect(block, contains('m9'));
        // Count of lines with '- ' should be 8.
        final lineCount = '- '.allMatches(block).length;
        expect(lineCount, 8);
      });

      test('custom maxTurns respected', () {
        final base = DateTime.now();
        final msgs = List.generate(5, (i) {
          return ChatMessage(
            id: 'c$i',
            role: MessageRole.user,
            content: 'c$i',
            timestamp: base.add(Duration(seconds: i)),
          );
        });
        final block = builder.buildHistoryBlock(msgs, maxTurns: 2);
        expect(block, isNot(contains('c0')));
        expect(block, isNot(contains('c1')));
        expect(block, contains('c3'));
        expect(block, contains('c4'));
        final lineCount = '- '.allMatches(block).length;
        expect(lineCount, 2);
      });
    });

    test('detectLanguage extended heuristics', () {
      expect(builder.detectLanguage('Please show Go example'), 'Go (net/http)');
      expect(builder.detectLanguage('Some Dart snippet'), 'Dart (http)');
      expect(
        builder.detectLanguage('Use fetch to call this endpoint'),
        'JavaScript (fetch)',
      );
    });

    test('detectLanguage heuristic', () {
      expect(
        builder.detectLanguage('Write this in Python please'),
        contains('Python'),
      );
      expect(builder.detectLanguage('Show me curl'), 'cURL');
      expect(builder.detectLanguage('random text'), isNull);
    });

    test('HTTP context block is byte-identical (WS regression lock)', () {
      // The WS branch in buildContextBlock must not alter the HTTP context
      // path in any way. Exact string fixture — do not "fix" whitespace.
      const expected =
          '<request_context>\n'
          '  Request Name: Get Users\n'
          '\tURL: https://api.apidash.dev/users?size=2\n'
          '\tMethod: GET\n'
          '  Status: 200\n'
          '\tContent-Type: json\n'
          '\tHeaders: { "Accept": "application/json" }\n'
          '\tBody: {"query":"q"}\n'
          '  Response: {"status":"ok"}\n'
          '\t</request_context>';
      expect(builder.buildContextBlock(request), expected);
    });
  });

  group('PromptBuilder WebSocket', () {
    late PromptBuilder builder;

    const wsUrl = 'wss://api.apidash.dev/ws/echo';
    final baseTime = DateTime(2026, 1, 1, 12, 0, 0);

    setUp(() {
      builder = PromptBuilder();
    });

    WebSocketMessage wsMsg(
      WebSocketMessageType type,
      String payload,
      int seconds, {
      bool withTimestamp = true,
    }) {
      return WebSocketMessage(
        payload: payload,
        timestamp: withTimestamp
            ? baseTime.add(Duration(seconds: seconds))
            : null,
        outgoing: type == WebSocketMessageType.sent,
        messageType: type,
      );
    }

    // 25 messages: connected + 22 data messages (alternating sent/received,
    // the last one 200 chars long) + error + disconnected.
    List<WebSocketMessage> lifecycleHistory() {
      return [
        wsMsg(WebSocketMessageType.connected, 'Connected to $wsUrl', 0),
        for (var i = 0; i < 22; i++)
          wsMsg(
            i.isEven
                ? WebSocketMessageType.sent
                : WebSocketMessageType.received,
            i == 21 ? 'y' * 200 : 'data-${i.toString().padLeft(2, '0')}',
            i + 1,
          ),
        wsMsg(WebSocketMessageType.error, 'Server error: policy violation', 23),
        wsMsg(WebSocketMessageType.disconnected, 'Connection closed', 24),
      ];
    }

    RequestModel wsRequest({
      List<WebSocketMessage>? history,
      bool isStreaming = false,
      WebSocketRequestModel? ws,
    }) {
      return RequestModel(
        id: 'ws1',
        name: 'Echo Socket',
        apiType: APIType.websocket,
        isStreaming: isStreaming,
        wsRequestModel:
            ws ??
            WebSocketRequestModel(
              url: wsUrl,
              messageHistory: history ?? lifecycleHistory(),
              headers: const [
                NameValueModel(name: 'Authorization', value: 'Bearer token123'),
                NameValueModel(name: 'X-Disabled', value: 'nope'),
              ],
              isHeaderEnabledList: const [true, false],
              params: const [
                NameValueModel(name: 'room', value: 'lobby'),
                NameValueModel(name: 'notsent', value: 'hidden'),
              ],
              isParamEnabledList: const [true, false],
            ),
      );
    }

    group('WS context block', () {
      test('contains url, derived status, enabled rows; no HTTP fields', () {
        final block = builder.buildContextBlock(wsRequest());
        expect(block, isNotNull);
        expect(block!, contains('Type: WebSocket connection'));
        expect(block, contains('URL: $wsUrl'));
        expect(block, contains('Connection Status: Last attempt failed'));
        // Only enabled headers/params appear.
        expect(block, contains('"Authorization": "Bearer token123"'));
        expect(block, isNot(contains('X-Disabled')));
        expect(block, contains('"room": "lobby"'));
        expect(block, isNot(contains('notsent')));
        expect(block, contains('Heartbeat: off'));
        expect(block, contains('Auto Reconnect: off'));
        expect(
          block,
          contains(
            'Stats: 11 sent, 11 received, 1 connects, 1 disconnects, 1 errors',
          ),
        );
        expect(block, contains('Message Log:'));
        // No HTTP-only fields leak into the WS context block.
        expect(block, isNot(contains('Method:')));
        expect(block, isNot(matches(RegExp(r'^\s*Status:', multiLine: true))));
        expect(block, isNot(contains('Response:')));
        expect(block, isNot(contains('Content-Type:')));
      });

      test('status variant: Currently connected while streaming', () {
        final block = builder.buildContextBlock(wsRequest(isStreaming: true));
        expect(block, contains('Connection Status: Currently connected'));
      });

      test('status variant: Last attempt failed when error precedes close', () {
        final history = [
          wsMsg(WebSocketMessageType.connected, 'open', 0),
          wsMsg(WebSocketMessageType.error, 'boom', 1),
          wsMsg(WebSocketMessageType.disconnected, 'bye', 2),
        ];
        final block = builder.buildContextBlock(wsRequest(history: history));
        expect(block, contains('Connection Status: Last attempt failed'));
      });

      test('status variant: Connection was closed after clean disconnect', () {
        final history = [
          wsMsg(WebSocketMessageType.connected, 'open', 0),
          wsMsg(WebSocketMessageType.sent, 'hello', 1),
          wsMsg(WebSocketMessageType.disconnected, 'bye', 2),
        ];
        final block = builder.buildContextBlock(wsRequest(history: history));
        expect(block, contains('Connection Status: Connection was closed'));
      });

      test('status variant: Never connected without lifecycle events', () {
        final block = builder.buildContextBlock(wsRequest(history: const []));
        expect(block, contains('Connection Status: Never connected'));
      });

      test('heartbeat summary reflects enabled settings', () {
        final ws = const WebSocketRequestModel(
          url: wsUrl,
          enableHeartbeat: true,
          heartbeatInterval: 15,
          enableMessageHeartbeat: true,
          messageHeartbeatInterval: 45,
          messageHeartbeatPayload: 'ping',
          autoReconnect: true,
        );
        final block = builder.buildContextBlock(wsRequest(ws: ws));
        expect(block, contains('keep-alive ping every 15 seconds'));
        expect(block, contains('repeating message "ping" every 45 seconds'));
        expect(block, contains('Auto Reconnect: on'));
      });

      test('buildSystemPrompt for a WS request includes the WS block', () {
        final prompt = builder.buildSystemPrompt(
          wsRequest(),
          ChatMessageType.general,
        );
        expect(prompt, contains('Type: WebSocket connection'));
        expect(prompt, contains('URL: $wsUrl'));
      });
    });

    group('formatWsMessageLog', () {
      test('empty history yields placeholder', () {
        expect(builder.formatWsMessageLog(const []), '(no messages yet)');
      });

      test('default caps keep last 20 data messages and all lifecycle', () {
        final log = builder.formatWsMessageLog(lifecycleHistory());
        expect(log, contains('… [2 earlier messages omitted]'));
        expect(log, isNot(contains('data-00')));
        expect(log, isNot(contains('data-01')));
        expect(log, contains('data-02'));
        expect(log, contains('data-20'));
        // Lifecycle events are always kept, even before the omitted range.
        expect(log, contains('CONNECTED: Connected to'));
        expect(log, contains('ERROR: Server error: policy violation'));
        expect(log, contains('DISCONNECTED: Connection closed'));
        expect(
          log.indexOf('CONNECTED'),
          lessThan(log.indexOf('earlier messages omitted')),
        );
      });

      test('raised caps keep the full log', () {
        final log = builder.formatWsMessageLog(
          lifecycleHistory(),
          maxMessages: 150,
          maxPayloadChars: 300,
        );
        expect(
          log,
          isNot(matches(RegExp(r'\[\d+ earlier messages omitted\]'))),
        );
        expect(log, contains('data-00'));
      });

      test('payload above the cap is truncated with a size suffix', () {
        final history = [wsMsg(WebSocketMessageType.received, 'x' * 350, 0)];
        final log = builder.formatWsMessageLog(history);
        expect(log, contains('${'x' * 300}… [truncated, 350 chars total]'));
        expect(log, isNot(contains('x' * 301)));
      });

      test('raised payload cap leaves the payload untouched', () {
        final history = [wsMsg(WebSocketMessageType.received, 'x' * 350, 0)];
        final log = builder.formatWsMessageLog(history, maxPayloadChars: 350);
        expect(log, contains('x' * 350));
        expect(log, isNot(contains('[truncated')));
      });

      test('timestamps render as ISO-8601 or unknown-time', () {
        final history = [
          wsMsg(WebSocketMessageType.sent, 'hello', 0),
          wsMsg(
            WebSocketMessageType.received,
            'later',
            0,
            withTimestamp: false,
          ),
        ];
        final log = builder.formatWsMessageLog(history);
        expect(log, contains('[2026-01-01T12:00:00.000] SENT: hello'));
        expect(log, contains('[unknown-time] RECEIVED: later'));
      });

      test('maxMessages cap counts only data messages', () {
        final history = [
          wsMsg(WebSocketMessageType.connected, 'open', 0),
          for (var i = 0; i < 5; i++)
            wsMsg(WebSocketMessageType.sent, 'm-$i', i + 1),
          wsMsg(WebSocketMessageType.disconnected, 'bye', 7),
        ];
        final log = builder.formatWsMessageLog(history, maxMessages: 2);
        expect(log, contains('… [3 earlier messages omitted]'));
        expect(log, isNot(contains('m-0')));
        expect(log, contains('m-3'));
        expect(log, contains('m-4'));
        expect(log, contains('CONNECTED: open'));
        expect(log, contains('DISCONNECTED: bye'));
      });
    });

    test('detectWsLanguage maps to WS client library labels', () {
      expect(
        builder.detectWsLanguage('use python please'),
        'Python (websockets)',
      );
      expect(
        builder.detectWsLanguage('a flutter app'),
        'Dart (web_socket_channel)',
      );
      expect(
        builder.detectWsLanguage('dart code'),
        'Dart (web_socket_channel)',
      );
      expect(
        builder.detectWsLanguage('golang sample'),
        'Go (gorilla/websocket)',
      );
      expect(
        builder.detectWsLanguage('go example please'),
        'Go (gorilla/websocket)',
      );
      expect(builder.detectWsLanguage('node.js please'), 'Node.js (ws)');
      expect(
        builder.detectWsLanguage('plain javascript'),
        'JavaScript (WebSocket)',
      );
      expect(
        builder.detectWsLanguage('in the browser'),
        'JavaScript (WebSocket)',
      );
      expect(builder.detectWsLanguage('random text'), isNull);
    });

    group('buildWsConnectionHealthStats', () {
      // Session 1: 90s, ended normally. Session 2: 20s, ended with an error.
      // Session 3: ongoing, 30s measured to the last timestamp.
      List<WebSocketMessage> multiSessionHistory() => [
        wsMsg(WebSocketMessageType.connected, 'open-1', 0),
        wsMsg(WebSocketMessageType.sent, 'a', 10),
        wsMsg(WebSocketMessageType.received, 'b', 20),
        wsMsg(WebSocketMessageType.disconnected, 'close-1', 90),
        wsMsg(WebSocketMessageType.connected, 'open-2', 100),
        wsMsg(WebSocketMessageType.error, 'boom', 110),
        wsMsg(WebSocketMessageType.disconnected, 'close-2', 120),
        wsMsg(WebSocketMessageType.connected, 'open-3', 130),
        wsMsg(WebSocketMessageType.sent, 'c', 140),
        wsMsg(WebSocketMessageType.received, 'd', 150),
        wsMsg(WebSocketMessageType.received, 'e', 160),
      ];

      test('empty history', () {
        expect(
          builder.buildWsConnectionHealthStats(const []),
          'No connection activity yet.',
        );
      });

      test('multi-session timeline: durations, error close, ongoing', () {
        final stats = builder.buildWsConnectionHealthStats(
          multiSessionHistory(),
          isStreaming: true,
        );
        expect(stats, contains('- Sessions: 3 (2 completed, 1 ongoing)'));
        expect(
          stats,
          contains('- Session 1: lasted 1 minute 30 seconds, ended normally'),
        );
        expect(
          stats,
          contains('- Session 2: lasted 20 seconds, ended with an error'),
        );
        expect(
          stats,
          contains('- Session 3: still connected, 30 seconds so far'),
        );
        expect(stats, isNot(contains('Failed connection attempts')));
        expect(
          stats,
          contains(
            '- Totals: 2 sent, 3 received, '
            '3 connects, 2 disconnects, 1 errors',
          ),
        );
        // 5 messages over 140s of connected time -> about 2 per minute.
        expect(
          stats,
          contains('- Rough message rate: about 2 messages per minute'),
        );
        expect(stats, contains('- Current state: Currently connected'));
      });

      test('error outside any session counts as a failed attempt', () {
        final stats = builder.buildWsConnectionHealthStats([
          wsMsg(WebSocketMessageType.error, 'refused', 0),
        ]);
        expect(stats, contains('- Sessions: 0 (0 completed, 0 ongoing)'));
        expect(
          stats,
          contains('- Failed connection attempts (never connected): 1'),
        );
        expect(
          stats,
          contains(
            '- Totals: 0 sent, 0 received, '
            '0 connects, 0 disconnects, 1 errors',
          ),
        );
        expect(stats, isNot(contains('Rough message rate')));
        expect(stats, contains('- Current state: Last attempt failed'));
      });

      test('open span without isStreaming gets a no-clean-end note', () {
        final stats = builder.buildWsConnectionHealthStats([
          wsMsg(WebSocketMessageType.connected, 'open', 0),
          wsMsg(WebSocketMessageType.sent, 'hello', 30),
        ]);
        expect(
          stats,
          contains(
            '- Session 1: lasted 30 seconds, '
            'ended normally (no clean end recorded)',
          ),
        );
        expect(stats, contains('- Sessions: 1 (1 completed, 0 ongoing)'));
      });

      test('connect without close ends the previous span at reconnect', () {
        final stats = builder.buildWsConnectionHealthStats([
          wsMsg(WebSocketMessageType.connected, 'open-1', 0),
          wsMsg(WebSocketMessageType.connected, 'open-2', 60),
          wsMsg(WebSocketMessageType.disconnected, 'bye', 90),
        ]);
        expect(stats, contains('- Sessions: 2 (2 completed, 0 ongoing)'));
        expect(stats, contains('- Session 1: lasted 1 minute, ended normally'));
        expect(
          stats,
          contains('- Session 2: lasted 30 seconds, ended normally'),
        );
      });

      test('missing timestamps yield unknown durations and no rate line', () {
        final stats = builder.buildWsConnectionHealthStats([
          wsMsg(
            WebSocketMessageType.connected,
            'open',
            0,
            withTimestamp: false,
          ),
          wsMsg(WebSocketMessageType.sent, 'hello', 1, withTimestamp: false),
          wsMsg(
            WebSocketMessageType.disconnected,
            'bye',
            2,
            withTimestamp: false,
          ),
        ]);
        expect(
          stats,
          contains('- Session 1: duration unknown, ended normally'),
        );
        expect(stats, isNot(contains('Rough message rate')));
      });

      test('low traffic reports fewer than 1 message per minute', () {
        final stats = builder.buildWsConnectionHealthStats([
          wsMsg(WebSocketMessageType.connected, 'open', 0),
          wsMsg(WebSocketMessageType.sent, 'hello', 10),
          wsMsg(WebSocketMessageType.disconnected, 'bye', 300),
        ]);
        expect(
          stats,
          contains('- Rough message rate: fewer than 1 message per minute'),
        );
        expect(
          stats,
          contains('- Session 1: lasted 5 minutes, ended normally'),
        );
      });

      test('never reports latency metrics (no RTT data exists)', () {
        final outputs = [
          builder.buildWsConnectionHealthStats(const []),
          builder.buildWsConnectionHealthStats(
            multiSessionHistory(),
            isStreaming: true,
          ),
          builder.buildWsConnectionHealthStats(multiSessionHistory()),
          builder.buildWsConnectionHealthStats([
            wsMsg(WebSocketMessageType.error, 'refused', 0),
          ]),
          builder.buildWsConnectionHealthStats(lifecycleHistory()),
        ];
        for (final stats in outputs) {
          expect(stats.toLowerCase(), isNot(contains('latency')));
          expect(stats.toLowerCase(), isNot(contains('round-trip')));
          expect(stats, isNot(contains(' ms')));
        }
      });
    });

    group('WS task-prompt routing', () {
      // 160 data messages (the last one 200 chars long) to exercise the
      // per-task message-log caps precisely.
      List<WebSocketMessage> largeHistory() => [
        wsMsg(WebSocketMessageType.connected, 'open', 0),
        for (var i = 0; i < 159; i++)
          wsMsg(
            i.isEven
                ? WebSocketMessageType.sent
                : WebSocketMessageType.received,
            'bulk-${i.toString().padLeft(3, '0')}',
            i + 1,
          ),
        wsMsg(WebSocketMessageType.received, 'z' * 200, 160),
      ];

      test('explainWsConnection uses default caps 20/300', () {
        final p = builder.buildTaskPrompt(
          wsRequest(history: largeHistory()),
          ChatMessageType.explainWsConnection,
        );
        expect(p, isNotNull);
        expect(p!, contains('Connection Analyst'));
        expect(p, contains('Connection URL: $wsUrl'));
        expect(p, contains('… [140 earlier messages omitted]'));
        // 200-char payload is under the default 300-char cap.
        expect(p, contains('z' * 200));
        expect(p, isNot(contains('[truncated,')));
      });

      test('debugWsConnection routes to the debug prompt', () {
        final p = builder.buildTaskPrompt(
          wsRequest(),
          ChatMessageType.debugWsConnection,
        );
        expect(p, isNotNull);
        expect(p!, contains('Connection Debugging Assistant'));
        expect(p, contains('Connection URL: $wsUrl'));
        expect(p, contains('Connection Status: Last attempt failed'));
      });

      test('findInWsMessages raises caps to 150 messages / 150 chars', () {
        final p = builder.buildTaskPrompt(
          wsRequest(history: largeHistory()),
          ChatMessageType.findInWsMessages,
        );
        expect(p, isNotNull);
        expect(p!, contains('Message Log Analyst'));
        expect(p, contains('… [10 earlier messages omitted]'));
        expect(p, contains('… [truncated, 200 chars total]'));
      });

      test('summarizeWsMessages raises caps to 100 messages / 150 chars', () {
        final p = builder.buildTaskPrompt(
          wsRequest(history: largeHistory()),
          ChatMessageType.summarizeWsMessages,
        );
        expect(p, isNotNull);
        expect(p!, contains('Message Traffic Analyst'));
        expect(p, contains('… [60 earlier messages omitted]'));
        expect(p, contains('… [truncated, 200 chars total]'));
      });

      test('generateWsDoc raises caps to 100 messages / 150 chars', () {
        final p = builder.buildTaskPrompt(
          wsRequest(history: largeHistory()),
          ChatMessageType.generateWsDoc,
        );
        expect(p, isNotNull);
        expect(p!, contains('Documentation Generator'));
        expect(p, contains('… [60 earlier messages omitted]'));
        expect(p, contains('… [truncated, 200 chars total]'));
        expect(
          p,
          contains('Connection Settings: Heartbeat: off; Auto Reconnect: off'),
        );
      });

      test('generateWsTest keeps only 10 messages at 150 chars', () {
        final p = builder.buildTaskPrompt(
          wsRequest(history: largeHistory()),
          ChatMessageType.generateWsTest,
        );
        expect(p, isNotNull);
        expect(p!, contains('Test Case Generator'));
        expect(p, contains('… [150 earlier messages omitted]'));
        expect(p, contains('… [truncated, 200 chars total]'));
        expect(p, contains('"target":"code"'));
        expect(p, isNot(contains('"target":"test"')));
      });

      test('explainWsMessage routes to the message explanation prompt', () {
        final p = builder.buildTaskPrompt(
          wsRequest(),
          ChatMessageType.explainWsMessage,
        );
        expect(p, isNotNull);
        expect(p!, contains('expert Message Analyst'));
        expect(p, contains('Connection URL: $wsUrl'));
      });

      test('debugWsMessage routes to the message debugging prompt', () {
        final p = builder.buildTaskPrompt(
          wsRequest(),
          ChatMessageType.debugWsMessage,
        );
        expect(p, isNotNull);
        expect(p!, contains('Message Debugging Assistant'));
        expect(p, contains('Connection URL: $wsUrl'));
      });

      test('wsConnectionHealth embeds computed health stats', () {
        final p = builder.buildTaskPrompt(
          wsRequest(),
          ChatMessageType.wsConnectionHealth,
        );
        expect(p, isNotNull);
        expect(p!, contains('Connection Health Analyst'));
        expect(p, contains('Connection health stats:'));
        expect(p, contains('- Sessions:'));
      });

      test('generateWsCode without language uses the intro picker', () {
        final p = builder.buildTaskPrompt(
          wsRequest(history: largeHistory()),
          ChatMessageType.generateWsCode,
        );
        expect(p, isNotNull);
        expect(p!, contains('"action":"show_languages"'));
        expect(p, contains('"path":"websocket"'));
        // The intro carries no message log.
        expect(p, isNot(contains('bulk-')));
      });

      test('generateWsCode with language keeps 5 messages at 150 chars', () {
        final p = builder.buildTaskPrompt(
          wsRequest(history: largeHistory()),
          ChatMessageType.generateWsCode,
          overrideLanguage: 'Python (websockets)',
        );
        expect(p, isNotNull);
        expect(p!, contains('Requested Language: Python (websockets)'));
        expect(p, contains('… [155 earlier messages omitted]'));
        expect(p, contains('… [truncated, 200 chars total]'));
        expect(p, isNot(contains('show_languages')));
      });

      test('WS task prompts degrade gracefully without a wsRequestModel', () {
        final req = RequestModel(id: 'ws-null', apiType: APIType.websocket);
        final p = builder.buildTaskPrompt(
          req,
          ChatMessageType.explainWsConnection,
        );
        expect(p, isNotNull);
        expect(p!, contains('Connection URL: N/A'));
      });
    });

    test('getUserMessageForTask returns the WS task phrasing', () {
      expect(
        builder.getUserMessageForTask(ChatMessageType.explainWsConnection),
        "Can you explain what's happening with this connection?",
      );
      expect(
        builder.getUserMessageForTask(ChatMessageType.debugWsConnection),
        "My connection isn't working. Can you help me fix it?",
      );
      expect(
        builder.getUserMessageForTask(ChatMessageType.summarizeWsMessages),
        'What is the server sending me?',
      );
      expect(
        builder.getUserMessageForTask(ChatMessageType.findInWsMessages),
        'Help me find something in my messages.',
      );
      expect(
        builder.getUserMessageForTask(ChatMessageType.explainWsMessage),
        'Can you explain the message I sent?',
      );
      expect(
        builder.getUserMessageForTask(ChatMessageType.debugWsMessage),
        'Why did my message fail?',
      );
      expect(
        builder.getUserMessageForTask(ChatMessageType.wsConnectionHealth),
        'How healthy is my connection?',
      );
      expect(
        builder.getUserMessageForTask(ChatMessageType.generateWsDoc),
        'Can you generate documentation for this connection?',
      );
      expect(
        builder.getUserMessageForTask(ChatMessageType.generateWsTest),
        'Can you generate tests for this connection?',
      );
      expect(
        builder.getUserMessageForTask(ChatMessageType.generateWsCode),
        'Can you generate code for this connection?',
      );
    });
  });
}
