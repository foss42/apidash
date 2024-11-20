import 'package:apidash_core/apidash_core.dart';
import 'package:curl_converter/curl_converter.dart';

class CurlFileImport {
  HttpRequestModel? getHttpRequestModel(String content) {
    content = content.trim();
    try {
      final curl = Curl.parse(content);
      final url = stripUriParams(curl.uri);
      final method = HTTPVerb.values.byName(curl.method.toLowerCase());

      final headers = curl.headers?.entries
          .map((entry) => NameValueModel(
                name: entry.key,
                value: entry.value,
              ))
          .toList();

      final params = curl.uri.queryParameters.entries
          .map((entry) => NameValueModel(
                name: entry.key,
                value: entry.value,
              ))
          .toList();

      ContentType bodyContentType = ContentType.json;
      bool isFormData = false;
      List<FormDataModel>? formDataList;

      // Check if the content type is specified in the headers
      if (headers != null) {
        final contentTypeHeader = curl.headers?.entries
            .firstWhere(
              (entry) => entry.key.toLowerCase() == 'content-type',
              orElse: () => const MapEntry('', ''),
            )
            .value;
        if (contentTypeHeader!.isNotEmpty) {
          switch (contentTypeHeader) {
            case 'application/json':
              bodyContentType = ContentType.json;
              break;
            case 'multipart/form-data':
              bodyContentType = ContentType.formdata;
              isFormData = true;
              break;
            case 'text/plain':
              bodyContentType = ContentType.text;
              break;
            default:
              bodyContentType = ContentType.json;
              break;
          }
        }
      }

      // Parse form data if present
      if (curl.data != null) {
        // This is url-encoded form data if it contains '=' and '&'
        if (curl.data!.contains('=') && curl.data!.contains('&')) {
          final pairs = curl.data!.split('&');
          if (pairs.every((pair) => pair.contains('='))) {
            bodyContentType = ContentType.formdata;
            isFormData = true;
            formDataList = _parseUrlEncodedFormData(curl.data!);
          }
        }

        // Try parsing as JSON if not form data
        if (!isFormData) {
          try {
            final _ = kJsonDecoder.convert(curl.data!);
            bodyContentType = ContentType.json;
          } catch (e) {
            bodyContentType = ContentType.text;
          }
        }
      } else if (curl.form) {
        // Check for multipart form data (-F flag) as when the curl.form flag is set
        // to true, it means that the request is a form data request of formdata/multipart type

        bodyContentType = ContentType.formdata;
        formDataList = _parseMultipartFormData(content);
      }

      return HttpRequestModel(
        method: method,
        url: url,
        headers: headers,
        params: params,
        formData: formDataList,
        body: curl.data,
        bodyContentType: bodyContentType,
      );
    } catch (e) {
      return null;
    }
  }

  // Manually parsing the form data
  List<FormDataModel> _parseMultipartFormData(String data) {
    final List<FormDataModel> formData = [];

    // Regex for parsing -F fields we are creating a group for the field name and value
    final RegExp regex = RegExp(r'-F\s*"([^=]+)=([^"]+)"');

    final Map<String, String> parsedData = {};

    for (final Match match in regex.allMatches(data)) {
      final String key = match.group(1)!;
      String value = match.group(2)!;
      parsedData[key] = value;
    }

    parsedData.forEach((key, value) {
      // Check if the value is a file
      if (value.startsWith('@')) {
        formData.add(FormDataModel(
          name: key,
          value: value.substring(1),
          type: FormDataType.file,
        ));
      } else {
        formData.add(FormDataModel(
          name: key,
          value: value,
          type: FormDataType.text,
        ));
      }
    });

    return formData;
  }

  List<FormDataModel> _parseUrlEncodedFormData(String data) {
    return data.split('&').map((pair) {
      final parts = pair.split('=');
      return FormDataModel(
        name: parts[0],
        value: Uri.decodeComponent(parts[1]),
        type: FormDataType.text,
      );
    }).toList();
  }
}
