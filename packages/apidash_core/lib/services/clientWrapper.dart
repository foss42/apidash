import 'package:apidash_core/services/clientWrapper.dart' as http;
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;

abstract class clientWrapper {
  void close() {}
}

class HttpClientWrapper extends clientWrapper {
  final http.Client client;
  HttpClientWrapper(this.client);
   @override
  void close() {
    client.close(); 
  }
}

class GraphQLClientWrapper extends clientWrapper {
  final GraphQLClient client;
  GraphQLClientWrapper(this.client);
   @override
  void close() {
    client.cache.store.reset();; 
  }
}
