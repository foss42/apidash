import 'dart:math';
import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';

/// Appends [additions] to [history], retaining at most [max] messages.
///
/// When the combined length would exceed [max], the oldest messages are
/// dropped, making the result a bounded sliding window over the conversation.
/// A new list is always returned, so callers never mutate the list held in
/// Riverpod state.
List<WebSocketMessage> appendWebSocketMessages(
  List<WebSocketMessage> history,
  List<WebSocketMessage> additions, {
  int max = kMaxWebSocketMessages,
}) {
  if (max <= 0) {
    return const [];
  }
  if (additions.isEmpty) {
    return history.length <= max
        ? List<WebSocketMessage>.of(history)
        : history.sublist(history.length - max);
  }
  // Only the trailing [max] additions can survive, so skip building a large
  // intermediate list when a single call adds more than the cap allows.
  if (additions.length >= max) {
    return additions.sublist(additions.length - max);
  }
  final keepFromHistory = max - additions.length;
  final trimmedHistory = history.length <= keepFromHistory
      ? history
      : history.sublist(history.length - keepFromHistory);
  return [...trimmedHistory, ...additions];
}

/// Single-message form of [appendWebSocketMessages].
List<WebSocketMessage> appendWebSocketMessage(
  List<WebSocketMessage> history,
  WebSocketMessage message, {
  int max = kMaxWebSocketMessages,
}) => appendWebSocketMessages(history, [message], max: max);

/// The backoff delay to wait before auto-reconnect attempt number [attempt]
/// (1-based).
///
/// The delay doubles from [kWsReconnectBaseDelay] on each attempt and is capped
/// at [kWsMaxReconnectDelay]. Half of the resulting delay is fixed and the
/// other half is random ("equal jitter"): the random part stops many clients
/// from retrying in lockstep, while the fixed part keeps the delay from
/// collapsing towards zero.
///
/// Pass [random] to make the jitter deterministic in tests.
Duration webSocketReconnectDelay(int attempt, {Random? random}) {
  final n = attempt < 1 ? 1 : attempt;
  final baseMs = kWsReconnectBaseDelay.inMilliseconds;
  final capMs = kWsMaxReconnectDelay.inMilliseconds;

  // Clamp before shifting: [attempt] is caller-supplied and a large shift
  // overflows to a negative value rather than saturating.
  final shift = n - 1;
  final int scaledMs;
  if (shift >= 32 || baseMs > capMs >> shift) {
    scaledMs = capMs;
  } else {
    scaledMs = baseMs << shift;
  }
  final cappedMs = scaledMs > capMs ? capMs : scaledMs;

  final fixedMs = cappedMs ~/ 2;
  final jitterMs = (random ?? Random()).nextInt(cappedMs - fixedMs + 1);
  return Duration(milliseconds: fixedMs + jitterMs);
}

/// Whether a connection opened at [connectedAt] and closed at [closedAt] stayed
/// up long enough to count as recovered, which resets the reconnect backoff
/// ladder.
///
/// Sessions shorter than [threshold] leave the ladder escalating, so a server
/// that accepts and immediately closes keeps backing off (and eventually gives
/// up) instead of being retried at a fixed rate forever.
bool webSocketConnectionWasStable(
  DateTime connectedAt,
  DateTime closedAt, {
  Duration threshold = kWsConnectionStableAfter,
}) =>
    closedAt.difference(connectedAt) >= threshold;
