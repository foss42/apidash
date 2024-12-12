import 'package:petitparser/petitparser.dart';

class HurlGrammar extends GrammarDefinition {
  @override
  Parser start() => ref0(hurlFile);

  // Core Structure
  Parser hurlFile() => ref0(entry).star() & ref0(lineTerminator).star();
  Parser entry() => ref0(request) & ref0(response).optional();

  // Request/Response Structure
  // Request Structure
  Parser request() => SequenceParser([
        ref0(lineTerminator).star(),
        ref0(method),
        ref0(space),
        ref0(valueString),
        ref0(lineTerminator),
        ref0(header).star(),
        ref0(requestSection).star(),
        ref0(body).optional(),
      ]).map((values) => {
            'method': values[1],
            'url': values[3],
            'headers': values[5] ?? [],
            'sections': values[6] ?? [],
            'body': values[7],
          });

  Parser response() =>
      ref0(lineTerminator).star() &
      ref0(version) &
      ref0(space) &
      ref0(status) &
      ref0(lineTerminator) &
      ref0(header).star() &
      ref0(responseSection).star() &
      ref0(body).optional();

  // Sections
  Parser requestSection() =>
      ref0(basicAuthSection) |
      ref0(queryStringParamsSection) |
      ref0(formParamsSection) |
      ref0(multipartFormDataSection) |
      ref0(cookiesSection) |
      ref0(optionsSection);

  Parser responseSection() => ref0(capturesSection) | ref0(assertsSection);

  // Section Implementations
  // Parser basicAuthSection() =>
  //     ref0(lineTerminator).star() &
  //     string('[BasicAuth]') &
  //     ref0(lineTerminator) &
  //     ref0(keyValue).star();

  Parser basicAuthSection() => SequenceParser([
        ref0(lineTerminator).star(),
        string('[BasicAuth]'),
        ref0(lineTerminator).optional(),
        ref0(keyValue).star(),
      ]);

  // Parser queryStringParamsSection() =>
  //     ref0(lineTerminator).star() &
  //     (string('[QueryStringParams]') | string('[Query]')) &
  //     ref0(lineTerminator) &
  //     ref0(keyValue).star();
  //
  Parser queryStringParamsSection() => SequenceParser<dynamic>([
        ref0(lineTerminator).star(),
        (string('[QueryStringParams]') | string('[Query]')),
        ref0(lineTerminator),
        ref0(keyValue).star(),
      ]);

  Parser formParamsSection() => SequenceParser<dynamic>([
        ref0(lineTerminator).star(),
        (string('[FormParams]') | string('[Form]')),
        ref0(lineTerminator),
        ref0(keyValue).star(),
      ]);

  Parser multipartFormDataSection() => SequenceParser<dynamic>([
        ref0(lineTerminator).star(),
        (string('[MultipartFormData]') | string('[Multipart]')),
        ref0(lineTerminator),
        ref0(multipartFormDataParam).star(),
      ]);
  Parser cookiesSection() => SequenceParser([
        ref0(lineTerminator).star(),
        string('[Cookies]'),
        ref0(lineTerminator),
        ref0(keyValue).star(),
      ]);

  Parser optionsSection() => SequenceParser([
        ref0(lineTerminator).star(),
        string('[Options]'),
        ref0(lineTerminator),
        ref0(option).star(),
      ]);

  Parser capturesSection() =>
      ref0(lineTerminator).star() & string('[Captures]') & ref0(lineTerminator);
  // ref0(capture).star();

  Parser assertsSection() =>
      ref0(lineTerminator).star() &
      string('[Asserts]') &
      ref0(lineTerminator) &
      ref0(assert_).star();

  // Function and Filter
  Parser function() =>
      ref0(envFunction) | ref0(nowFunction) | ref0(uuidFunction);

  Parser envFunction() => string('getEnv');
  Parser nowFunction() => string('newDate');
  Parser uuidFunction() => string('newUuid');

  Parser filter() =>
      ref0(countFilter) |
      ref0(daysAfterNowFilter) |
      ref0(daysBeforeNowFilter) |
      ref0(decodeFilter) |
      ref0(formatFilter) |
      ref0(htmlEscapeFilter) |
      ref0(htmlUnescapeFilter) |
      ref0(jsonpathFilter) |
      ref0(nthFilter) |
      ref0(regexFilter) |
      ref0(replaceFilter) |
      ref0(splitFilter) |
      ref0(toDateFilter) |
      ref0(toFloatFilter) |
      ref0(toIntFilter) |
      ref0(urlDecodeFilter) |
      ref0(urlEncodeFilter) |
      ref0(xpathFilter);

  // Filter Implementations
  Parser countFilter() => string('count');
  Parser daysAfterNowFilter() => string('daysAfterNow');
  Parser daysBeforeNowFilter() => string('daysBeforeNow');
  Parser decodeFilter() => string('decode');
  Parser formatFilter() => string('format');
  Parser htmlEscapeFilter() => string('htmlEscape');
  Parser htmlUnescapeFilter() => string('htmlUnescape');

  Parser jsonpathFilter() =>
      string('jsonpath') & ref0(space) & ref0(quotedString);

  Parser nthFilter() => string('nth') & ref0(space) & ref0(integer);

  Parser regexFilter() =>
      string('regex') & ref0(space) & (ref0(quotedString) | ref0(regex));

  Parser replaceFilter() =>
      string('replace') &
      ref0(space) &
      (ref0(quotedString) | ref0(regex)) &
      ref0(space) &
      ref0(quotedString);

  Parser splitFilter() => string('split') & ref0(space) & ref0(quotedString);

  Parser toDateFilter() => string('toDate');
  Parser toFloatFilter() => string('toFloat');
  Parser toIntFilter() => string('toInt');
  Parser urlDecodeFilter() => string('urlDecode');
  Parser urlEncodeFilter() => string('urlEncode');

  Parser xpathFilter() => string('xpath') & ref0(space) & ref0(quotedString);

  // Content Types
  Parser bytes() =>
      ref0(jsonValue) |
      ref0(multilineString) |
      ref0(onelineString) |
      ref0(onelineBase64) |
      ref0(onelineFile) |
      ref0(onelineHex);

  Parser multilineString() =>
      string('```') &
      ref0(multilineStringType).optional() &
      (char(',') & ref0(multilineStringAttribute)).star() &
      ref0(lineTerminator) &
      (ref0(multilineStringContent) | ref0(template)).star() &
      ref0(lineTerminator) &
      string('```');

  Parser multilineStringType() =>
      string('base64') |
      string('hex') |
      string('json') |
      string('xml') |
      string('graphql');

  Parser multilineStringAttribute() => string('escape') | string('novariable');

  Parser onelineString() =>
      char('`') &
      (ref0(onelineStringContent) | ref0(template)).star() &
      char('`');

  Parser onelineBase64() =>
      string('base64,') & pattern('A-Z0-9+-= \n').plus() & char(';');

  Parser onelineFile() => string('file,') & ref0(filename) & char(';');

  Parser onelineHex() => string('hex,') & ref0(hexDigit).star() & char(';');

  // JSON Support
  Parser jsonValue() =>
      ref0(template) |
      ref0(jsonObject) |
      ref0(jsonArray) |
      ref0(jsonString) |
      ref0(jsonNumber) |
      ref0(boolean) |
      ref0(null_);

  Parser jsonObject() =>
      char('{') & ref0(jsonKeyValue).plusSeparated(char(',')) & char('}');

  Parser jsonKeyValue() => ref0(jsonString) & char(':') & ref0(jsonValue);

  Parser jsonArray() =>
      char('[') & ref0(jsonValue).plusSeparated(char(',')) & char(']');

  Parser jsonString() =>
      char('"') & (ref0(jsonStringContent) | ref0(template)).star() & char('"');

  Parser jsonNumber() =>
      ref0(integer) & ref0(fraction).optional() & ref0(exponent).optional();

  // Basic Elements
  Parser method() => pattern('A-Z').plus().flatten();
  Parser version() =>
      string('HTTP/1.0') |
      string('HTTP/1.1') |
      string('HTTP/2') |
      string('HTTP');
  Parser status() => digit().plus();

  Parser header() => (ref0(keyString).trim() &
          char(':').trim() &
          ref0(valueString).trim() &
          (char('\n') | ref0(comment)).optional())
      .map((values) => {'key': values[0], 'value': values[2]});

  // Parser header() => ref0(keyValue).trim(ref0(lineTerminator));

  // Parser keyValue() =>
  //     (ref0(keyString).trim() & char(':') & ref0(valueString).trim())
  //         .map((values) => {'key': values[0], 'value': values[2]});
  Parser keyValue() => SequenceParser([
        ref0(keyString).trim(),
        char(':'),
        ref0(valueString).trim(),
        ref0(lineTerminator).optional(),
      ]).map((values) => {
            'key': values[0],
            'value': values[2],
          });
  // Parser keyValue() => ref0(keyString) & char(':') & ref0(valueString);

  Parser keyString() => (ref0(keyStringContent) | ref0(template))
      .plus()
      .flatten()
      .where((value) => value.trim().isNotEmpty);

  Parser valueString() =>
      (ref0(valueStringContent) | ref0(template)).plus().flatten();
  // .map((value) => value.split('#')[0].trim());

  // Helper Parsers
  Parser digit() => pattern('0-9');
  Parser letter() => pattern('A-Za-z');
  Parser hexDigit() => pattern('0-9A-Fa-f');
  Parser alphanumeric() => pattern('A-Za-z0-9');
  Parser space() => pattern(' \t');

  Parser lineTerminator() => pattern(' \t').star() & char('\n').flatten();

  Parser comment() => SequenceParser([
        pattern(' \t').star(), // Optional whitespace before comment
        char('#'),
        pattern('^\\n').star(), // Comment content
      ]);

  Parser boolean() => string('true') | string('false');
  Parser null_() => string('null');

  Parser integer() => ref0(digit).plus();
  Parser fraction() => char('.') & ref0(digit).plus();
  Parser exponent() =>
      pattern('eE') & pattern('+-').optional() & ref0(digit).plus();

  // Template Support
  Parser template() => string('{{') & ref0(expr) & string('}}');

  Parser expr() => ref0(variableName) & (ref0(space) & ref0(filter)).star();

  Parser variableName() =>
      letter() & (letter() | digit() | char('_') | char('-')).star();

  // Body parser with all content types
  Parser body() =>
      ref0(lineTerminator).star() & ref0(bytes) & ref0(lineTerminator);

  Parser jsonStringContent() =>
      ref0(jsonStringText) | ref0(jsonStringEscapedChar);

  Parser jsonStringText() => pattern('^"\\');

  Parser jsonStringEscapedChar() =>
      char('\\') & pattern('"\\bfnrt') | (char('u') & ref0(hexDigit).times(4));

  // Multiline string content
  Parser multilineStringContent() =>
      (ref0(multilineStringText) | ref0(multilineStringEscapedChar)).star();

  Parser multilineStringText() => pattern('^\\').plus() & string('```').not();

  Parser multilineStringEscapedChar() =>
      char('\\') & (pattern('bfnrt`') | (char('u') & ref0(unicodeChar)));

  Parser onelineStringContent() =>
      (ref0(onelineStringText) | ref0(onelineStringEscapedChar)).star();

  Parser onelineStringText() => pattern('^#\\n\\\\`');

  Parser onelineStringEscapedChar() =>
      char('\\') & (pattern('`#bfu') | ref0(unicodeChar));

  // Parser filename() => (ref0(filenameContent) | ref0(template)).plus();

  Parser filename() =>
      (ref0(filenameContent) | ref0(template)).plus().flatten();

  Parser filenameContent() =>
      (ref0(filenameText) | ref0(filenameEscapedChar)).plus();

  // Parser filenameText() => pattern('^\\\\#;{} \n').plus();
  Parser filenameText() => pattern('#;{} \n\\').neg().plus();

  Parser filenameEscapedChar() =>
      char('\\') & (pattern('bfnrt#; {}') | (char('u') & ref0(unicodeChar)));

  Parser unicodeChar() => char('{') & ref0(hexDigit).plus() & char('}');

  Parser multipartFormDataParam() => ref0(fileParam) | ref0(keyValue);

  // File parameter parsing
  Parser fileParam() =>
      ref0(lineTerminator).star() &
      ref0(keyString) &
      char(':') &
      ref0(fileValue) &
      ref0(lineTerminator);

  Parser fileValue() =>
      string('file,') &
      ref0(filename) &
      char(';') &
      ref0(fileContenttype).optional();

  Parser fileContenttype() => pattern('a-zA-Z0-9/+-').plus();

  Parser keyStringContent() =>
      (ref0(keyStringText) | ref0(keyStringEscapedChar)).plus().flatten();

  Parser keyStringText() => pattern('A-Za-z0-9._-').plus();

  Parser keyStringEscapedChar() {
    // Unicode sequence requires exactly 4 hex digits
    final unicodeChar = char('u') & pattern('0-9A-Fa-f').times(4);
    return char('\\') &
        (char('#') | // \#
            char('\\') | // \\
            char('|') | // \|
            char('b') | // \b
            char('f') | // \f
            char('n') | // \n
            char('r') | // \r
            char('t') | // \t
            unicodeChar // \uXXXX
        );
  }

  Parser valueStringContent() =>
      (ref0(valueStringText) | ref0(valueStringEscapedChar)).plus().flatten();

  Parser valueStringText() =>
      any().where((char) => char != '\\' && char != '#' && char != '\n');
  // Parser valueStringText()=> pattern('\\\\#\\n').neg().plus();

  Parser valueStringEscapedChar() {
    // Unicode sequence requires exactly 4 hex digits
    final unicodeChar = char('u') & pattern('0-9A-Fa-f').times(4);
    return char('\\') &
        (char('#') | // \#
            char('\\') | // \\
            char('|') | // \|
            char('b') | // \b
            char('f') | // \f
            char('n') | // \n
            char('r') | // \r
            char('t') | // \t
            unicodeChar // \uXXXX
        );
  }

  Parser quotedString() =>
      char('"') &
      (ref0(quotedStringContent) | ref0(template)).star() &
      char('"');

  Parser quotedStringContent() =>
      (ref0(quotedStringText) | ref0(quotedStringEscapedChar)).star();

  Parser quotedStringText() => pattern('^"\\').plus();

  Parser quotedStringEscapedChar() =>
      char('\\') & (pattern('"\\bfnrt') | (char('u') & ref0(unicodeChar)));

  // Basic regex pattern
  Parser regex() => char('/') & ref0(regexContent) & char('/');

  // Regex content with all possible patterns
  Parser regexContent() => (ref0(regexText) | ref0(regexEscapedChar)).star();

  // Regular text in regex pattern
  Parser regexText() => pattern('^\\n/').plus();

  // Escaped characters in regex
  Parser regexEscapedChar() => char('\\') & pattern('^\\n');

  // Regex as part of a query
  Parser regexQuery() =>
      string('regex') & ref0(space) & (ref0(quotedString) | ref0(regex));
  // Options Parser
  // Parser option() =>
  //     ref0(lineTerminator).star() &
  //     (ref0(awsSigv4Option) |
  //         ref0(caCertificateOption) |
  //         ref0(compressedOption)) &
  //     ref0(lineTerminator);

  Parser option() => SequenceParser<dynamic>([
        ref0(lineTerminator).star(), // Flatten these terminators too
        ref0(space).optional(),
        (ref0(awsSigv4Option) |
            ref0(caCertificateOption) |
            ref0(compressedOption)),
        ref0(lineTerminator),
      ]).map((values) => values[2]);

  Parser awsSigv4Option() => SequenceParser([
        string('aws-sigv4'),
        char(':'),
        ref0(space).optional(),
        ref0(valueString),
      ]).map((values) =>
          {'type': 'aws-sigv4', 'value': values[3].toString().trim()});

  Parser caCertificateOption() => SequenceParser([
        string('cacert'),
        char(':'),
        ref0(space).optional(),
        ref0(filename),
      ]).map(
          (values) => {'type': 'cacert', 'value': values[3].toString().trim()});

  Parser compressedOption() => SequenceParser([
        string('compressed'),
        char(':'),
        ref0(space).optional(),
        ref0(booleanOption),
      ]).map((values) => {
            'type': 'compressed',
            'value': values[3].toString().trim() == 'true'
          });

  // // Individual Option Parsers
  // Parser awsSigv4Option() =>
  //     string('aws-sigv4') &
  //     char(':') &
  //     ref0(valueString) &
  //     ref0(lineTerminator);

  // Parser caCertificateOption() =>
  //     string('cacert') & char(':') & ref0(filename) & ref0(lineTerminator);

  // Parser compressedOption() =>
  //     string('compressed') &
  //     char(':') &
  //     ref0(booleanOption) &
  //     ref0(lineTerminator);
  // ... Add other option parsers as needed

  Parser booleanOption() => ref0(boolean) | ref0(template);
  Parser integerOption() => ref0(integer) | ref0(template);
  Parser durationOption() =>
      (ref0(integer) & ref0(durationUnit).optional()) | ref0(template);

  Parser durationUnit() => string('ms') | string('s') | string('m');

  // Captures Parser
  Parser capture() =>
      ref0(lineTerminator).star() &
      ref0(keyString) &
      char(':') &
      ref0(query) &
      (ref0(space) & ref0(filter)).star() &
      ref0(lineTerminator);

  // Assert Parser
  Parser assert_() =>
      ref0(lineTerminator).star() &
      ref0(query) &
      (ref0(space) & ref0(filter)).star() &
      ref0(space) &
      ref0(predicate) &
      ref0(lineTerminator);

  // Query Parser
  Parser query() =>
      ref0(statusQuery) |
      ref0(urlQuery) |
      ref0(headerQuery) |
      ref0(certificateQuery) |
      ref0(regexQuery);

  Parser statusQuery() => string('status');
  Parser urlQuery() => string('url');
  Parser headerQuery() => string('header') & ref0(space) & ref0(quotedString);
  Parser certificateQuery() =>
      string('certificate') &
      ref0(space) &
      (string('Subject') |
          string('Issuer') |
          string('Start-Date') |
          string('Expire-Date') |
          string('Serial-Number'));
  // ... Add other query parsers as needed

  // Predicate Parser
  Parser predicate() =>
      (string('not') & ref0(space)).optional() & ref0(predicateFunc);

  Parser predicateFunc() =>
      ref0(equalPredicate) |
      ref0(notEqualPredicate) |
      ref0(greaterPredicate) |
      ref0(greaterOrEqualPredicate) |
      ref0(lessPredicate) |
      ref0(lessOrEqualPredicate) |
      ref0(startWithPredicate) |
      ref0(endWithPredicate) |
      ref0(containPredicate) |
      ref0(matchPredicate) |
      ref0(existPredicate) |
      ref0(isEmptyPredicate) |
      ref0(includePredicate) |
      ref0(integerPredicate) |
      ref0(floatPredicate) |
      ref0(booleanPredicate) |
      ref0(stringPredicate) |
      ref0(collectionPredicate) |
      ref0(datePredicate) |
      ref0(isoDatePredicate);

  Parser equalPredicate() => string('==') & ref0(space) & ref0(predicateValue);
  Parser notEqualPredicate() =>
      string('!=') & ref0(space) & ref0(predicateValue);
  // Comparison Predicates
  Parser greaterPredicate() =>
      char('>') & ref0(space) & (ref0(number) | ref0(quotedString));

  Parser greaterOrEqualPredicate() =>
      string('>=') & ref0(space) & (ref0(number) | ref0(quotedString));

  Parser lessPredicate() =>
      char('<') & ref0(space) & (ref0(number) | ref0(quotedString));

  Parser lessOrEqualPredicate() =>
      string('<=') & ref0(space) & (ref0(number) | ref0(quotedString));

  // String Predicates
  Parser startWithPredicate() =>
      string('startsWith') &
      ref0(space) &
      (ref0(quotedString) | ref0(onelineHex) | ref0(onelineBase64));

  Parser endWithPredicate() =>
      string('endsWith') &
      ref0(space) &
      (ref0(quotedString) | ref0(onelineHex) | ref0(onelineBase64));

  Parser containPredicate() =>
      string('contains') & ref0(space) & ref0(quotedString);

  Parser matchPredicate() =>
      string('matches') & ref0(space) & (ref0(quotedString) | ref0(regex));

  // Existence Predicates
  Parser existPredicate() => string('exists');

  Parser isEmptyPredicate() => string('isEmpty');

  Parser includePredicate() =>
      string('includes') & ref0(space) & ref0(predicateValue);

  // Type Check Predicates
  Parser integerPredicate() => string('isInteger');

  Parser floatPredicate() => string('isFloat');

  Parser booleanPredicate() => string('isBoolean');

  Parser stringPredicate() => string('isString');

  Parser collectionPredicate() => string('isCollection');

  Parser datePredicate() => string('isDate');

  Parser isoDatePredicate() => string('isIsoDate');

  // Helper Parsers
  Parser predicateValue() =>
      ref0(boolean) |
      ref0(multilineString) |
      ref0(null_) |
      ref0(number) |
      ref0(onelineString) |
      ref0(onelineBase64) |
      ref0(onelineFile) |
      ref0(onelineHex) |
      ref0(quotedString) |
      ref0(template);

  Parser number() => ref0(integer) | ref0(float);
  Parser float() => ref0(integer) & ref0(fraction);
}
