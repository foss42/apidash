import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_core/import_export/har_io.dart';

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
      ImportFormat.har => HarIO().getHttpRequestModelList(content)
          ?.map((t) => (null, t))
          .toList(),
      ImportFormat.insomnia => InsomniaIO().getHttpRequestModelList(content),
      ImportFormat.postman => PostmanIO().getHttpRequestModelList(content),
    };
  }
}


final kImporter = Importer();
