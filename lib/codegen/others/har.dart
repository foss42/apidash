import 'package:better_networking/better_networking.dart';
import '../../utils/utils.dart';

class HARCodeGen {
  String? getCode(
    HttpRequestModel requestModel, {
    String? boundary,
  }) {
    try {
      var harString = kJsonEncoder.convert(requestModelToHARJsonRequest(
        requestModel,
        useEnabled: true,
        boundary: boundary,
      ));
      return harString;
    } catch (e) {
      return null;
    }
  }
}
