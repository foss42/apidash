import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/utils/utils.dart' show getValidRequestUri;
import '../../models/request_model.dart';

class KotlinRetrofitCodeGen {
  final String kTemplateStart = """
import retrofit2.http.*
import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

interface ApiService {

""";

  final String kTemplateEnd = """
}

fun main() {
    val service = Retrofit.Builder()
        .baseUrl("{{baseUrl}}")
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(ApiService::class.java)

    // Call your API methods here using service object
}

""";

  String kMethodTemplate = '''
    @{{method}}("{{endpoint}}"{{queryParameters}}{{hasBodyAnnotation}}){{headers}}
    fun {{methodName}}({{parameters}}): Call<ResponseBody>
''';

  String? getCode(RequestModel requestModel) {
    try {
      String result = "";
      String baseUrl = "";
      List<String> methodAnnotations = [];
      List<String> queryParameters = [];
      String headersAnnotation = "";

      var rec = getValidRequestUri(
        requestModel.url,
        requestModel.enabledRequestParams,
      );
      Uri? uri = rec.$1;

      if (uri != null) {
        baseUrl = uri.origin;

        var method = requestModel.method;
        var endpoint = stripUriParams(uri);
        var methodName = requestModel.name;

        // Handle query parameters
        var params = uri.queryParameters;
        if (params.isNotEmpty) {
          for (var param in params.entries) {
            queryParameters
                .add("@Query(\"${param.key}\") ${param.key}: String");
          }
        }

        // Handle headers
        var headers = requestModel.enabledHeadersMap;
        if (headers.isNotEmpty) {
          headersAnnotation = headers.entries
              .map((header) =>
                  '@Header("${header.value}") ${header.key}: String')
              .join('\n    ');
        }

        // Add annotations for HTTP method and possible body
        var hasBodyAnnotation = "";
        if (requestModel.hasJsonData || requestModel.hasTextData) {
          hasBodyAnnotation = ", @Body requestBody: RequestBody";
        }

        methodAnnotations.add(method.name.toUpperCase());

        var parameters = '';
        // If request body is FormData, add its parameters to method signature
        if (requestModel.hasFormData) {
          var formData = requestModel.formDataMapList;
          for (var item in formData) {
            parameters +=
                "@Field(\"${item['value']}\") ${item['name']} : String,";
          }
          parameters = parameters.substring(
              0, parameters.length - 1); // Remove last comma
        }

        result +=
            kMethodTemplate.replaceAllMapped(RegExp(r'\{\{(\w+)\}\}'), (match) {
          switch (match[1]) {
            case 'method':
              return methodAnnotations.join(', ');
            case 'endpoint':
              return endpoint.replaceFirst(
                  baseUrl, ""); // Ensure the endpoint is relative
            case 'queryParameters':
              return queryParameters.isNotEmpty
                  ? ", ${queryParameters.join(", ")}"
                  : "";
            case 'hasBodyAnnotation':
              return hasBodyAnnotation;
            case 'headers':
              return headersAnnotation;
            case 'methodName':
              return methodName;
            case 'parameters':
              return parameters;
            default:
              return match[0]!;
          }
        });
      }

      var templateStart = jj.Template(kTemplateStart);
      result = templateStart.render() + result;

      var templateEnd = jj.Template(kTemplateEnd);
      result += templateEnd.render({"baseUrl": baseUrl});

      return result;
    } catch (e) {
      return null;
    }
  }
}

String stripUriParams(Uri uri) {
  return uri.path;
}
