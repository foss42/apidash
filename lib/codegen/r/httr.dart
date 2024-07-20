import 'package:apidash/utils/http_utils.dart';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/models/models.dart';

class RhttrCodeGen {
  final String kTemplateStart = '''
install.packages("httr")
library(httr)
''';

  final String kTemplateUrl = '''
url <- "{{url}}"
''';

  final String kTemplateQueryParams = '''
params <- list(
{{params}}
)
''';

  final String kTemplateHeaders = '''
headers <- c(
{{headers}}
)
''';

  final String kTemplateBody = '''
body <- "{{body}}"
''';

  final String kTemplateRequest = '''
response <- {{method}}(
  url,
  query = params,
  add_headers(.headers=headers),
  body = body,
  encode = "json"
)
print(content(response, "text"))
''';

  String? getCode(
    HttpRequestModel requestModel,
  ) {
    try {
      String result = kTemplateStart;

      // Validate and process the URL
      String url = requestModel.url;
      if (!url.contains("://") && url.isNotEmpty) {
        url = "http://$url\n";
      }

      var rec = getValidRequestUri(
        url,
        requestModel.enabledParams,
      );
      Uri? uri = rec.$1;

      if (uri != null) {
        String strippedUrl = stripUrlParams(uri.toString());

        // Add URL to the result
        var templateUrl = jj.Template(kTemplateUrl);
        result += templateUrl.render({"url": strippedUrl});

        // Handle query parameters
        if (uri.hasQuery) {
          var params = uri.queryParameters;
          if (params.isNotEmpty) {
            var queryParams = params.entries.map((entry) {
              return """  "${entry.key}" = "${entry.value}" """;
            }).join(",\n");
            var templateQueryParams = jj.Template(kTemplateQueryParams);
            result += templateQueryParams.render({"params": queryParams});
          }
        }

        // Handle headers
        var headers = requestModel.enabledHeadersMap;
        if (headers.isNotEmpty) {
          var headerCode = headers.entries.map((entry) {
            return """  "${entry.key}" = "${entry.value}" """;
          }).join(",\n");
          var templateHeaders = jj.Template(kTemplateHeaders);
          result += templateHeaders.render({"headers": headerCode});
        }

        // Handle body
        if (requestModel.body != null) {
          var templateBody = jj.Template(kTemplateBody);
          result += templateBody.render({"body": requestModel.body});
        }
        // Add request execution
        var templateRequest = jj.Template(kTemplateRequest);
        result += templateRequest
            .render({"method": requestModel.method.name.toLowerCase()});
      }
      return result;
    } catch (e) {
      return null;
    }
  }
}
