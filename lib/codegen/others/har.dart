import 'package:apidash_core/apidash_core.dart';
import '../../utils/utils.dart';

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
