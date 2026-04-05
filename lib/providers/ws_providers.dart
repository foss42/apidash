import 'dart:async';
import 'dart:math' as math;
import 'package:apidash_core/apidash_core.dart'; // re-exports better_networking → WsMessage, WsMessageType, ContentType, wsManager
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

enum WsConnectionStatus { idle, connecting, connected, disconnected, error }

class WsState {
  final WsConnectionStatus status;
  final List<WsMessage> messages;
  final String messageInput;
  final bool autoReconnect;
  final int reconnectAttempt;

  const WsState({
    this.status = WsConnectionStatus.idle,
    this.messages = const [],
    this.messageInput = '',
    this.autoReconnect = false,
    this.reconnectAttempt = 0,
  });

  WsState copyWith({
    WsConnectionStatus? status,
    List<WsMessage>? messages,
    String? messageInput,
    bool? autoReconnect,
    int? reconnectAttempt,
  }) =>
      WsState(
        status: status ?? this.status,
        messages: messages ?? this.messages,
        messageInput: messageInput ?? this.messageInput,
        autoReconnect: autoReconnect ?? this.autoReconnect,
        reconnectAttempt: reconnectAttempt ?? this.reconnectAttempt,
      );

  bool get isConnected => status == WsConnectionStatus.connected;
  bool get isConnecting => status == WsConnectionStatus.connecting;
  bool get canSend => isConnected && messageInput.isNotEmpty;
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class WsStateNotifier extends StateNotifier<WsState> {
  final String requestId;
  StreamSubscription<WsMessage>? _sub;
  Timer? _reconnectTimer;
  String? _lastUrl;
  Map<String, String>? _lastHeaders;

  /// Maximum number of auto-reconnect attempts before giving up.
  static const int _maxReconnectAttempts = 5;

  WsStateNotifier(this.requestId) : super(const WsState());

  /// Toggle auto-reconnect on/off.
  void setAutoReconnect(bool enabled) {
    state = state.copyWith(autoReconnect: enabled);
    if (!enabled) {
      _reconnectTimer?.cancel();
      _reconnectTimer = null;
    }
  }

  /// Connect to [url] and start listening for messages.
  Future<void> connect(String url, {Map<String, String>? headers}) async {
    if (url.isEmpty) return;
    _lastUrl = url;
    _lastHeaders = headers;
    _reconnectTimer?.cancel();

    state = state.copyWith(
      status: WsConnectionStatus.connecting,
      messages: [],
    );

    // Start listening to the manager's message stream BEFORE connecting
    // so we don't miss the "Connecting…" message emitted by the manager.
    await _sub?.cancel();
    _sub = wsManager.messagesStream(requestId).listen((msg) {
      state = state.copyWith(messages: [...state.messages, msg]);

      if (msg.type == WsMessageType.connected &&
          msg.content.startsWith('Connected')) {
        state = state.copyWith(
          status: WsConnectionStatus.connected,
          reconnectAttempt: 0,
        );
      } else if (msg.type == WsMessageType.disconnected ||
          msg.type == WsMessageType.error) {
        state = state.copyWith(status: WsConnectionStatus.disconnected);
        _scheduleReconnect();
      }
    });

    await wsManager.connect(
      requestId: requestId,
      url: url,
      headers: headers,
      onError: (_) {
        state = state.copyWith(status: WsConnectionStatus.error);
        _scheduleReconnect();
      },
      onDone: () {
        state = state.copyWith(status: WsConnectionStatus.disconnected);
        _scheduleReconnect();
      },
    );
  }

  /// Schedule an auto-reconnect with exponential backoff.
  void _scheduleReconnect() {
    if (!state.autoReconnect) return;
    if (_lastUrl == null || _lastUrl!.isEmpty) return;
    if (state.reconnectAttempt >= _maxReconnectAttempts) {
      // Add a status message about giving up
      state = state.copyWith(
        messages: [
          ...state.messages,
          WsMessage(
            content:
                'Auto-reconnect: gave up after $_maxReconnectAttempts attempts',
            type: WsMessageType.error,
            timestamp: DateTime.now(),
          ),
        ],
      );
      return;
    }

    final attempt = state.reconnectAttempt + 1;
    final delaySec = math.min(math.pow(2, attempt).toInt(), 30);

    state = state.copyWith(
      reconnectAttempt: attempt,
      messages: [
        ...state.messages,
        WsMessage(
          content:
              'Auto-reconnect: attempt $attempt in ${delaySec}s…',
          type: WsMessageType.disconnected,
          timestamp: DateTime.now(),
        ),
      ],
    );

    _reconnectTimer = Timer(Duration(seconds: delaySec), () {
      if (mounted && state.autoReconnect && !state.isConnected) {
        connect(_lastUrl!, headers: _lastHeaders);
      }
    });
  }

  void send() {
    if (!state.canSend) return;
    wsManager.send(requestId, state.messageInput);
    state = state.copyWith(messageInput: '');
  }

  void updateMessageInput(String value) {
    state = state.copyWith(messageInput: value);
  }

  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    state = state.copyWith(autoReconnect: false);
    await wsManager.disconnect(requestId);
    state = state.copyWith(status: WsConnectionStatus.disconnected);
  }

  void clearMessages() {
    state = state.copyWith(messages: []);
  }

  @override
  void dispose() {
    _sub?.cancel();
    _reconnectTimer?.cancel();
    wsManager.disconnect(requestId);
    super.dispose();
  }
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

/// A family provider — one notifier per requestId.
final wsStateProvider =
    StateNotifierProvider.family<WsStateNotifier, WsState, String>(
  (ref, requestId) => WsStateNotifier(requestId),
);

/// Content type for the compose message editor (JSON / text).
final wsMessageContentTypeProvider =
    StateProvider.family<ContentType, String>(
  (ref, requestId) => ContentType.text,
);
