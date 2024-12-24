import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';

class Importer {
  Future<List<HttpRequestModel>?> getHttpRequestModelList(
    ImportFormat fileType,
    String content,
  ) async {
    return switch (fileType) {
      ImportFormat.curl => CurlIO().getHttpRequestModelList(content),
      ImportFormat.postman => null
    };
  }
}

final kImporter = Importer();
