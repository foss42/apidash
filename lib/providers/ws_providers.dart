import 'dart:async';
import 'package:apidash_core/apidash_core.dart'; // re-exports better_networking → WsMessage, wsManager
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

enum WsConnectionStatus { idle, connecting, connected, disconnected, error }

class WsState {
  final WsConnectionStatus status;
  final List<WsMessage> messages;
  final String messageInput;

  const WsState({
    this.status = WsConnectionStatus.idle,
    this.messages = const [],
    this.messageInput = '',
  });

  WsState copyWith({
    WsConnectionStatus? status,
    List<WsMessage>? messages,
    String? messageInput,
  }) =>
      WsState(
        status: status ?? this.status,
        messages: messages ?? this.messages,
        messageInput: messageInput ?? this.messageInput,
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

  WsStateNotifier(this.requestId) : super(const WsState());

  /// Connect to [url] and start listening for messages.
  Future<void> connect(String url, {Map<String, String>? headers}) async {
    if (url.isEmpty) return;
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
        state = state.copyWith(status: WsConnectionStatus.connected);
      } else if (msg.type == WsMessageType.disconnected ||
          msg.type == WsMessageType.error) {
        state = state.copyWith(status: WsConnectionStatus.disconnected);
      }
    });

    await wsManager.connect(
      requestId: requestId,
      url: url,
      headers: headers,
      onError: (_) {
        state = state.copyWith(status: WsConnectionStatus.error);
      },
      onDone: () {
        state = state.copyWith(status: WsConnectionStatus.disconnected);
      },
    );
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
    await wsManager.disconnect(requestId);
    state = state.copyWith(status: WsConnectionStatus.disconnected);
  }

  void clearMessages() {
    state = state.copyWith(messages: []);
  }

  @override
  void dispose() {
    _sub?.cancel();
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
