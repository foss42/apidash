import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:davi/davi.dart';

const kDiscordUrl = "https://bit.ly/heyfoss";
const kGitUrl = "https://github.com/foss42/api-dash";
const kIssueUrl = "$kGitUrl/issues";

final kColorTransparent = MaterialStateProperty.all<Color>(Colors.transparent);
const kColorBg = Colors.white;

final kCodeStyle = GoogleFonts.sourceCodePro();
const kHintOpacity = 0.6;

const kTextStyleButton = TextStyle(fontWeight: FontWeight.bold);

const kBorderRadius8 = BorderRadius.all(Radius.circular(8));
final kBorderRadius10 = BorderRadius.circular(10);
const kBorderRadius12 = BorderRadius.all(Radius.circular(12));

const kTableContainerDecoration = BoxDecoration(
  color: kColorBg,
  borderRadius: kBorderRadius12,
);

const kP1 = EdgeInsets.all(1);
const kP5 = EdgeInsets.all(5);
const kP8 = EdgeInsets.all(8);
const kPs8 = EdgeInsets.only(left: 8);
const kPh20v5 = EdgeInsets.symmetric(horizontal: 20, vertical: 5);
const kPh20v10 = EdgeInsets.symmetric(horizontal: 20, vertical: 10);
const kP10 = EdgeInsets.all(10);

const kHSpacer5 = SizedBox(width: 5);
const kHSpacer10 = SizedBox(width: 10);
const kHSpacer20 = SizedBox(width: 20);
const kVSpacer5 = SizedBox(height: 5);
const kVSpacer8 = SizedBox(height: 8);
const kVSpacer10 = SizedBox(height: 10);
const kVSpacer20 = SizedBox(height: 20);

const kTabAnimationDuration = Duration(milliseconds: 200);
const kTabHeight = 45.0;
const kHeaderHeight = 32.0;
const kSegmentHeight = 24.0;

const kRandMax = 100000;

const kTableThemeData = DaviThemeData(
  columnDividerThickness: 1,
  columnDividerColor: Colors.transparent,
  row: RowThemeData(
    dividerColor: Colors.transparent,
  ),
  decoration: BoxDecoration(
    border: Border(),
  ),
  header: HeaderThemeData(
    visible: false,
  ),
);

const kCodePreviewLinesLimit = 500;
const kCodeCharsPerLineLimit = 200;

const kLightCodeTheme = {
  'root':
      TextStyle(backgroundColor: Color(0xffffffff), color: Color(0xff000000)),
  'comment': TextStyle(color: Color(0xff007400), fontStyle: FontStyle.italic),
  'quote': TextStyle(color: Color(0xff007400)),
  'tag': TextStyle(color: Color(0xffaa0d91)),
  'attribute': TextStyle(color: Color(0xffaa0d91)),
  'keyword': TextStyle(color: Color(0xffaa0d91)),
  'selector-tag': TextStyle(color: Color(0xffaa0d91)),
  'literal': TextStyle(color: Color(0xffaa0d91)),
  'name': TextStyle(color: Color(0xffaa0d91)),
  'variable': TextStyle(color: Color(0xff3F6E74)),
  'template-variable': TextStyle(color: Color(0xff3F6E74)),
  'code': TextStyle(color: Color(0xffc41a16)),
  'string': TextStyle(color: Color(0xffc41a16)),
  'meta-string': TextStyle(color: Color(0xffc41a16)),
  'regexp': TextStyle(color: Color(0xff0E0EFF)),
  'link': TextStyle(color: Color(0xff0E0EFF)),
  'title': TextStyle(color: Color(0xff1c00cf)),
  'symbol': TextStyle(color: Color(0xff1c00cf)),
  'bullet': TextStyle(color: Color(0xff1c00cf)),
  'number': TextStyle(color: Color(0xff1c00cf)),
  'section': TextStyle(color: Color(0xff643820)),
  'meta': TextStyle(color: Color(0xff643820)),
  'type': TextStyle(color: Color(0xff5c2699)),
  'built_in': TextStyle(color: Color(0xff5c2699)),
  'builtin-name': TextStyle(color: Color(0xff5c2699)),
  'params': TextStyle(color: Color(0xff5c2699)),
  'attr': TextStyle(color: Color(0xff836C28)),
  'subst': TextStyle(color: Color(0xff000000)),
  'formula': TextStyle(
      backgroundColor: Color(0xffeeeeee), fontStyle: FontStyle.italic),
  'addition': TextStyle(backgroundColor: Color(0xffbaeeba)),
  'deletion': TextStyle(backgroundColor: Color(0xffffc8bd)),
  'selector-id': TextStyle(color: Color(0xff9b703f)),
  'selector-class': TextStyle(color: Color(0xff9b703f)),
  'doctag': TextStyle(fontWeight: FontWeight.bold),
  'strong': TextStyle(fontWeight: FontWeight.bold),
  'emphasis': TextStyle(fontStyle: FontStyle.italic),
};

const kDarkCodeTheme = {
  'root':
      TextStyle(backgroundColor: Color(0xff011627), color: Color(0xffd6deeb)),
  'keyword': TextStyle(color: Color(0xffc792ea)),
  'built_in': TextStyle(color: Color(0xffaddb67), fontStyle: FontStyle.italic),
  'type': TextStyle(color: Color(0xff82aaff)),
  'literal': TextStyle(color: Color(0xffff5874)),
  'number': TextStyle(color: Color(0xffF78C6C)),
  'regexp': TextStyle(color: Color(0xff5ca7e4)),
  'string': TextStyle(color: Color(0xffecc48d)),
  'subst': TextStyle(color: Color(0xffd3423e)),
  'symbol': TextStyle(color: Color(0xff82aaff)),
  'class': TextStyle(color: Color(0xffffcb8b)),
  'function': TextStyle(color: Color(0xff82AAFF)),
  'title': TextStyle(color: Color(0xffDCDCAA), fontStyle: FontStyle.italic),
  'params': TextStyle(color: Color(0xff7fdbca)),
  'comment': TextStyle(color: Color(0xff637777), fontStyle: FontStyle.italic),
  'doctag': TextStyle(color: Color(0xff7fdbca)),
  'meta': TextStyle(color: Color(0xff82aaff)),
  'meta-keyword': TextStyle(color: Color(0xff82aaff)),
  'meta-string': TextStyle(color: Color(0xffecc48d)),
  'section': TextStyle(color: Color(0xff82b1ff)),
  'tag': TextStyle(color: Color(0xff7fdbca)),
  'name': TextStyle(color: Color(0xff7fdbca)),
  'builtin-name': TextStyle(color: Color(0xff7fdbca)),
  'attr': TextStyle(color: Color(0xff7fdbca)),
  'attribute': TextStyle(color: Color(0xff80cbc4)),
  'variable': TextStyle(color: Color(0xffaddb67)),
  'bullet': TextStyle(color: Color(0xffd9f5dd)),
  'code': TextStyle(color: Color(0xff80CBC4)),
  'emphasis': TextStyle(color: Color(0xffc792ea), fontStyle: FontStyle.italic),
  'strong': TextStyle(color: Color(0xffaddb67), fontWeight: FontWeight.bold),
  'formula': TextStyle(color: Color(0xffc792ea)),
  'link': TextStyle(color: Color(0xffff869a)),
  'quote': TextStyle(color: Color(0xff697098), fontStyle: FontStyle.italic),
  'selector-tag': TextStyle(color: Color(0xffff6363)),
  'selector-id': TextStyle(color: Color(0xfffad430)),
  'selector-class':
      TextStyle(color: Color(0xffaddb67), fontStyle: FontStyle.italic),
  'selector-attr':
      TextStyle(color: Color(0xffc792ea), fontStyle: FontStyle.italic),
  'selector-pseudo':
      TextStyle(color: Color(0xffc792ea), fontStyle: FontStyle.italic),
  'template-tag': TextStyle(color: Color(0xffc792ea)),
  'template-variable': TextStyle(color: Color(0xffaddb67)),
  'addition':
      TextStyle(color: Color(0xffaddb67ff), fontStyle: FontStyle.italic),
  'deletion':
      TextStyle(color: Color(0xffef535090), fontStyle: FontStyle.italic),
};

enum HTTPVerb { get, head, post, put, patch, delete }

enum ContentType { json, text }

const kSupportedUriSchemes = ["https", "http"];
const kDefaultUriScheme = "https://";
const kMethodsWithBody = [
  HTTPVerb.post,
  HTTPVerb.put,
  HTTPVerb.patch,
  HTTPVerb.delete,
];
const kDefaultHttpMethod = HTTPVerb.get;
const kCodegenSuccessStatusCodes = {
  HTTPVerb.get: [200],
  HTTPVerb.head: [200],
  HTTPVerb.post: [200, 201, 204],
  HTTPVerb.put: [200, 201, 204],
  HTTPVerb.patch: [200, 201, 204],
  HTTPVerb.delete: [200, 202, 204]
};
const kDefaultContentType = ContentType.json;

const JsonEncoder kEncoder = JsonEncoder.withIndent('  ');
const LineSplitter kSplitter = LineSplitter();

const kTypeApplication = 'application';
// application
const kSubTypeJson = 'json';
const kSubTypePdf = 'pdf';
const kSubTypeSql = 'sql';
const kSubTypeXml = 'xml';
const kSubTypeOctetStream = 'octet-stream';
const kSubTypeYaml = 'x-yaml';
const kSubTypeYml = 'x-yml';

const kTypeText = 'text';
// text
const kSubTypeCss = 'css';
const kSubTypeCsv = 'csv';
const kSubTypeHtml = 'html';
const kSubTypeJavascript = 'javascript';
const kSubTypeMarkdown = 'markdown';
const kSubTypePlain = 'plain';
const kSubTypeTextXml = 'xml';
const kSubTypeTextYaml = 'yaml';
const kSubTypeTextYml = 'yml';

const kTypeImage = 'image';
//image
const kSubTypeSvg = 'svg+xml';

const kTypeAudio = 'audio';
const kTypeVideo = 'video';

const kSubTypeDefaultViewOptions = 'all';

const kContentTypeMap = {
  ContentType.json: "$kTypeApplication/$kSubTypeJson",
  ContentType.text: "$kTypeText/$kSubTypePlain",
};

enum ResponseBodyView { preview, code, raw, none }

const kKeyIcon = "icon";
const kKeyName = "name";
const Map<ResponseBodyView, Map> kResponseBodyViewIcons = {
  ResponseBodyView.preview: {
    kKeyName: "Preview",
    kKeyIcon: Icons.visibility_rounded
  },
  ResponseBodyView.code: {kKeyName: "Preview", kKeyIcon: Icons.code_rounded},
  ResponseBodyView.raw: {kKeyName: "Raw", kKeyIcon: Icons.text_snippet_rounded}
};

const kNoBodyViewOptions = [ResponseBodyView.none];
const kRawBodyViewOptions = [ResponseBodyView.raw];
const kCodeRawBodyViewOptions = [ResponseBodyView.code, ResponseBodyView.raw];
const kPreviewBodyViewOptions = [
  ResponseBodyView.preview,
];
const kPreviewCodeRawBodyViewOptions = [
  ResponseBodyView.preview,
  ResponseBodyView.code,
  ResponseBodyView.raw
];

const Map<String, Map<String, List<ResponseBodyView>>>
    kResponseBodyViewOptions = {
  kTypeApplication: {
    kSubTypeDefaultViewOptions: kNoBodyViewOptions,
    kSubTypeJson: kCodeRawBodyViewOptions,
    kSubTypePdf: kPreviewBodyViewOptions,
    kSubTypeSql: kCodeRawBodyViewOptions,
    kSubTypeXml: kCodeRawBodyViewOptions,
    kSubTypeYaml: kCodeRawBodyViewOptions,
    kSubTypeYml: kCodeRawBodyViewOptions,
  },
  kTypeImage: {
    kSubTypeDefaultViewOptions: kPreviewBodyViewOptions,
    kSubTypeSvg: kCodeRawBodyViewOptions,
  },
  kTypeAudio: {
    kSubTypeDefaultViewOptions: kPreviewBodyViewOptions,
  },
  kTypeVideo: {
    kSubTypeDefaultViewOptions: kPreviewBodyViewOptions,
  },
  kTypeText: {
    kSubTypeDefaultViewOptions: kRawBodyViewOptions,
    kSubTypeCss: kCodeRawBodyViewOptions,
    kSubTypeHtml: kCodeRawBodyViewOptions,
    kSubTypeJavascript: kCodeRawBodyViewOptions,
    kSubTypeMarkdown: kCodeRawBodyViewOptions,
    kSubTypeTextXml: kCodeRawBodyViewOptions,
    kSubTypeTextYaml: kCodeRawBodyViewOptions,
    kSubTypeTextYml: kCodeRawBodyViewOptions,
  },
};

const Map<String, String> kCodeHighlighterMap = {
  kSubTypeHtml: "xml",
  kSubTypeYaml: "yaml",
  kSubTypeYml: "yaml",
  kSubTypeTextYaml: "yaml",
  kSubTypeTextYml: "yaml",
};

const sendingIndicator = AssetImage("assets/sending.gif");

// HTTP response status codes
// https://developer.mozilla.org/en-US/docs/Web/HTTP/Status
const kResponseCodeReasons = {
  // 100s - Informational responses
  100: 'Continue',
  101: 'Switching Protocols',
  102: 'Processing',
  103: 'Early Hints',
  // 200s - Successful responses
  200: 'OK',
  201: 'Created',
  202: 'Accepted',
  203: 'Non-Authoritative Information',
  204: 'No Content',
  205: 'Reset Content',
  206: 'Partial Content',
  207: 'Multi-Status',
  208: 'Already Reported',
  226: 'IM Used',
  // 300s - Redirection messages
  300: 'Multiple Choices',
  301: 'Moved Permanently',
  302: 'Found',
  303: 'See Other',
  304: 'Not Modified',
  305: 'Use Proxy',
  306: 'Switch Proxy',
  307: 'Temporary Redirect',
  308: 'Permanent Redirect',
  // 400s - Client error responses
  400: 'Bad Request',
  401: 'Unauthorized',
  402: 'Payment Required',
  403: 'Forbidden',
  404: 'Not Found',
  405: 'Method Not Allowed',
  406: 'Not Acceptable',
  407: 'Proxy Authentication Required',
  408: 'Request Timeout',
  409: 'Conflict',
  410: 'Gone',
  411: 'Length Required',
  412: 'Precondition Failed',
  413: 'Payload Too Large',
  414: 'URI Too Long',
  415: 'Unsupported Media Type',
  416: 'Range Not Satisfiable',
  417: 'Expectation Failed',
  418: "I'm a Teapot",
  421: 'Misdirected Request',
  422: 'Unprocessable Entity',
  423: 'Locked',
  424: 'Failed Dependency',
  425: 'Too Early',
  426: 'Upgrade Required',
  428: 'Precondition Required',
  429: 'Too Many Requests',
  431: 'Request Header Fields Too Large',
  451: 'Unavailable For Legal Reasons',
  // 500s - Server error responses
  500: 'Internal Server Error',
  501: 'Not Implemented',
  502: 'Bad Gateway',
  503: 'Service Unavailable',
  504: 'Gateway Timeout',
  505: 'HTTP Version Not Supported',
  506: 'Variant Also Negotiates',
  507: 'Insufficient Storage',
  508: 'Loop Detected',
  510: 'Not Extended',
  511: 'Network Authentication Required',
};

const kIntro =
    """An open-source cross-platform API GUI Client that can help you:
- Create & customize API requests
- Visually inspect API responses
- Generate Dart Code Automatically
""";

const kMimeTypeRaiseIssue =
    " is currently not supported.\nPlease raise an issue in API Dash GitHub repo so that we can prioritize adding it to the tool.";

const kUnexpectedRaiseIssue =
    "\nIf the behaviour is unexpected, please raise an issue in API Dash GitHub repo so that we can resolve it.";

const kRaiseIssue =
    "\nPlease raise an issue in API Dash GitHub repo so that we can resolve it.";
