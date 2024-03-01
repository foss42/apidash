import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/utils/utils.dart' show getValidRequestUri, stripUriParams;
import '../../models/request_model.dart';
import 'package:apidash/consts.dart';

class RustNetHttpCodeGen {
  final String kTemplateStart = '''
use std::io::Read;
use std::net::TcpStream;
use std::io::prelude::*;
use std::str;
fn main() {
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
    let mut stream = TcpStream::connect("{{host}}:{{port}}").unwrap();
    let mut request = String::new();
    request.push_str("{{method}} ");
    request.push_str(url.as_str());
    request.push_str(" HTTP/1.1\\r\\n");
    request.push_str("Host: {{host}}\\r\\n ");
    request.push_str("\\r\\n");
    request.push_str("Connection: close\\r\\n");
    request.push_str("\\r\\n");
    stream.write(request.as_bytes()).unwrap();

    let mut response = String::new();
    stream.read_to_string(&mut response).unwrap();
    println!("{}", response);
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
      var additional = jj.Template(kStringRequestStart);
      result += additional.render({
        "method": method.name.toUpperCase(),
        "host": uri.host,
        "port": uri.port.toString(),
      });

      var requestBody = requestModel.requestBody;
      if (kMethodsWithBody.contains(method) && requestBody != null) {
        var templateBody = jj.Template(kTemplateRequestBody);
        result += templateBody.render({"body": requestBody});
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
