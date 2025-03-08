import 'package:test/test.dart';
import 'package:apidash_core/models/proxy_settings_model.dart';

void main() {
  const proxySettings = ProxySettings(
    host: 'localhost',
    port: '8080',
    username: 'user',
    password: 'pass',
  );

  test('Testing toJson()', () {
    const expectedResult = {
      'host': 'localhost',
      'port': '8080',
      'username': 'user',
      'password': 'pass',
    };
    expect(proxySettings.toJson(), expectedResult);
  });

  test('Testing fromJson()', () {
    const input = {
      'host': 'localhost',
      'port': '8080',
      'username': 'user',
      'password': 'pass',
    };
    expect(ProxySettings.fromJson(input), proxySettings);
  });

  test('Testing default values', () {
    const defaultSettings = ProxySettings();
    expect(defaultSettings.host, '');
    expect(defaultSettings.port, '');
    expect(defaultSettings.username, null);
    expect(defaultSettings.password, null);
  });

  test('Testing equality', () {
    const settings1 = ProxySettings(
      host: 'localhost',
      port: '8080',
      username: 'user',
      password: 'pass',
    );
    const settings2 = ProxySettings(
      host: 'localhost',
      port: '8080',
      username: 'user',
      password: 'pass',
    );
    expect(settings1, settings2);
  });
}
