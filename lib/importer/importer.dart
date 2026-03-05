import 'package:apidash/consts.dart';
import 'package:apidash/utils/http_utils.dart';
import 'package:apidash_core/apidash_core.dart';

class Importer {
  Future<List<(String?, HttpRequestModel)>?> getHttpRequestModelList(
    ImportFormat fileType,
    String content,
  ) async {
    return switch (fileType) {
      ImportFormat.curl => CurlIO()
          .getHttpRequestModelList(content)
          ?.map((t) => (deriveRequestName(t.method, t.url), t))
          .toList(),
      ImportFormat.postman => PostmanIO().getHttpRequestModelList(content),
      ImportFormat.insomnia => InsomniaIO().getHttpRequestModelList(content),
      ImportFormat.har => HarParserIO()
          .getHttpRequestModelList(content)
          ?.map((req) => (deriveRequestName(req.$2.method, req.$2.url), req.$2))
          .toList(),
    };
  }
}

final kImporter = Importer();