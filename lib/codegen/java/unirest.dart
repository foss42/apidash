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
}
