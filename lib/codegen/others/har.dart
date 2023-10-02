import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart' show requestModelToHARJsonRequest;
import 'package:apidash/models/models.dart' show RequestModel;

class HARCodeGen {
  String? getCode(RequestModel requestModel) {
    try {
      var harString =
          kEncoder.convert(requestModelToHARJsonRequest(requestModel));
      return harString;
    } catch (e) {
      return null;
    }
  }
}
