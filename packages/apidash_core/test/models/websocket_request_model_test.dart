import 'package:apidash_core/apidash_core.dart';
import 'package:seed/models/name_value_model.dart';
import 'package:test/test.dart';

void main() {
  group('WebSocketMessageModel', () {
    test('supports value equality', () {
      final message1 = WebSocketMessageModel(
        message: 'Hello',
        time: DateTime(2023, 1, 1),
        isSent: true,
      );
      final message2 = WebSocketMessageModel(
        message: 'Hello',
        time: DateTime(2023, 1, 1),
        isSent: true,
      );
      expect(message1, equals(message2));
    });

    test('toJson and fromJson work correctly', () {
      final message = WebSocketMessageModel(
        message: 'Hello',
        time: DateTime(2023, 1, 1),
        isSent: true,
      );
      final json = message.toJson();
      expect(json, {
        'message': 'Hello',
        'time': '2023-01-01T00:00:00.000',
        'isSent': true,
      });
      final fromJson = WebSocketMessageModel.fromJson(json);
      expect(fromJson, equals(message));
    });
  });

  group('WebSocketRequestModel', () {
    test('supports value equality', () {
      final request1 = WebSocketRequestModel(
        url: 'ws://example.com',
        messages: [
          WebSocketMessageModel(
            message: 'Hello',
            time: DateTime(2023, 1, 1),
            isSent: true,
          )
        ],
      );
      final request2 = WebSocketRequestModel(
        url: 'ws://example.com',
        messages: [
          WebSocketMessageModel(
            message: 'Hello',
            time: DateTime(2023, 1, 1),
            isSent: true,
          )
        ],
      );
      expect(request1, equals(request2));
    });

    test('defaults are correct', () {
      const request = WebSocketRequestModel();
      expect(request.url, '');
      expect(request.headers, isEmpty);
      expect(request.params, isEmpty);
      expect(request.messages, isEmpty);
    });

    test('toJson and fromJson work correctly', () {
      final request = WebSocketRequestModel(
        url: 'ws://example.com',
        headers: [const NameValueModel(name: 'Auth', value: '123')],
        messages: [
          WebSocketMessageModel(
            message: 'Hello',
            time: DateTime(2023, 1, 1),
            isSent: true,
          )
        ],
      );
      final json = request.toJson();
      expect(json['url'], 'ws://example.com');
      expect((json['headers'] as List).first['name'], 'Auth');
      expect((json['messages'] as List).first['message'], 'Hello');

      final fromJson = WebSocketRequestModel.fromJson(json);
      expect(fromJson, equals(request));
    });
  });
}
