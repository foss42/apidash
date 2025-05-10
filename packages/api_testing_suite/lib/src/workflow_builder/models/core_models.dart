import 'package:apidash_core/models/http_request_model.dart';

/// Basic representation of an API request model
class RequestModel {
  final String id;
  final String name;
  final String method;
  final String url;
  final HttpRequestModel httpRequestModel;
  
  const RequestModel({
    required this.id,
    required this.httpRequestModel,
    this.name = '',
    this.method = 'GET',
    this.url = '',
  });

  RequestModel copyWith({
    String? method,
    String? url,
    String? name,
    HttpRequestModel? httpRequestModel,
  }) {
    return RequestModel(
      id: id,
      method: method ?? this.method,
      url: url ?? this.url,
      name: name ?? this.name,
      httpRequestModel: httpRequestModel ?? this.httpRequestModel,
    );
  }
}
