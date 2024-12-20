// lib/src/parser.dart

import 'package:hurl_parser/hurl_parser.dart';
import 'package:hurl_parser/src/models/query_string_params.dart';
import 'package:petitparser/petitparser.dart';

// Import base grammar
import 'grammar/base_grammar.dart';

// Import models
import 'models/common/body_types_enums.dart';
import 'models/multipart_param.dart';
import 'models/misc_model.dart';

import 'models/basic_auth.dart';
import 'models/forms_params.dart';
import 'models/multipart_form_params.dart';

class HurlParser {
  final Parser _parser;
  final HurlGrammar _grammar;

  HurlParser()
      : _grammar = HurlGrammar(),
        _parser = HurlGrammar().build();

  Result<HurlFile> parseHurlFile(String input) {
    final result = _parser.parse(input);
    if (result is Success) {
      return Result.success(_convertToHurlFile(result.value));
    } else {
      return Result.failure(ParseError(
        message: result.message,
        position: result.position,
        source: input,
      ));
    }
  }

  Result<Entry> parseEntry(String input) {
    final entryParser = _grammar.buildFrom(_grammar.entry()).end();
    final result = entryParser.parse(input);
    if (result is Success) {
      return Result.success(_convertToEntry(result.value));
    } else {
      return Result.failure(ParseError(
        message: result.message,
        position: result.position,
        source: input,
      ));
    }
  }

  Result<Request> parseRequest(String input) {
    // TODO : Remove trace here after fixing all the things
    final requestParser = trace(_grammar.buildFrom(_grammar.request())).end();
    final result = requestParser.parse(input);
    if (result is Success) {
      return Result.success(_convertToRequest(result.value));
    } else {
      return Result.failure(ParseError(
        message: result.message,
        position: result.position,
        source: input,
      ));
    }
  }

  Result<Response> parseResponse(String input) {
    final responseParser = trace(_grammar.buildFrom(_grammar.response()).end());
    final result = responseParser.parse(input);
    if (result is Success) {
      final response = _convertToResponse(result.value);
      return Result.success(response);
    } else {
      return Result.failure(ParseError(
        message: result.message,
        position: result.position,
        source: input,
      ));
    }
  }

  Response _convertToResponse(dynamic value) {
    if (value is! List) return Response(version: '', status: 0);

    final version = value[1]?.toString() ?? '';
    final status = int.tryParse(value[3]?.toString() ?? '0') ?? 0;
    final headers = _convertToHeaders(value[5]);
    final sections = _convertToResponseSections(value[6]);
    final body = value[7] != null ? _convertToBody(value[7]) : null;

    return Response(
      version: version,
      status: status,
      headers: headers,
      sections: sections,
      body: body,
    );
  }

  List<ResponseSection> _convertToResponseSections(dynamic sections) {
    if (sections == null || sections is! List) return [];

    return sections.map((section) {
      if (section is! List || section.length < 2) {
        return ResponseSection(type: '', content: {});
      }

      final type =
          section[1]?.toString().replaceAll('[', '').replaceAll(']', '') ?? '';
      final content = section.length > 3 ? section[3] : null;

      return ResponseSection(
        type: type,
        content: _convertResponseSectionContent(type, content),
      );
    }).toList();
  }

  Body? _convertToBody(dynamic value) {
    if (value == null) return null;

    if (value is List && value.length > 1) {
      final content = value[1];
      String type = 'text';

      if (content is Map && content['type'] != null) {
        type = content['type'];
      } else if (value[0] is List && value[0].isNotEmpty) {
        type = value[0][0]?.toString() ?? 'text';
      }

      return Body(
        type: BodyType.values.firstWhere(
          (e) => e.name.toLowerCase() == type.toLowerCase(),
          orElse: () => BodyType.text,
        ),
        content: content is Map ? content['content'] : content,
      );
    }

    return Body(type: BodyType.text, content: value.toString());
  }
}

HurlFile _convertToHurlFile(dynamic value) {
  final List<dynamic> entries = value[0] as List;
  return HurlFile(
    entries:
        entries.where((e) => e != null).map((e) => _convertToEntry(e)).toList(),
  );
}

Entry _convertToEntry(dynamic value) {
  if (value is! Map) {
    final request = value[0];
    final response = value[1];
    return Entry(
      request: _convertToRequest(request),
      response: response != null ? _convertToResponse(response) : null,
    );
  }
  return Entry(
    request: _convertToRequest(value['request']),
    response: value['response'] != null
        ? _convertToResponse(value['response'])
        : null,
  );
}

Request _convertToRequest(dynamic value) {
  if (value is! Map) return Request(method: '', url: '');

  return Request(
    method: value['method']?.toString() ?? '',
    url: value['url']?.toString() ?? '',
    headers: _convertToHeaders(value['headers']),
    sections: _convertToRequestSections(value['sections']),
    body: value['body'] != null ? _convertToBody(value['body']) : null,
  );
}

List<Header> _convertToHeaders(dynamic headers) {
  if (headers == null || headers is! List) return [];

  return headers.map((header) {
    if (header is! Map) return Header(key: '', value: '');
    return Header(
      key: header['key']?.toString() ?? '',
      value: header['value']?.toString() ?? '',
    );
  }).toList();
}

List<RequestSection> _convertToRequestSections(dynamic sections) {
  if (sections == null || sections is! List) return [];

  return sections.map((section) {
    if (section is! Map) return RequestSection(type: '', content: {});

    final type = section['type']?.toString() ?? '';
    final content = section['content'];

    return RequestSection(
      type: type,
      content: _convertRequestSectionContent(type, content),
    );
  }).toList();
}

dynamic _convertRequestSectionContent(String type, dynamic content) {
  switch (type) {
    case 'BasicAuth':
      return BasicAuth(
        username: content['username']?.toString() ?? '',
        password: content['password']?.toString() ?? '',
      );

    case 'QueryStringParams':
      return QueryStringParams(
        params: _convertToKeyValueList(content),
      );

    case 'FormParams':
      return FormParams(
        params: _convertToKeyValueList(content),
      );

    case 'MultipartFormData':
      return MultipartFormData(
        params: _convertToMultipartParams(content),
      );

    case 'Cookies':
      return Cookies(
        cookies: _convertToKeyValueList(content),
      );

    case 'Options':
      return Options(
        options: _convertToOptionList(content),
      );

    default:
      return content;
  }
}

List<Option> _convertToOptionList(dynamic content) {
  if (content == null || content is! List) return [];

  return content.map((option) {
    if (option is! Map) return Option(type: '', value: '');
    return Option(type: option['key'], value: option['value']);
  }).toList();
}

List<KeyValue> _convertToKeyValueList(dynamic content) {
  if (content == null || content is! List) return [];

  return content.map((param) {
    if (param is! Map) return KeyValue(key: '', value: '');
    return KeyValue(
      key: param['key']?.toString() ?? '',
      value: param['value']?.toString() ?? '',
    );
  }).toList();
}

List<MultipartParam> _convertToMultipartParams(dynamic content) {
  if (content == null || content is! List) return [];

  return content.map<MultipartParam>((param) {
    if (param is! Map) return MultipartParam(name: '', value: '');

    return MultipartParam(
      name: param['key']?.toString() ?? '',
      value: param['value'] ?? '', // Keep value dynamic
      filename: param['filename']?.toString(),
      contentType: param['contentType']?.toString(),
    );
  }).toList();
}

Body? _convertToBody(dynamic value) {
  if (value == null) return null;

  if (value is String) {
    return Body(type: BodyType.text, content: value);
  }

  if (value is Map) {
    final type = value['type']?.toString() ?? '';
    final content = value['content'];

    return Body(
      type: _parseBodyType(type),
      content: content,
    );
  }

  return null;
}

BodyType _parseBodyType(String type) {
  switch (type.toLowerCase()) {
    case 'json':
      return BodyType.json;
    case 'xml':
      return BodyType.xml;
    case 'form':
      return BodyType.form;
    case 'multipart':
      return BodyType.multipart;
    default:
      return BodyType.text;
  }
}

Response _convertToResponse(dynamic value) {
  if (value is! Map) return Response(version: '', status: 0);

  return Response(
    version: value['version']?.toString() ?? '',
    status: int.tryParse(value['status']?.toString() ?? '0') ?? 0,
    headers: _convertToHeaders(value['headers']),
    sections: _convertToResponseSections(value['sections']),
    body: value['body'] != null ? _convertToBody(value['body']) : null,
  );
}

List<ResponseSection> _convertToResponseSections(dynamic sections) {
  if (sections == null || sections is! List) return [];

  return sections.map((section) {
    if (section is! Map) return ResponseSection(type: '', content: {});

    final type = section['type']?.toString() ?? '';
    final content = section['content'];

    return ResponseSection(
      type: type,
      content: _convertResponseSectionContent(type, content),
    );
  }).toList();
}

dynamic _convertResponseSectionContent(String type, dynamic content) {
  switch (type) {
    case 'Captures':
      return Captures(
        captures: _convertToCaptures(content),
      );

    case 'Asserts':
      return Asserts(
        asserts: _convertToAsserts(content),
      );

    default:
      return content;
  }
}

List<Capture> _convertToCaptures(dynamic content) {
  if (content == null || content is! List) return [];

  return content.map<Capture>((capture) {
    if (capture is! Map) {
      // Default query for invalid data
      final defaultQuery = Query(type: 'jsonpath', value: '');
      return Capture(
        name: '',
        query: defaultQuery,
        filters: [],
      );
    }

    final queryData = capture['query'] ?? {'type': 'jsonpath', 'value': ''};
    final query = Query(
      type: queryData['type']?.toString() ?? 'jsonpath',
      value: queryData['value']?.toString() ?? '',
    );

    return Capture(
      name: capture['key']?.toString() ?? '',
      query: query,
      filters: _convertToFilters(capture['filters']),
    );
  }).toList();
}

List<Assert> _convertToAsserts(dynamic content) {
  if (content == null || content is! List) return [];

  return content.map<Assert>((ass) {
    if (ass is! Map) {
      // Default values for invalid data
      final defaultQuery = Query(type: 'jsonpath', value: '');
      final defaultPredicate = Predicate(type: 'equals', value: '');
      return Assert(
        query: defaultQuery,
        predicate: defaultPredicate,
        filters: [],
      );
    }

    final queryData = ass['query'] ?? {'type': 'jsonpath', 'value': ''};
    final query = Query(
      type: queryData['type']?.toString() ?? 'jsonpath',
      value: queryData['value']?.toString() ?? '',
    );

    final predicateData = ass['predicate'] ?? {'type': 'equals', 'value': ''};
    final predicate = Predicate(
      type: predicateData['type']?.toString() ?? 'equals',
      value: predicateData['value']?.toString() ?? '',
    );

    return Assert(
      query: query,
      predicate: predicate,
      filters: _convertToFilters(ass['filters']),
    );
  }).toList();
}

List<Filter> _convertToFilters(dynamic filters) {
  if (filters == null || filters is! List) return [];

  return filters.map<Filter>((filter) {
    if (filter is! Map) return Filter(type: 'none', value: '');
    return Filter(
      type: filter['type']?.toString() ?? 'none',
      value: filter['value']?.toString() ?? '',
    );
  }).toList();
}

/// Result class for handling parse results
class Result<T> {
  final T? value;
  final ParseError? error;
  final bool isSuccess;

  const Result.success(this.value)
      : error = null,
        isSuccess = true;

  const Result.failure(this.error)
      : value = null,
        isSuccess = false;
}
