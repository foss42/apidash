import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart' show requestModelToHARJsonRequest;
import 'package:apidash/models/models.dart' show RequestModel;

class HARCodeGen {
  String? getCode(
    RequestModel requestModel,
    String defaultUriScheme,
  ) {
    try {
      var harString = kEncoder.convert(requestModelToHARJsonRequest(
        requestModel,
        defaultUriScheme: defaultUriScheme,
        useEnabled: true,
      ));
      return harString;
    } catch (e) {
      return null;
    }
  }
}
