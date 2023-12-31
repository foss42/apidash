import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';

extension RequestModelExtension on RequestModel {
  bool get isFormDataRequest {
    return requestBodyContentType == ContentType.formdata;
  }
}
