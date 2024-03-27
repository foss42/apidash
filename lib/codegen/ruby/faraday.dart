import 'package:apidash/consts.dart';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/utils/utils.dart' show getValidRequestUri;
import 'package:apidash/utils/http_utils.dart' show stripUriParams;

import 'package:apidash/models/models.dart' show RequestModel;

// Note that delete is a special case in Faraday as API Dash supports request
// body inside delete reqest, but Faraday does not. Hence we need to manually
// setup request body for delete request and add that to request.
//
// Refer https://lostisland.github.io/faraday/#/getting-started/quick-start?id=get-head-delete-trace
class RubyFaradayCodeGen {

  final String kStringFaradayRequireStatement = """
require 'uri'
require 'faraday'
""";

  final String kStringFaradayMultipartRequireStatement = '''
require 'faraday/multipart'
''';
}
