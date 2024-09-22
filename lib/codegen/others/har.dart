import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart' show requestModelToHARJsonRequest;
import 'package:apidash/models/models.dart';

class HARCodeGen {
  String? getCode(
    HttpRequestModel requestModel,
    String defaultUriScheme, {
    String? boundary,
  }) {
    try {
      var harString = kJsonEncoder.convert(requestModelToHARJsonRequest(
        requestModel,
        defaultUriScheme: defaultUriScheme,
        useEnabled: true,
        boundary: boundary,
      ));
      return harString;
    } catch (e) {
      return null;
    }
  }
}
