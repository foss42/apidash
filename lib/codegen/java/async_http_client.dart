import 'dart:convert';
import 'package:apidash/utils/har_utils.dart';
import 'package:apidash/utils/http_utils.dart';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/models/models.dart' show RequestModel;
import 'package:apidash/consts.dart';

class JavaAsyncHttpClientGen {
  final String kTemplateStart = '''
import org.asynchttpclient.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Executors;
import java.util.stream.Collectors;

public class Main {
    public static void main(String[] args) {
        try (AsyncHttpClient asyncHttpClient = Dsl.asyncHttpClient()) {
''';

  final String kTemplateUrl = '''
            String url = "{{url}}";\n
''';

  final String kTemplateRequestCreation = '''
            Request request = asyncHttpClient
                .prepare("{{method}}", url)\n
''';

  final String kTemplateUrlQueryParam = '''
                .addQueryParam("{{name}}", "{{value}}")\n
''';

  final String kTemplateRequestHeader = '''
                .addHeader("{{name}}", "{{value}}")\n
''';
  final String kTemplateRequestFormData = '''
                .addFormParam("{{name}}", "{{value}}")\n
''';

  String kTemplateRequestBodyContent = '''
            String bodyContent = "{{body}}";\n
''';
  String kTemplateRequestBodySetup = '''
                .setBody(bodyContent)\n
''';

  final String kTemplateRequestEnd = """
                .build();
            ListenableFuture<Response> listenableFuture = asyncHttpClient.executeRequest(request);
            listenableFuture.addListener(() -> {
                try {
                    Response response = listenableFuture.get();
                    InputStream is = response.getResponseBodyAsStream();
                    BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
                    String respBody = br.lines().collect(Collectors.joining("\\n"));
                    System.out.println(response.getStatusCode());
                    System.out.println(respBody);
                } catch (InterruptedException | ExecutionException e) {
                    e.printStackTrace();
                }
            }, Executors.newCachedThreadPool());
            listenableFuture.get();
        } catch (InterruptedException | ExecutionException | IOException ignored) {

        }
    }
}
\n
""";

}
