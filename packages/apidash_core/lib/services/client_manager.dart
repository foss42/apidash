import 'package:http/http.dart' as http;

class HttpClientManager {
  static final HttpClientManager _instance = HttpClientManager._internal();
  final Map<String, http.Client> _clients = {};

  factory HttpClientManager() {
    return _instance;
  }

  HttpClientManager._internal();

  http.Client createClient(String requestId) {
    final client = http.Client();
    _clients[requestId] = client;
    return client;
  }

  void cancelRequest(String requestId) {
    if (_clients.containsKey(requestId)) {
      _clients[requestId]?.close();
      _clients.remove(requestId);
    }
  }

  void closeClient(String requestId) {
    cancelRequest(requestId);
  }

  bool hasActiveClient(String requestId) {
    return _clients.containsKey(requestId);
  }
}
