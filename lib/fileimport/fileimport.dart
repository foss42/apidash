import 'package:apidash/consts.dart';
import 'package:apidash/fileimport/curl/curl.dart';
import 'package:apidash/models/request_model.dart';

class FileImport {
  Future<RequestModel?> getRequestModel(FileType fileType, String contents, String newId) async {
    switch (fileType) {
      case FileType.curl:
        return CurlFileImport().getRequestModel(contents, newId);
      default:
        return null;
    }
  }
}