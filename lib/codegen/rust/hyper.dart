import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/utils/utils.dart' show getValidRequestUri, stripUriParams;
import '../../models/request_model.dart';
import 'package:apidash/consts.dart';
import 'dart:io';
import 'dart:convert';
// import 'package:hyper/hyper.dart' as hyper;
// import 'package:hyper/http.dart' as http;

class RustHyperCodeGen {
  final String kTemplateStart = '''
use std::io::Read;
use hyper::Client;
use hyper::header::{HeaderMap, HeaderValue};

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

  String kTemplateHeader = '''
    headers.insert("{{key}}", HeaderValue::from_static("{{value}}"));
''';

  final String kStringRequestStart = '''

    let mut request = client.{{method}}(url);


    let mut headers = HeaderMap::new();
{{headers}}
    *request.headers_mut() = headers;

    let mut response = request.send().unwrap();

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

        // Render headers
        var method = requestModel.method;
        var headers = requestModel.enabledHeadersMap;
if (headers.isNotEmpty) {
    var headerCode = headers.entries.map((entry) {
        var templateHeader = jj.Template(kTemplateHeader);
        return templateHeader.render({"key": entry.key, "value": entry.value});
    }).join('\n');
    var additional = jj.Template(kStringRequestStart);
    result += additional.render({"method": method.name.toLowerCase(), "headers": headerCode});
} else {
    var additional = jj.Template(kStringRequestStart);
    result += additional.render({"method": method.name.toLowerCase(), "headers": ""});
}
        var templateStart = jj.Template(kTemplateStart);
        result = templateStart.render({}) + result;
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
