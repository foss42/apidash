import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
import 'curl/curl.dart';

class Importer {
  Future<HttpRequestModel?> getHttpRequestModel(
    ImportFormat fileType,
    String content,
  ) async {
    switch (fileType) {
      case ImportFormat.curl:
        return CurlFileImport().getHttpRequestModel(content);
    }
  }
}
