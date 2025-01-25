import 'dart:async';
import 'dart:convert';
import 'package:apidash_core/utils/utils.dart';
import 'package:hurl/hurl.dart';
import 'package:seed/seed.dart';
import '../consts.dart';
import '../models/http_request_model.dart';

class HurlIo {
  static bool _initialized = false;
  static final _initCompleter = Completer<void>();

  HurlIo() {
    print('HurlIo constructor called'); // Debug log
    _initializeIfNeeded();
  }

  void _initializeIfNeeded() {
    if (!_initialized) {
      print('Starting initialization'); // Debug log
      _initialized = true;
      HurlParser.initialize().then((_) {
        print('Initialization completed successfully'); // Debug log
        _initCompleter.complete();
      }).catchError((error) {
        print('Initialization failed with error: $error'); // Debug log
        _initialized = false;
        _initCompleter.completeError(error);
      });
    } else {
      print('Already initialized'); // Debug log
    }
  }

  Future<HurlFile> getHurlFile(String content) async {
    print(
        'getHurlFile called with content: "$content"'); // Print actual content
    try {
      await _initCompleter.future;
      print('Initialization confirmed, proceeding to parse');

      // Get the JSON string first
      final jsonString = HurlParser.parseToJson(content);
      print('Parsed JSON: $jsonString'); // Print the intermediate JSON

      // Try to decode the JSON string to see if it's valid JSON
      final jsonMap = jsonDecode(jsonString);
      print('Decoded JSON structure: $jsonMap'); // Print decoded structure

      final result = HurlFile.fromJson(jsonMap);
      print('Successfully created HurlFile object');
      return result;
    } catch (e, stackTrace) {
      print('Error in getHurlFile: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<String> getJson(String content) async {
    print('getJson called'); // Debug log
    await _initCompleter.future;
    return HurlParser.parseToJson(content);
  }

  Future<List<(String?, HttpRequestModel)>?> getHttpRequestModelList(
      String content) async {
    print('getHttpRequestModelList called'); // Debug log
    try {
      final hurlFile = await getHurlFile(content);
      print(
          'HurlFile obtained, entries count: ${hurlFile.entries.length}'); // Debug log

      return hurlFile.entries.map((entry) {
        print(
            'Processing entry: ${entry.request.method} ${entry.request.url}'); // Debug log
        final HurlRequest request = entry.request;

        // Convert HTTP method
        HTTPVerb method;
        try {
          method = HTTPVerb.values.byName(request.method.toLowerCase());
        } catch (e) {
          print('Error converting HTTP method: $e'); // Debug log
          method = kDefaultHttpMethod;
        }

        // Process URL
        final url = stripUrlParams(request.url);

        // Process headers
        final headers = <NameValueModel>[];
        for (Header header in request.headers ?? []) {
          headers.add(NameValueModel(
            name: header.name,
            value: header.value,
          ));
        }
        print('Processed ${headers.length} headers'); // Debug log

        // Process body and form data
        ContentType bodyContentType = kDefaultContentType;
        String? body;
        List<FormDataModel>? formData;

        // Check for multipart form data
        if (request.multiPartFormData != null &&
            request.multiPartFormData!.isNotEmpty) {
          print('Processing multipart form data'); // Debug log
          bodyContentType = ContentType.formdata;
          formData = request.multiPartFormData!.map((item) {
            return FormDataModel(
              name: item.name,
              value: item.filename ?? item.value ?? '',
              type:
                  item.filename != null ? FormDataType.file : FormDataType.text,
            );
          }).toList();
        }
        // Handle regular body
        else if (request.body != null) {
          print('Processing regular body'); // Debug log
          final contentTypeHeader = request.headers?.firstWhere(
            (element) => element.name.toLowerCase().contains("content-type"),
            orElse: () => Header(name: '', value: ''),
          );

          body = request.body?.value?.toString();
          print(
              'Body content type header: ${contentTypeHeader?.value}'); // Debug log

          if (contentTypeHeader?.value.contains('application/json') == true) {
            bodyContentType = ContentType.json;
          } else if (contentTypeHeader?.value.contains('text/plain') == true) {
            bodyContentType = ContentType.text;
          }
        }

        // Create the HttpRequestModel
        return (
          null,
          HttpRequestModel(
            method: method,
            url: url,
            headers: headers,
            params: [],
            isParamEnabledList: [],
            body: body,
            bodyContentType: bodyContentType,
            formData: formData,
          )
        );
      }).toList();
    } catch (e, stackTrace) {
      print('Error in getHttpRequestModelList: $e'); // Debug log
      print('Stack trace: $stackTrace'); // Debug log
      return null;
    }
  }
}
