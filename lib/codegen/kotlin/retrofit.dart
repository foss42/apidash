import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/utils/utils.dart' show getValidRequestUri;
import '../../models/request_model.dart';

class KotlinRetrofitCodeGen {
  final String kTemplateInterfaceStart = """import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.*

interface ApiService {
""";

  final String kTemplateFunction = """
    @{{httpMethod}}("{{urlPath}}")
    fun {{functionName}}({{parameters}})
""";

  final String kRetrofitSetup = """
fun getApiService(): ApiService {
    val retrofit = Retrofit.Builder()
        .baseUrl("{{baseUrl}}")
        .addConverterFactory(GsonConverterFactory.create())
        .build()

    return retrofit.create(ApiService::class.java)
}
""";

  String? getCode(
    RequestModel requestModel,
    String defaultUriScheme,
  ) {
    try {
      String result = "";
      String baseUrl = getValidRequestUri(requestModel.url, []).$1.toString();
      baseUrl =
          baseUrl.substring(0, baseUrl.indexOf("/", 8)); // Extracting base URL
      String path = requestModel.url.substring(baseUrl.length);

      var methodName =
          "callApi"; // This should ideally be derived or set based on the context

      var httpMethod = requestModel.method.name.toUpperCase();
      var parameters = "";

      if (requestModel.isFormDataRequest) {
        parameters += "@Body body: RequestBody";
      } else if (requestModel.requestBody != null &&
          requestModel.requestBody!.isNotEmpty) {
        parameters += "@Body body: RequestBody";
      }

      var templateFunction = jj.Template(kTemplateFunction);
      result += templateFunction.render({
        "httpMethod": httpMethod,
        "urlPath": path,
        "functionName": methodName,
        "parameters": parameters,
      });

      var templateInterfaceStart = jj.Template(kTemplateInterfaceStart);
      result = "${templateInterfaceStart.render({})}$result}\n\n";

      var retrofitSetup = jj.Template(kRetrofitSetup);
      result += retrofitSetup.render({"baseUrl": baseUrl});

      return result;
    } catch (e) {
      return null;
    }
  }
}
