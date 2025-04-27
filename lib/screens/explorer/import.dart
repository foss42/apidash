import 'package:apidash/models/models.dart';
import 'package:apidash_core/apidash_core.dart';

class ImportedRequestData {
  final HttpRequestModel? httpRequestModel;

  ImportedRequestData(this.httpRequestModel);

  // Static default instance for null cases
  static final ImportedRequestData _default = ImportedRequestData(
    HttpRequestModel(
      url: '',
      method: HTTPVerb.get,
      headers: [],
      params: [],
    ),
  );

  // Factory constructor to return default instance if null
  factory ImportedRequestData.empty() => _default;
}

ImportedRequestData importRequestData(RequestModel? requestModel) {
  final httpRequestModel = requestModel?.httpRequestModel ?? HttpRequestModel();
  return ImportedRequestData(httpRequestModel);
}