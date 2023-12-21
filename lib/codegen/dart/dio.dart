import 'package:apidash/consts.dart';
import 'package:apidash/models/request_model.dart' show RequestModel;
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import 'shared.dart';

class DartDioCodeGen {
  String? getCode(
    RequestModel requestModel,
    String defaultUriScheme,
  ) {
    try {
      String url = requestModel.url;
      if (!url.contains("://") && url.isNotEmpty) {
        url = "$defaultUriScheme://$url";
      }
      final next = generatedDartCode(
        url: url,
        method: requestModel.method,
        queryParams: requestModel.paramsMap,
        headers: requestModel.headersMap,
        body: requestModel.requestBody,
        contentType: requestModel.requestBodyContentType,
      );
      return next;
    } catch (e) {
      return null;
    }
  }

  String generatedDartCode({
    required String url,
    required HTTPVerb method,
    required Map<String, String> queryParams,
    required Map<String, String> headers,
    required String? body,
    required ContentType contentType,
  }) {
    final sbf = StringBuffer();
    final emitter = DartEmitter();
    final dioImport = Directive.import('package:dio/dio.dart', as: 'dio');
    sbf.writeln(dioImport.accept(emitter));

    Expression? queryParamExp;
    if (queryParams.isNotEmpty) {
      queryParamExp = declareFinal('queryParams').assign(
        literalMap(queryParams.map((key, value) => MapEntry(key, value))),
      );
    }
    Expression? headerExp;
    if (headers.isNotEmpty) {
      headerExp = declareFinal('headers').assign(
        literalMap(headers.map((key, value) => MapEntry(key, value))),
      );
    }

    Expression? dataExp;
    if (kMethodsWithBody.contains(method) && (body?.isNotEmpty ?? false)) {
      final strContent = CodeExpression(Code('r\'\'\'$body\'\'\''));
      switch (contentType) {
        // dio dosen't need pass `content-type` header when body is json or plain text
        case ContentType.json:
          final convertImport = Directive.import('dart:convert', as: 'convert');
          sbf.writeln(convertImport.accept(emitter));
          dataExp = declareFinal('data')
              .assign(refer('convert.json.decode').call([strContent]));
        case ContentType.text:
          dataExp = declareFinal('data').assign(strContent);
        // when add new type of [ContentType], need update [dataExp].
      }
    }
    final responseExp = declareFinal('response').assign(InvokeExpression.newOf(
      refer('dio.Dio'),
      [literalString(url)],
      {
        if (queryParamExp != null) 'queryParameters': refer('queryParams'),
        if (headerExp != null)
          'options': refer('Options').newInstance(
            [],
            {'headers': refer('headers')},
          ),
        if (dataExp != null) 'data': refer('data'),
      },
      [],
      method.name,
    ).awaited);

    final mainFunction = Method((m) {
      final content = declareTryCatch(
        showStackStrace: true,
        body: [
          if (queryParamExp != null) queryParamExp,
          if (headerExp != null) headerExp,
          if (dataExp != null) dataExp,
          responseExp,
          refer('print').call([refer('response').property('statusCode')]),
          refer('print').call([refer('response').property('data')]),
        ],
        onError: {
          'DioException': [
            refer('print').call([
              refer('e').property('response').nullSafeProperty('statusCode'),
            ]),
            refer('print').call([
              refer('e').property('response').nullSafeProperty('data'),
            ]),
            refer('print').call([refer('s')]),
          ],
          null: [
            refer('print').call([refer('e')]),
            refer('print').call([refer('s')]),
          ],
        },
      );
      m
        ..name = 'main'
        ..returns = refer('void')
        ..modifier = MethodModifier.async
        ..body = content;
    });

    sbf.writeln(mainFunction.accept(emitter));

    return DartFormatter(pageWidth: 160).format(sbf.toString());
  }
}
