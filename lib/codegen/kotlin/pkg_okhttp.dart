import 'package:apidash/consts.dart';

import '../../models/request_model.dart';

class KotlinOkHttpCodeGen {
  final String headerSnippet = """import okhttp3.MediaType.Companion.toMediaType
import okhttp3.MultipartBody
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.RequestBody.Companion.asRequestBody
import java.io.File
import java.util.concurrent.TimeUnit

val client = OkHttpClient()
""";

  final String footerSnippet = """  .build()
val response = client.newCall(request).execute()

println(response.body!!.string())
""";
  String getCode(RequestModel requestModel) {
    String result = "";
    result = result + headerSnippet;
    if (requestModel.method != HTTPVerb.get &&
        requestModel.method != HTTPVerb.head) {
      result =
          """${result}val mediaType = "${requestModel.requestBodyContentType == ContentType.json ? "application/json" : "text/plain"}".toMediaType()
val body = "${requestModel.requestBody}".toRequestBody(mediaType)\n""";
    }
    result = "${result}val request = Request.Builder()\n";

    result = "$result  .url(\"${requestModel.url}\")\n";
    result = result + addQueryParams(requestModel);
    result = result + addRequestMethod(requestModel);
    result = result + addHeaders(requestModel);
    result = result + footerSnippet;

    return result;
  }

  String addQueryParams(RequestModel requestModel) {
    String result = "";
    if (requestModel.requestParams == null) {
      return result;
    }
    for (final queryParam in requestModel.requestParams!) {
      result =
          """$result  .addQueryParameter("${queryParam.k}", "${queryParam.v}")\n""";
    }
    return result;
  }

  String addHeaders(RequestModel requestModel) {
    String result = "";
    if (requestModel.requestHeaders == null) {
      return result;
    }
    for (final header in requestModel.requestHeaders!) {
      result = """$result  .addHeader("${header.k}", "${header.v}")\n""";
    }
    return result;
  }

  String addRequestMethod(RequestModel requestModel) {
    String result = "";
    if (requestModel.method != HTTPVerb.get &&
        requestModel.method != HTTPVerb.head &&
        requestModel.method != HTTPVerb.delete) {
      result = """$result  .${requestModel.method.name}(body)\n""";
    } else if (requestModel.method == HTTPVerb.head) {
      result = """$result  .${requestModel.method.name}()\n""";
    }
    if (requestModel.method == HTTPVerb.delete) {
      result = """$result  .method("DELETE", body)\n""";
    }
    return result;
  }
}
