import 'package:better_networking/better_networking.dart';
import 'package:better_networking/services/http_service.dart';
import 'package:test/test.dart';

void main() {
  group('Network error message integration', () {
    const unreachableModel = HttpRequestModel(
      url: 'https://this-host-should-not-exist.apidash.invalid',
      method: HTTPVerb.get,
    );

    test('sendHttpRequest maps connection failures to friendly message', () async {
      final (_, _, err) = await sendHttpRequest(
        'friendly_error_send_test',
        APIType.rest,
        unreachableModel,
      );

      expect(err, kMsgConnectionFailed);
    });

    test('streamHttpRequest maps connection failures to friendly message', () async {
      final stream = await streamHttpRequest(
        'friendly_error_stream_test',
        APIType.rest,
        unreachableModel,
      );
      final output = await stream.first;

      expect(output?.$4, kMsgConnectionFailed);
    });
  });
}
