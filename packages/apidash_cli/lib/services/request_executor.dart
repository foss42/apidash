import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/cli_models.dart';

Future<(CliHttpResponse?, Duration?, String?)> executeCliRequest(
  CliRequest request,
) async {
  if (request.apiType == CliApiType.ai) {
    return (null, null, 'AI requests are not supported by the CLI runner yet.');
  }

  final requestModel = request.httpRequestModel;
  final uri = requestModel.buildUri();
  if (uri == null) {
    return (null, null, 'Invalid URL: ${requestModel.url}');
  }

  final headers = requestModel.enabledHeadersMap;
  final client = http.Client();
  final stopwatch = Stopwatch()..start();

  try {
    if (request.apiType == CliApiType.graphql) {
      final gqlBody = requestModel.requestBodyFor(CliApiType.graphql);
      if (gqlBody != null &&
          gqlBody.isNotEmpty &&
          !requestModel.hasContentTypeHeader) {
        headers[HttpHeaders.contentTypeHeader] = 'application/json';
      }

      final gqlRequest = http.Request(CliHttpVerb.post.upperName, uri)
        ..headers.addAll(headers)
        ..body = gqlBody ?? '';
      final streamed = await client.send(gqlRequest);
      final response = await http.Response.fromStream(streamed);
      stopwatch.stop();

      return (
        CliHttpResponse.fromHttpResponse(response, time: stopwatch.elapsed),
        stopwatch.elapsed,
        null,
      );
    }

    if (requestModel.hasFormDataContentType &&
        requestModel.method.supportsBody &&
        requestModel.formData.isNotEmpty) {
      final multipart = http.MultipartRequest(requestModel.method.upperName, uri)
        ..headers.addAll(headers);

      for (final field in requestModel.formData) {
        if (field.name.isEmpty) {
          continue;
        }

        if (field.isText) {
          multipart.fields[field.name] = field.value;
          continue;
        }

        if (field.value.isEmpty) {
          continue;
        }

        multipart.files.add(
          await http.MultipartFile.fromPath(field.name, field.value),
        );
      }

      final streamed = await client.send(multipart);
      final response = await http.Response.fromStream(streamed);
      stopwatch.stop();

      return (
        CliHttpResponse.fromHttpResponse(response, time: stopwatch.elapsed),
        stopwatch.elapsed,
        null,
      );
    }

    final body = requestModel.requestBodyFor(CliApiType.rest);
    if (body != null && body.isNotEmpty && !requestModel.hasContentTypeHeader) {
      headers[HttpHeaders.contentTypeHeader] = requestModel.bodyContentTypeHeader;
    }

    final outbound = http.Request(requestModel.method.upperName, uri)
      ..headers.addAll(headers);

    if (requestModel.method.supportsBody && body != null) {
      outbound.body = body;
    }

    final streamed = await client.send(outbound);
    final response = await http.Response.fromStream(streamed);
    stopwatch.stop();

    return (
      CliHttpResponse.fromHttpResponse(response, time: stopwatch.elapsed),
      stopwatch.elapsed,
      null,
    );
  } catch (e) {
    stopwatch.stop();
    return (null, stopwatch.elapsed, e.toString());
  } finally {
    client.close();
  }
}
