import 'package:better_networking/src/web_auth/web_auth_stub.dart';
import 'package:test/test.dart';

void main() {
  test('WebAuthClient throws UnsupportedError in CLI mode', () async {
    expect(
      () => WebAuthClient.authenticate(
        url: Uri.parse('https://example.com'),
        callbackUrlScheme: 'myapp',
      ),
      throwsUnsupportedError,
    );
  });
}
