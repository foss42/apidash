import 'dart:convert';
import 'package:apidash/utils/har_utils.dart';
import 'package:apidash/utils/http_utils.dart';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/models/models.dart' show RequestModel;
import 'package:apidash/consts.dart';

class JavaUnirestGen {
  final String kTemplateUnirestImports = '''
import kong.unirest.core.*;\n
''';

  final String kTemplateFileIoImports = '''
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;\n
''';
  final String kTemplateStart = '''
public class Main {
    public static void main(String[] args) {
''';

  final String kTemplateUrl = '''
        final String requestURL = "{{url}}";\n
''';

  final String kTemplateRequestBodyContent = '''
        final String requestBody = "{{body}}";\n
''';

  final String kTemplateRequestCreation = '''
        HttpResponse<JsonNode> response = Unirest
                .{{method}}(requestURL)\n
''';

  final String kTemplateRequestHeader = '''
                .header("{{name}}", "{{value}}")\n
''';

  final String kTemplateContentType = '''
                .contentType("{{contentType}}")\n
''';

  final String kTemplateUrlQueryParam = '''
                .queryString("{{name}}", "{{value}}")\n
''';

}
