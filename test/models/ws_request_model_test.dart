import 'package:apidash/models/models.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';

import 'ws_request_models.dart';

void main() {
  group('WebSocketMessage', () {
    test('Testing copyWith', () {
      var msg = wsMessage1;
      final msgCopyWith = msg.copyWith(payload: 'Bye');
      expect(msgCopyWith.payload, 'Bye');
      // original model unchanged
      expect(msg.payload, 'Hello');
    });

    test('Testing toJson', () {
      var msg = wsMessage1;
      expect(msg.toJson(), wsMessage1Json);
    });

    test('Testing fromJson', () {
      final msgFromJson = WebSocketMessage.fromJson(wsMessage2Json);
      expect(msgFromJson, wsMessage2);
    });

    test('Default values', () {
      var msg = wsMessage3;
      expect(msg.outgoing, true);
      expect(msg.messageType, WebSocketMessageType.received);
    });

    test('Testing immutability', () {
      var msg = wsMessage1;
      var msg2 = msg.copyWith(payload: msg.payload);
      expect(msg.payload, msg2.payload);
      expect(identical(msg.payload, msg2.payload), true);
    });

    test('Null timestamp serializes and deserializes', () {
      expect(wsMessageNullTimestamp.timestamp, isNull);
      expect(wsMessageNullTimestamp.toJson(), wsMessageNullTimestampJson);
      final back = WebSocketMessage.fromJson(wsMessageNullTimestampJson);
      expect(back, wsMessageNullTimestamp);
      expect(back.timestamp, isNull);
    });

    test('fromJson with missing optional keys yields defaults', () {
      final msg = WebSocketMessage.fromJson({'payload': 'OnlyPayload'});
      expect(msg.payload, 'OnlyPayload');
      expect(msg.timestamp, isNull);
      expect(msg.outgoing, true);
      expect(msg.messageType, WebSocketMessageType.received);
    });

    test('messageType.connected round-trips', () {
      expect(wsMessageConnected.toJson(), wsMessageConnectedJson);
      expect(
        WebSocketMessage.fromJson(wsMessageConnectedJson),
        wsMessageConnected,
      );
      expect(
        WebSocketMessage.fromJson(wsMessageConnectedJson).messageType,
        WebSocketMessageType.connected,
      );
    });

    test('messageType.sent round-trips', () {
      expect(wsMessageSent.toJson(), wsMessageSentJson);
      expect(WebSocketMessage.fromJson(wsMessageSentJson), wsMessageSent);
      expect(
        WebSocketMessage.fromJson(wsMessageSentJson).messageType,
        WebSocketMessageType.sent,
      );
    });

    test('messageType.received round-trips', () {
      expect(wsMessageReceived.toJson(), wsMessageReceivedJson);
      expect(
        WebSocketMessage.fromJson(wsMessageReceivedJson),
        wsMessageReceived,
      );
      expect(
        WebSocketMessage.fromJson(wsMessageReceivedJson).messageType,
        WebSocketMessageType.received,
      );
    });

    test('messageType.error round-trips', () {
      expect(wsMessageError.toJson(), wsMessageErrorJson);
      expect(WebSocketMessage.fromJson(wsMessageErrorJson), wsMessageError);
      expect(
        WebSocketMessage.fromJson(wsMessageErrorJson).messageType,
        WebSocketMessageType.error,
      );
    });

    test('messageType.disconnected round-trips', () {
      expect(wsMessageDisconnected.toJson(), wsMessageDisconnectedJson);
      expect(
        WebSocketMessage.fromJson(wsMessageDisconnectedJson),
        wsMessageDisconnected,
      );
      expect(
        WebSocketMessage.fromJson(wsMessageDisconnectedJson).messageType,
        WebSocketMessageType.disconnected,
      );
    });

    test('Every WebSocketMessageType value round-trips through JSON', () {
      for (final type in WebSocketMessageType.values) {
        final original = WebSocketMessage(payload: 'p', messageType: type);
        final back = WebSocketMessage.fromJson(original.toJson());
        expect(back, original, reason: 'round-trip failed for $type');
        expect(back.messageType, type);
      }
    });

    test('copyWith timestamp/outgoing/messageType change only that field', () {
      final base = wsMessage1; // outgoing true, sent, has timestamp
      final newTs = DateTime.parse('2024-06-14T12:00:00.000');

      final byTs = base.copyWith(timestamp: newTs);
      expect(byTs.timestamp, newTs);
      expect(byTs.payload, base.payload);
      expect(byTs.outgoing, base.outgoing);
      expect(byTs.messageType, base.messageType);

      final byOut = base.copyWith(outgoing: false);
      expect(byOut.outgoing, false);
      expect(byOut.payload, base.payload);
      expect(byOut.timestamp, base.timestamp);
      expect(byOut.messageType, base.messageType);

      final byType = base.copyWith(
        messageType: WebSocketMessageType.disconnected,
      );
      expect(byType.messageType, WebSocketMessageType.disconnected);
      expect(byType.payload, base.payload);
      expect(byType.outgoing, base.outgoing);
      expect(byType.timestamp, base.timestamp);
    });

    test('Equality and hashCode', () {
      final a = WebSocketMessage(
        payload: 'Hello',
        timestamp: DateTime.parse('2023-01-01T00:00:00.000'),
        outgoing: true,
        messageType: WebSocketMessageType.sent,
      );
      final b = WebSocketMessage(
        payload: 'Hello',
        timestamp: DateTime.parse('2023-01-01T00:00:00.000'),
        outgoing: true,
        messageType: WebSocketMessageType.sent,
      );
      expect(a, b);
      expect(a.hashCode, b.hashCode);

      // Differing on a single field breaks equality.
      expect(a == b.copyWith(payload: 'Bye'), false);
      expect(a == b.copyWith(outgoing: false), false);
      expect(a == b.copyWith(messageType: WebSocketMessageType.error), false);
      expect(
        a ==
            b.copyWith(timestamp: DateTime.parse('2024-01-01T00:00:00.000')),
        false,
      );
    });
  });

  group('WebSocketRequestModel', () {
    test('Testing copyWith', () {
      var model = wsRequestModel1;
      final modelCopyWith = model.copyWith(url: 'wss://test.websocket.org');
      expect(modelCopyWith.url, 'wss://test.websocket.org');
      // original model unchanged
      expect(model.url, 'wss://echo.websocket.org');
    });

    test('Testing toJson', () {
      var model = wsRequestModel1;
      expect(model.toJson(), wsRequestModel1Json);
    });

    test('Testing fromJson', () {
      final modelFromJson = WebSocketRequestModel.fromJson(wsRequestModel2Json);
      expect(modelFromJson, wsRequestModel2);
    });

    test('Default values', () {
      var model = wsRequestModel3;
      expect(model.url, '');
      expect(model.messageHistory, isEmpty);
      expect(model.autoReconnect, false);
      expect(model.enableHeartbeat, false);
      expect(model.heartbeatInterval, 30);
    });

    test('Testing immutability', () {
      var model = wsRequestModel1;
      var model2 = model.copyWith(headers: model.headers);
      expect(model.headers, model2.headers);
      expect(identical(model.headers, model2.headers), false);
      var model3 = model.copyWith(headers: null);
      expect(model3.headers, null);
    });

    test('Full round-trip with headers/params populated', () {
      // toJson then fromJson yields an equal model.
      final json = wsRequestModel1.toJson();
      expect(json, wsRequestModel1Json);
      final back = WebSocketRequestModel.fromJson(json);
      expect(back, wsRequestModel1);
      // Spot-check the populated optional collections survived.
      expect(back.headers, [const NameValueModel(name: 'Auth', value: 'Bearer 123')]);
      expect(back.isHeaderEnabledList, [true]);
      expect(back.params, [const NameValueModel(name: 'id', value: '1')]);
      expect(back.isParamEnabledList, [true]);
    });

    test('fromJson with missing optional keys yields defaults', () {
      final model = WebSocketRequestModel.fromJson(const {});
      expect(model.url, '');
      expect(model.messageHistory, isEmpty);
      expect(model.headers, isNull);
      expect(model.isHeaderEnabledList, isNull);
      expect(model.params, isNull);
      expect(model.isParamEnabledList, isNull);
      expect(model.autoReconnect, false);
      expect(model.enableHeartbeat, false);
      expect(model.heartbeatInterval, 30);
    });

    test('fromJson with explicit null optionals yields defaults', () {
      final model = WebSocketRequestModel.fromJson(wsRequestModel2Json);
      expect(model, wsRequestModel2);
      expect(model.heartbeatInterval, 30);
      expect(model.headers, isNull);
    });

    test('messageHistory with multiple messages round-trips', () {
      expect(wsRequestModelMultiHistory.toJson(), wsRequestModelMultiHistoryJson);
      final back =
          WebSocketRequestModel.fromJson(wsRequestModelMultiHistoryJson);
      expect(back, wsRequestModelMultiHistory);
      expect(back.messageHistory.length, 3);
      expect(back.messageHistory[0].payload, 'first');
      expect(back.messageHistory[1].outgoing, false);
      expect(back.messageHistory[2].messageType, WebSocketMessageType.error);
      expect(back.messageHistory[2].timestamp, isNull);
    });

    test('copyWith url changes only url', () {
      final base = wsRequestModel1;
      final c = base.copyWith(url: 'wss://changed.org');
      expect(c.url, 'wss://changed.org');
      expect(c.messageHistory, base.messageHistory);
      expect(c.headers, base.headers);
      expect(c.params, base.params);
      expect(c.autoReconnect, base.autoReconnect);
      expect(c.enableHeartbeat, base.enableHeartbeat);
      expect(c.heartbeatInterval, base.heartbeatInterval);
      expect(base.url, 'wss://echo.websocket.org');
    });

    test('copyWith headers changes only headers', () {
      final base = wsRequestModel1;
      final newHeaders = const [NameValueModel(name: 'X', value: 'Y')];
      final c = base.copyWith(headers: newHeaders);
      expect(c.headers, newHeaders);
      expect(c.url, base.url);
      expect(c.params, base.params);
      expect(c.isHeaderEnabledList, base.isHeaderEnabledList);
      expect(c.autoReconnect, base.autoReconnect);
      expect(c.heartbeatInterval, base.heartbeatInterval);
    });

    test('copyWith params changes only params', () {
      final base = wsRequestModel1;
      final newParams = const [NameValueModel(name: 'q', value: 'v')];
      final c = base.copyWith(params: newParams);
      expect(c.params, newParams);
      expect(c.url, base.url);
      expect(c.headers, base.headers);
      expect(c.isParamEnabledList, base.isParamEnabledList);
      expect(c.autoReconnect, base.autoReconnect);
    });

    test('copyWith autoReconnect changes only autoReconnect', () {
      final base = wsRequestModel1; // autoReconnect true
      final c = base.copyWith(autoReconnect: false);
      expect(c.autoReconnect, false);
      expect(c.url, base.url);
      expect(c.enableHeartbeat, base.enableHeartbeat);
      expect(c.heartbeatInterval, base.heartbeatInterval);
      expect(base.autoReconnect, true);
    });

    test('copyWith enableHeartbeat changes only enableHeartbeat', () {
      final base = wsRequestModel1; // enableHeartbeat true
      final c = base.copyWith(enableHeartbeat: false);
      expect(c.enableHeartbeat, false);
      expect(c.url, base.url);
      expect(c.autoReconnect, base.autoReconnect);
      expect(c.heartbeatInterval, base.heartbeatInterval);
      expect(base.enableHeartbeat, true);
    });

    test('copyWith heartbeatInterval changes only heartbeatInterval', () {
      final base = wsRequestModel1; // heartbeatInterval 15
      final c = base.copyWith(heartbeatInterval: 99);
      expect(c.heartbeatInterval, 99);
      expect(c.url, base.url);
      expect(c.autoReconnect, base.autoReconnect);
      expect(c.enableHeartbeat, base.enableHeartbeat);
      expect(base.heartbeatInterval, 15);
    });

    test('copyWith messageHistory changes only messageHistory', () {
      final base = wsRequestModel1;
      final newHistory = const [
        WebSocketMessage(payload: 'only', messageType: WebSocketMessageType.sent)
      ];
      final c = base.copyWith(messageHistory: newHistory);
      expect(c.messageHistory, newHistory);
      expect(c.url, base.url);
      expect(c.headers, base.headers);
      expect(c.params, base.params);
      expect(c.autoReconnect, base.autoReconnect);
      expect(base.messageHistory.length, 1);
      expect(base.messageHistory.first.payload, 'Ping');
    });

    test('Equality and hashCode', () {
      const a = WebSocketRequestModel(
        url: 'wss://x.org',
        autoReconnect: true,
        heartbeatInterval: 42,
      );
      const b = WebSocketRequestModel(
        url: 'wss://x.org',
        autoReconnect: true,
        heartbeatInterval: 42,
      );
      expect(a, b);
      expect(a.hashCode, b.hashCode);

      // Differing on any single field breaks equality.
      expect(a == b.copyWith(url: 'wss://y.org'), false);
      expect(a == b.copyWith(autoReconnect: false), false);
      expect(a == b.copyWith(enableHeartbeat: true), false);
      expect(a == b.copyWith(heartbeatInterval: 1), false);
      expect(
        a ==
            b.copyWith(
              headers: const [NameValueModel(name: 'h', value: 'v')],
            ),
        false,
      );
    });
  });
}
