import 'dart:convert';
import 'dart:io';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:apidash/models/models.dart' show RequestModel;
import 'package:apidash/consts.dart';
import 'shared.dart';

class DartHttpCodeGen {
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
        queryParams: requestModel.enabledParamsMap,
        headers: {...requestModel.enabledHeadersMap},
        contentType: requestModel.requestBodyContentType,
        hasContentTypeHeader: requestModel.hasContentTypeHeader,
        body: requestModel.requestBody,
        formData: requestModel.formDataMapList,
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
    required ContentType contentType,
    required String? body,
    required bool hasContentTypeHeader,
    required List<Map<String, dynamic>> formData,
  }) {
    final uri = Uri.parse(url);

    final sbf = StringBuffer();
    final emitter = DartEmitter();
    final dioImport = Directive.import('package:http/http.dart', as: 'http');
    sbf.writeln(dioImport.accept(emitter));

    final uriExp =
        declareVar('uri').assign(refer('Uri.parse').call([literalString(url)]));

    Expression? dataExp;
    if (kMethodsWithBody.contains(method) && (body?.isNotEmpty ?? false)) {
      final strContent = CodeExpression(Code('r\'\'\'$body\'\'\''));
      dataExp = declareVar('body', type: refer('String')).assign(strContent);
      if (!hasContentTypeHeader) {
        headers.putIfAbsent(
            HttpHeaders.contentTypeHeader, () => contentType.header);
      }
    }

    Expression? queryParamExp;
    List<Expression>? uriReassignExps;
    //     var urlQueryParams = Map<String,String>.from(uri.queryParameters);
    // urlQueryParams.addAll(queryParams);
    // uri = uri.replace(queryParameters: urlQueryParams);

    if (queryParams.isNotEmpty) {
      queryParamExp = declareVar('queryParams').assign(
        literalMap(queryParams.map((key, value) => MapEntry(key, value))),
      );

      uriReassignExps = [
        if (uri.hasQuery)
          declareVar('urlQueryParams').assign(
            InvokeExpression.newOf(
              refer('Map<String,String>'),
              [refer('uri.queryParameters')],
              {},
              [],
              'from',
            ),
          ),
        if (uri.hasQuery)
          refer('urlQueryParams')
              .property('addAll')
              .call([refer('queryParams')], {}),
        refer('uri').assign(refer('uri').property('replace').call([], {
          'queryParameters':
              uri.hasQuery ? refer('urlQueryParams') : refer('queryParams'),
        }))
      ];
    }

    Expression? headerExp;
    if (headers.isNotEmpty) {
      headerExp = declareVar('headers').assign(
        literalMap(headers.map((key, value) => MapEntry(key, value))),
      );
    }
    final responseExp = declareFinal('response').assign(InvokeExpression.newOf(
      refer(
        'http.${method.name}',
      ),
      [refer('uri')],
      {
        if (headerExp != null) 'headers': refer('headers'),
        if (dataExp != null) 'body': refer('body'),
      },
      [],
    ).awaited);
    final multiPartRequest =
        declareFinal('request').assign(InvokeExpression.newOf(
      refer(
        'http.MultipartRequest',
      ),
      [refer(jsonEncode(method.name.toUpperCase())), refer('uri')],
    ));
    final multiPartFiles = declareFinal('formDataList').assign(refer(
      jsonEncode(formData),
    ));

    final addHeaders = refer('request.headers.addAll').call([refer('headers')]);
    const multiPartList = Code('''
    for (Map<String, String> formData in formDataList){
          if (formData['type'] == 'text') {
              request.fields.addAll({formData['name']: formData['value']});
            } else {
              request.files.add(
                await http.MultipartFile.fromPath(
                  formData['name'],
                  formData['value'],
                ),
              );
          }
  }
''');
    var multiPartRequestSend =
        declareFinal('response').assign(refer('request.send()').awaited);
    var multiPartResponseBody = declareFinal('responseBody')
        .assign(refer('response.stream.bytesToString()').awaited);
    final mainFunction = Method((m) {
      final statusRef = refer('statusCode');
      m
        ..name = 'main'
        ..returns = refer('void')
        ..modifier = MethodModifier.async
        ..body = Block((b) {
          b.statements.add(uriExp.statement);
          if (queryParamExp != null) {
            b.statements.add(const Code('\n'));
            b.statements.add(queryParamExp.statement);
          }
          if (uriReassignExps != null) {
            b.statements.addAll(uriReassignExps.map((e) => e.statement));
          }
          if (dataExp != null) {
            b.statements.add(const Code('\n'));
            b.statements.add(dataExp.statement);
          }
          if (headerExp != null) {
            b.statements.add(const Code('\n'));
            b.statements.add(headerExp.statement);
          }
          b.statements.add(const Code('\n'));
          if (contentType == ContentType.formdata) {
            if (formData.isNotEmpty) {
              b.statements.add(multiPartFiles.statement);
            }
            b.statements.add(multiPartRequest.statement);
            if (formData.isNotEmpty) {
              b.statements.add(multiPartList);
            }
            if (headerExp != null) {
              b.statements.add(addHeaders.statement);
            }
            b.statements.add(multiPartRequestSend.statement);
            b.statements.add(multiPartResponseBody.statement);
            b.statements.add(declareVar('statusCode', type: refer('int'))
                .assign(refer('response').property('statusCode'))
                .statement);
            b.statements.add(const Code('\n'));
          } else {
            b.statements.add(responseExp.statement);
            b.statements.add(const Code('\n'));
            b.statements.add(declareVar('statusCode', type: refer('int'))
                .assign(refer('response').property('statusCode'))
                .statement);
          }

          b.statements.add(declareIfElse(
            condition: statusRef
                .greaterOrEqualTo(literalNum(200))
                .and(statusRef.lessThan(literalNum(300))),
            body: [
              refer('print').call([literalString(r'Status Code: $statusCode')]),
              refer('print').call([
                literalString(
                    'Response Body: ${contentType == ContentType.formdata ? ':\$responseBody' : '\${response.body}'}')
              ]),
            ],
            elseBody: [
              refer('print')
                  .call([literalString(r'Error Status Code: $statusCode')]),
              refer('print').call([
                literalString(
                    'Error Response Body: ${contentType == ContentType.formdata ? ':\$responseBody' : '\${response.body}'}')
              ]),
            ],
          ));
        });
    });

    sbf.writeln(mainFunction.accept(emitter));

    return DartFormatter(
            pageWidth: contentType == ContentType.formdata ? 70 : 160)
        .format(sbf.toString());
  }
}
