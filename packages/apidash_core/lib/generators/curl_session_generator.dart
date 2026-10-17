import 'package:better_networking/better_networking.dart';
import 'doc_generator.dart';
import 'format_utils.dart';

/// Formatted cURL Reproduction Session Generator.
/// Generates multi-line bash-executable `curl` commands with `-X`, `-H`, and `--data` flags,
/// appending a commented response summary for reproduction in GitHub issues or Jira tickets.
class CurlSessionGenerator implements DocGenerator {
  const CurlSessionGenerator();

  @override
  String generate({
    required HttpRequestModel request,
    HttpResponseModel? response,
    String? requestName,
  }) {
    final buffer = StringBuffer();

    // 1. Optional request name header comment
    if (requestName != null && requestName.trim().isNotEmpty) {
      buffer.writeln('# ${requestName.trim()}');
    }

    // 2. Resolve target URL including active/enabled query parameters
    final (uri, _) = getValidRequestUri(
      request.url,
      request.enabledParams,
    );
    String targetUrl;
    if (uri != null) {
      targetUrl = uri.toString();
      if (targetUrl.endsWith('?')) {
        targetUrl = targetUrl.substring(0, targetUrl.length - 1);
      }
    } else {
      targetUrl = request.url.trim();
    }

    final methodStr = request.method.name.toUpperCase();
    final parts = <String>[];

    // Main curl command line with -X and URL
    parts.add("curl -X $methodStr '$targetUrl'");

    // 3. Headers (-H)
    final isFormData = request.bodyContentType == ContentType.formdata;
    final enabledHeaders = request.enabledHeaders
        ?.where((h) => h.name.trim().isNotEmpty)
        .toList();

    if (enabledHeaders != null && enabledHeaders.isNotEmpty) {
      for (final header in enabledHeaders) {
        // When sending form-data, curl automatically manages Content-Type with multipart boundaries
        if (isFormData &&
            header.name.trim().toLowerCase() ==
                kHeaderContentType.toLowerCase()) {
          continue;
        }
        final name = escapeBashSingleQuotes(header.name.trim());
        final val = escapeBashSingleQuotes(header.value?.toString() ?? '');
        parts.add("-H '$name: $val'");
      }
    }

    // 4. Request Body (--data or -F)
    if (isFormData) {
      for (final item in request.formDataList) {
        if (item.name.trim().isNotEmpty) {
          final prefix = item.type == FormDataType.file ? '@' : '';
          final name = escapeBashSingleQuotes(item.name.trim());
          final val = escapeBashSingleQuotes(item.value);
          parts.add("-F '$name=$prefix$val'");
        }
      }
    } else if (request.body != null && request.body!.trim().isNotEmpty) {
      final cleanBody = request.body!.replaceAll('\r\n', '\n');
      parts.add("--data '${escapeBashSingleQuotes(cleanBody)}'");
    }

    // Join parts with multi-line bash continuation
    final commandStr = parts.first +
        (parts.length > 1 ? ' \\\n  ${parts.skip(1).join(' \\\n  ')}' : '');
    buffer.writeln(commandStr);

    // 5. Appended Response Summary Comment
    if (response != null) {
      buffer.writeln();
      final statusCode = response.statusCode;
      final statusDesc = getHttpStatusText(statusCode);
      final timeStr = formatDuration(response.time);
      final statusPart =
          statusCode != null ? '$statusCode $statusDesc' : '-';
      buffer.writeln('# Response: $statusPart ($timeStr)');
    }

    return buffer.toString();
  }
}
