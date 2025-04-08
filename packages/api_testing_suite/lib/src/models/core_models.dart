/// Temporary placeholder for apidash_core models

/// Basic representation of an API request model
class RequestModel {
  final String id;
  final String name;
  final String method;
  final String url;
  
  const RequestModel({
    required this.id,
    this.name = '',
    this.method = 'GET',
    this.url = '',
  });
}
