// lib/hurl_parser.dart

/// A library for parsing Hurl files
library hurl_parser;

// Re-export all necessary classes and types
export 'src/parser.dart' show HurlParser, Result;
export 'src/models/hurl_file.dart';
export 'src/models/entry.dart';
export 'src/models/request.dart';
export 'src/models/response.dart';
export 'src/models/sections/request_section.dart';
export 'src/models/sections/response_section.dart';
export 'src/models/common/header.dart';
export 'src/models/common/body.dart';
export 'src/models/common/query.dart';
export 'src/models/common/predicate.dart';
export 'src/models/common/filter.dart';
export 'src/models/common/errors.dart';
