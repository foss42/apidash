import 'package:apidash/models/models.dart';
import 'package:apidash_core/apidash_core.dart';
import 'rule_input.dart';

class RuleInputAdapter {
  const RuleInputAdapter();

  RuleInput fromRequestModel(
    RequestModel requestModel, {
    bool endpointLikelyProtected = false,
  }) {
    final http = requestModel.httpRequestModel ?? const HttpRequestModel();

    final headers = <String, String>{};
    final allHeaders = http.headers ?? const <NameValueModel>[];
    final enabled = http.isHeaderEnabledList ?? const <bool>[];

    for (int i = 0; i < allHeaders.length; i++) {
      final isEnabled = i < enabled.length ? enabled[i] : true;
      if (!isEnabled) continue;

      final key = allHeaders[i].name.trim();
      final value = allHeaders[i].value.trim();
      if (key.isEmpty) continue;
      headers[key] = value;
    }

    return RuleInput(
      method: http.method.name.toUpperCase(),
      url: http.url,
      headers: headers,
      body: http.body,
      endpointLikelyProtected:
          endpointLikelyProtected || _hasAuthType(http.authModel?.type),
    );
  }

  bool _hasAuthType(APIAuthType? type) {
    if (type == null) return false;
    return type != APIAuthType.none;
  }
}