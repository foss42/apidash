import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:insomnia_collection/models/insomnia_environment.dart';

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

class EnvImporter {
  Future<InsomniaEnvironment?> getInsomniaEnvironment(
      ImportFormat fileType, String content) async {
    return switch (fileType) {
      ImportFormat.insomnia => InsomniaIO().getInsomiaEnvironment(content),
      _ => null
    };
  }
}

final kImporter = Importer();
final kEnvImporter = EnvImporter();
