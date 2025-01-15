import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/proxy_config.dart';

final proxyConfigProvider = StateNotifierProvider<ProxyNotifier, ProxyConfig>((ref) {
  return ProxyNotifier();
});

class ProxyNotifier extends StateNotifier<ProxyConfig> {
  ProxyNotifier() : super(ProxyConfig()) {
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    state = await ProxyConfig.load();
  }

  Future<void> updateConfig({
    bool? isEnabled,
    String? host,
    String? port,
    String? username,
    String? password,
  }) async {
    state = ProxyConfig(
      isEnabled: isEnabled ?? state.isEnabled,
      host: host ?? state.host,
      port: port ?? state.port,
      username: username ?? state.username,
      password: password ?? state.password,
    );
    await ProxyConfig.save(state);
  }

  String? getProxyUrl() {
    if (!state.isEnabled || state.host.isEmpty || state.port.isEmpty) {
      return null;
    }
    final auth = (state.username?.isNotEmpty ?? false) && (state.password?.isNotEmpty ?? false)
        ? '${state.username}:${state.password}@'
        : '';
    return 'http://$auth${state.host}:${state.port}';
  }

  // Debug method to print proxy configuration
  void printProxyConfig() {
    print('Proxy Configuration:');
    print('Enabled: ${state.isEnabled}');
    print('Host: ${state.host}');
    print('Port: ${state.port}');
    print('Username: ${state.username != null ? '***' : null}');
    print('Password: ${state.password != null ? '***' : null}');
    print('Proxy URL: ${getProxyUrl() ?? 'Not configured'}');
  }
}
