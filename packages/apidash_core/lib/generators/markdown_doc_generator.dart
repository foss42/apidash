import 'dart:convert';
import 'package:better_networking/better_networking.dart';
import 'doc_generator.dart';
import 'format_utils.dart';

/// Markdown API Documentation Generator.
/// Generates clean, GitHub-flavored Markdown (GFM) documentation for an API request and response.
class MarkdownDocGenerator implements DocGenerator {
  const MarkdownDocGenerator();

  @override
  String generate({
    required HttpRequestModel request,
    HttpResponseModel? response,
    String? requestName,
  }) {
    final buffer = StringBuffer();

    // 1. Title and Method URL
    final methodStr = request.method.name.toUpperCase();
    final urlStr = request.url.trim();

    final String title;
    if (requestName != null && requestName.trim().isNotEmpty) {
      title = requestName.trim();
    } else if (urlStr.isNotEmpty) {
      title = '$methodStr $urlStr';
    } else {
      title = 'API Request';
    }

    buffer.writeln('# $title');
    if (urlStr.isNotEmpty) {
      buffer.writeln('`$methodStr` `$urlStr`');
    } else {
      buffer.writeln('`$methodStr`');
    }

    // 2. Request Section
    buffer.writeln('\n## Request');

    // 2.1 Headers
    final enabledHeaders = request.enabledHeaders
        ?.where((h) => h.name.trim().isNotEmpty)
        .toList();
    if (enabledHeaders != null && enabledHeaders.isNotEmpty) {
      buffer.writeln('### Headers');
      buffer.writeln('| Header | Value | Description |');
      buffer.writeln('| :--- | :--- | :--- |');
      for (final header in enabledHeaders) {
        final name = escapeMarkdownTable(header.name.trim());
        final val = escapeMarkdownTable(header.value?.toString() ?? '');
        final desc = escapeMarkdownTable(getHeaderDescription(header.name));
        buffer.writeln('| $name | $val | $desc |');
      }
      buffer.writeln();
    }

    // 2.2 Query Parameters
    final enabledParams = request.enabledParams
        ?.where((p) => p.name.trim().isNotEmpty)
        .toList();
    if (enabledParams != null && enabledParams.isNotEmpty) {
      buffer.writeln('### Query Parameters');
      buffer.writeln('| Parameter | Value |');
      buffer.writeln('| :--- | :--- |');
      for (final param in enabledParams) {
        final name = escapeMarkdownTable(param.name.trim());
        final val = escapeMarkdownTable(param.value?.toString() ?? '');
        buffer.writeln('| $name | $val |');
      }
      buffer.writeln();
    }

    // 2.3 Request Body
    if (request.bodyContentType == ContentType.formdata) {
      final validFormData = request.formDataList
          .where((f) => f.name.trim().isNotEmpty)
          .toList();
      if (validFormData.isNotEmpty) {
        buffer.writeln('### Request Body (multipart/form-data)');
        buffer.writeln('| Field | Type | Value |');
        buffer.writeln('| :--- | :--- | :--- |');
        for (final item in validFormData) {
          final name = escapeMarkdownTable(item.name.trim());
          final typeStr = item.type == FormDataType.file ? 'File' : 'Text';
          final val = escapeMarkdownTable(item.value);
          buffer.writeln('| $name | $typeStr | $val |');
        }
        buffer.writeln();
      }
    } else if (request.body != null && request.body!.trim().isNotEmpty) {
      final contentTypeLabel = request.bodyContentType.header;
      var lang = detectMimeLanguage(contentTypeLabel);
      if (lang == 'text') {
        final trimmed = request.body!.trim();
        if ((trimmed.startsWith('{') && trimmed.endsWith('}')) ||
            (trimmed.startsWith('[') && trimmed.endsWith(']'))) {
          lang = 'json';
        }
      }
      final formattedBody =
          formatDocBody(request.body, contentType: contentTypeLabel);
      buffer.writeln('### Request Body ($contentTypeLabel)');
      buffer.writeln('```$lang');
      buffer.writeln(formattedBody);
      buffer.writeln('```\n');
    }

    // 3. Response Section (omitted if response is null)
    if (response != null) {
      buffer.writeln('## Response');
      final statusCode = response.statusCode;
      final statusDesc = getHttpStatusText(statusCode);
      final statusStr =
          statusCode != null ? '`$statusCode $statusDesc`' : '`-`';
      final durationStr = '`${formatDuration(response.time)}`';
      final byteCount = response.bodyBytes?.length ??
          (response.body != null ? utf8.encode(response.body!).length : 0);
      final sizeStr = '`${formatByteSize(byteCount)}`';

      buffer.writeln('- **Status Code**: $statusStr');
      buffer.writeln('- **Time Elapsed**: $durationStr');
      buffer.writeln('- **Content Size**: $sizeStr\n');

      // 3.1 Response Headers
      if (response.headers != null && response.headers!.isNotEmpty) {
        final headersList = response.headers!.entries
            .where((e) => e.key.trim().isNotEmpty)
            .toList();
        if (headersList.isNotEmpty) {
          buffer.writeln('### Response Headers');
          buffer.writeln('| Header | Value |');
          buffer.writeln('| :--- | :--- |');
          for (final entry in headersList) {
            final name = escapeMarkdownTable(entry.key.trim());
            final val = escapeMarkdownTable(entry.value);
            buffer.writeln('| $name | $val |');
          }
          buffer.writeln();
        }
      }

      // 3.2 Response Body
      if (response.body != null && response.body!.trim().isNotEmpty) {
        var lang = detectMimeLanguage(response.contentType);
        if (lang == 'text') {
          final trimmed = response.body!.trim();
          if ((trimmed.startsWith('{') && trimmed.endsWith('}')) ||
              (trimmed.startsWith('[') && trimmed.endsWith(']'))) {
            lang = 'json';
          }
        }
        final formattedRespBody = response.formattedBody ??
            formatDocBody(response.body, contentType: response.contentType);
        buffer.writeln('### Response Body');
        buffer.writeln('```$lang');
        buffer.writeln(formattedRespBody);
        buffer.writeln('```\n');
      }
    }

    return '${buffer.toString().trimRight()}\n';
  }
}
