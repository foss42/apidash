import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';

class Importer {
  Future<List<(String?, HttpRequestModel)>?> getHttpRequestModelList(
    ImportFormat fileType,
    String content,
  ) async {
    return switch (fileType) {
      ImportFormat.curl => CurlIO()
          .getHttpRequestModelList(content)
          ?.map((t) => (null, t))
          .toList(),
      ImportFormat.postman => PostmanIO().getHttpRequestModelList(content),
      ImportFormat.insomnia => InsomniaIO().getHttpRequestModelList(content),
    };
  }
}

final kImporter = Importer();
