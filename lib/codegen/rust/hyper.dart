import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/utils/utils.dart' show getValidRequestUri, stripUriParams;
import '../../models/request_model.dart';
import 'package:apidash/consts.dart';

class RustHyperCodeGen {
  final String kTemplateStart = '''
use std::io::Read;
use hyper::Client;

fn main() {
    let client = Client::new();

''';

  final String kTemplateUrl = '''

    let url = "{{url}}";

''';

  final String kTemplateUrlQuery = '''

    let mut url = "{{url}}".parse().unwrap();
{{params}}
''';

  String kTemplateRequestBody = '''

    let body = "{{body}}";

''';

  final String kStringRequestStart = '''

    let mut response = client.get(url)
        .send()
        .unwrap();

    let mut body = String::new();
    response.read_to_string(&mut body).unwrap();

    println!("{}", body);
}

''';

  String? getCode(
    RequestModel requestModel,
    String defaultUriScheme,
  ) {
    try {
      String result = "";
      bool hasQuery = false;

      String url = requestModel.url;
      if (!url.contains("://") && url.isNotEmpty) {
        url = "$defaultUriScheme://$url";
      }

      var rec = getValidRequestUri(
        url,
        requestModel.enabledRequestParams,
      );
      Uri? uri = rec.$1;

      if (uri != null) {
        String url = stripUriParams(uri);

        if (uri.hasQuery) {
          var params = uri.queryParameters;
          if (params.isNotEmpty) {
            hasQuery = true;
            var templateParams = jj.Template(kTemplateUrlQuery);
            result += templateParams
                .render({"url": url, "params": getQueryParams(params)});
          }
        }
        if (!hasQuery) {
          var templateUrl = jj.Template(kTemplateUrl);
          result += templateUrl.render({"url": url});
        }

        var method = requestModel.method;
        var requestBody = requestModel.requestBody;
        if (kMethodsWithBody.contains(method) && requestBody != null) {
          var templateBody = jj.Template(kTemplateRequestBody);
          result += templateBody.render({"body": requestBody});
        }

        var templateStart = jj.Template(kTemplateStart);
        result = templateStart.render({}) + result;

        result += kStringRequestStart;
      }
      return result;
    } catch (e) {
      return null;
    }
  }

  String getQueryParams(Map<String, String> params) {
    String result = "";
    for (final k in params.keys) {
      result += """    url.query_pairs_mut().append_pair("$k", "${params[k]}");\n""";
    }
    return result;
  }
}
