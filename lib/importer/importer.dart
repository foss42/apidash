import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';

class Importer {
  Future<List<HttpRequestModel>?> getHttpRequestModel(
    ImportFormat fileType,
    String content,
  ) async {
    return switch (fileType) {
      ImportFormat.curl => CurlIO().getHttpRequestModel(content),
      ImportFormat.postman => null
    };
  }
}

final kImporter = Importer();
