import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kDiscordUrl = "https://bit.ly/heyfoss";
const kGitUrl = "https://github.com/foss42/apidash";
const kIssueUrl = "$kGitUrl/issues";
const kDefaultUri = "api.apidash.dev";

const kAssetIntroMd = "assets/intro.md";
const kAssetSendingLottie = "assets/sending.json";
const kAssetSavingLottie = "assets/saving.json";
const kAssetSavedLottie = "assets/completed.json";

final kIsMacOS = !kIsWeb && Platform.isMacOS;
final kIsWindows = !kIsWeb && Platform.isWindows;
final kIsLinux = !kIsWeb && Platform.isLinux;
final kIsApple = !kIsWeb && (Platform.isIOS || Platform.isMacOS);
final kIsDesktop =
    !kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);
final kIsRunningTests = Platform.environment.containsKey('FLUTTER_TEST');
final kIsIOS = !kIsWeb && Platform.isIOS;
final kIsAndroid = !kIsWeb && Platform.isAndroid;
final kIsMobile = !kIsWeb && (Platform.isIOS || Platform.isAndroid);

final kColorTransparentState =
    MaterialStateProperty.all<Color>(Colors.transparent);
const kColorTransparent = Colors.transparent;
const kColorWhite = Colors.white;
const kColorBlack = Colors.black;
const kColorRed = Colors.red;
final kColorLightDanger = Colors.red.withOpacity(0.9);
const kColorDarkDanger = Color(0xffcf6679);

const kWindowTitle = "API Dash";
const kMinWindowSize = Size(900, 600);
const kMinInitialWindowWidth = 1200.0;
const kMinInitialWindowHeight = 800.0;
const kMinRequestEditorDetailsCardPaneSize = 300.0;

const kColorSchemeSeed = Colors.blue;
final kFontFamily = GoogleFonts.openSans().fontFamily;
final kFontFamilyFallback =
    kIsApple ? null : <String>[GoogleFonts.notoColorEmoji().fontFamily!];

final kCodeStyle = TextStyle(
  fontFamily: GoogleFonts.sourceCodePro().fontFamily,
  fontFamilyFallback: kFontFamilyFallback,
);

const kHintOpacity = 0.6;
const kForegroundOpacity = 0.05;
const kOverlayBackgroundOpacity = 0.5;

const kTextStyleButton = TextStyle(fontWeight: FontWeight.bold);
const kTextStyleTab = TextStyle(fontSize: 14);
const kTextStyleButtonSmall = TextStyle(fontSize: 12);
const kFormDataButtonLabelTextStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
);

const kBorderRadius8 = BorderRadius.all(Radius.circular(8));
final kBorderRadius10 = BorderRadius.circular(10);
const kBorderRadius12 = BorderRadius.all(Radius.circular(12));

const kP1 = EdgeInsets.all(1);
const kP5 = EdgeInsets.all(5);
const kP8 = EdgeInsets.all(8);
const kPs8 = EdgeInsets.only(left: 8);
const kPs2 = EdgeInsets.only(left: 2);
const kPe8 = EdgeInsets.only(right: 8.0);
const kPh20v5 = EdgeInsets.symmetric(horizontal: 20, vertical: 5);
const kPh20v10 = EdgeInsets.symmetric(horizontal: 20, vertical: 10);
const kP10 = EdgeInsets.all(10);
const kPv8 = EdgeInsets.symmetric(vertical: 8);
const kPv2 = EdgeInsets.symmetric(vertical: 2);
const kPh2 = EdgeInsets.symmetric(horizontal: 2);
const kPt24o8 = EdgeInsets.only(top: 24, left: 8.0, right: 8.0, bottom: 8.0);
const kPt5o10 =
    EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 10.0);
const kPh4 = EdgeInsets.symmetric(horizontal: 4);
const kPh8 = EdgeInsets.symmetric(horizontal: 8);
const kPh20 = EdgeInsets.symmetric(
  horizontal: 20,
);
const kPh20t40 = EdgeInsets.only(
  left: 20,
  right: 20,
  top: 40,
);
const kPh60 = EdgeInsets.symmetric(horizontal: 60);
const kPh60v60 = EdgeInsets.symmetric(vertical: 60, horizontal: 60);
const kP24CollectionPane = EdgeInsets.only(
  top: 24,
  left: 4.0,
  //right: 4.0,
  // bottom: 8.0,
);
const kP8CollectionPane = EdgeInsets.only(
  top: 8.0,
  left: 4.0,
  //right: 4.0,
  // bottom: 8.0,
);
const kPb10 = EdgeInsets.only(
  bottom: 10,
);
const kPb15 = EdgeInsets.only(
  bottom: 15,
);
const kHSpacer4 = SizedBox(width: 4);
const kHSpacer5 = SizedBox(width: 5);
const kHSpacer10 = SizedBox(width: 10);
const kHSpacer20 = SizedBox(width: 20);
const kVSpacer5 = SizedBox(height: 5);
const kVSpacer8 = SizedBox(height: 8);
const kVSpacer10 = SizedBox(height: 10);
const kVSpacer20 = SizedBox(height: 20);
const kVSpacer40 = SizedBox(height: 40);

const kTabAnimationDuration = Duration(milliseconds: 200);
const kTabHeight = 32.0;
const kHeaderHeight = 32.0;
const kSegmentHeight = 24.0;
const kTextButtonMinWidth = 44.0;

const kRandMax = 100000;

const kDataTableScrollbarTheme = ScrollbarThemeData(
  crossAxisMargin: -4,
);
const kDataTableBottomPadding = 12.0;
const kDataTableRowHeight = 36.0;

const kIconRemoveDark = Icon(
  Icons.remove_circle,
  size: 16,
  color: kColorDarkDanger,
);

final kIconRemoveLight = Icon(
  Icons.remove_circle,
  size: 16,
  color: kColorLightDanger,
);

const kCodePreviewLinesLimit = 500;
const kCodeCharsPerLineLimit = 200;

const kLightCodeTheme = {
  'root':
      TextStyle(backgroundColor: Color(0xffffffff), color: Color(0xff000000)),
  'addition': TextStyle(backgroundColor: Color(0xffbaeeba)),
  'attr': TextStyle(color: Color(0xff836C28)),
  'attribute': TextStyle(color: Color(0xffaa0d91)),
  'built_in': TextStyle(color: Color(0xff5c2699)),
  'builtin-name': TextStyle(color: Color(0xff5c2699)),
  'bullet': TextStyle(color: Color(0xff1c00cf)),
  'code': TextStyle(color: Color(0xffc41a16)),
  'comment': TextStyle(color: Color(0xff007400), fontStyle: FontStyle.italic),
  'deletion': TextStyle(backgroundColor: Color(0xffffc8bd)),
  'doctag': TextStyle(fontWeight: FontWeight.bold),
  'emphasis': TextStyle(fontStyle: FontStyle.italic),
  'formula': TextStyle(
      backgroundColor: Color(0xffeeeeee), fontStyle: FontStyle.italic),
  'keyword': TextStyle(color: Color(0xffaa0d91)),
  'link': TextStyle(color: Color(0xff0E0EFF)),
  'literal': TextStyle(color: Color(0xffaa0d91)),
  'meta': TextStyle(color: Color(0xff643820)),
  'meta-string': TextStyle(color: Color(0xffc41a16)),
  'name': TextStyle(color: Color(0xffaa0d91)),
  'number': TextStyle(color: Color(0xff1c00cf)),
  'params': TextStyle(color: Color(0xff5c2699)),
  'quote': TextStyle(color: Color(0xff007400)),
  'regexp': TextStyle(color: Color(0xff0E0EFF)),
  'section': TextStyle(color: Color(0xff643820)),
  'selector-class': TextStyle(color: Color(0xff9b703f)),
  'selector-id': TextStyle(color: Color(0xff9b703f)),
  'selector-tag': TextStyle(color: Color(0xffaa0d91)),
  'string': TextStyle(color: Color(0xffc41a16)),
  'strong': TextStyle(fontWeight: FontWeight.bold),
  'subst': TextStyle(color: Color(0xff000000)),
  'symbol': TextStyle(color: Color(0xff1c00cf)),
  'tag': TextStyle(color: Color(0xffaa0d91)),
  'template-variable': TextStyle(color: Color(0xff3F6E74)),
  'title': TextStyle(color: Color(0xff1c00cf)),
  'type': TextStyle(color: Color(0xff5c2699)),
  'variable': TextStyle(color: Color(0xff3F6E74)),
};

const kDarkCodeTheme = {
  'root':
      TextStyle(backgroundColor: Color(0xff011627), color: Color(0xffd6deeb)),
  'addition': TextStyle(color: Color(0xffaddb67)),
  'attr': TextStyle(color: Color(0xff7fdbca)),
  'attribute': TextStyle(color: Color(0xff80cbc4)),
  'built_in': TextStyle(color: Color(0xffaddb67)),
  'builtin-name': TextStyle(color: Color(0xff7fdbca)),
  'bullet': TextStyle(color: Color(0xffd9f5dd)),
  'class': TextStyle(color: Color(0xffffcb8b)),
  'code': TextStyle(color: Color(0xff80CBC4)),
  'comment': TextStyle(color: Color(0xff637777), fontStyle: FontStyle.italic),
  'deletion': TextStyle(color: Color(0xffef5350)),
  'doctag': TextStyle(color: Color(0xff7fdbca)),
  'emphasis': TextStyle(color: Color(0xffc792ea)),
  'formula': TextStyle(color: Color(0xffc792ea), fontStyle: FontStyle.italic),
  'function': TextStyle(color: Color(0xff82AAFF)),
  'keyword': TextStyle(color: Color(0xffc792ea)),
  'link': TextStyle(color: Color(0xffff869a)),
  'literal': TextStyle(color: Color(0xffff5874)),
  'meta': TextStyle(color: Color(0xff82aaff)),
  'meta-keyword': TextStyle(color: Color(0xff82aaff)),
  'meta-string': TextStyle(color: Color(0xffecc48d)),
  'name': TextStyle(color: Color(0xff7fdbca)),
  'number': TextStyle(color: Color(0xffF78C6C)),
  'params': TextStyle(color: Color(0xff7fdbca)),
  'quote': TextStyle(color: Color(0xff697098)),
  'regexp': TextStyle(color: Color(0xff5ca7e4)),
  'section': TextStyle(color: Color(0xff82b1ff)),
  'selector-attr': TextStyle(color: Color(0xffc792ea)),
  'selector-class': TextStyle(color: Color(0xffaddb67)),
  'selector-id': TextStyle(color: Color(0xfffad430)),
  'selector-pseudo': TextStyle(color: Color(0xffc792ea)),
  'selector-tag': TextStyle(color: Color(0xffff6363)),
  'string': TextStyle(color: Color(0xffecc48d)),
  'strong': TextStyle(color: Color(0xffaddb67), fontWeight: FontWeight.bold),
  'subst': TextStyle(color: Color(0xffd3423e)),
  'symbol': TextStyle(color: Color(0xff82aaff)),
  'tag': TextStyle(color: Color(0xff7fdbca)),
  'template-tag': TextStyle(color: Color(0xffc792ea)),
  'template-variable': TextStyle(color: Color(0xffaddb67)),
  'title': TextStyle(color: Color(0xffDCDCAA)),
  'type': TextStyle(color: Color(0xff82aaff)),
  'variable': TextStyle(color: Color(0xffaddb67)),
};

final kColorStatusCodeDefault = Colors.grey.shade700;
final kColorStatusCode200 = Colors.green.shade800;
final kColorStatusCode300 = Colors.blue.shade800;
final kColorStatusCode400 = Colors.red.shade800;
final kColorStatusCode500 = Colors.amber.shade900;
const kOpacityDarkModeBlend = 0.4;

final kColorHttpMethodGet = Colors.green.shade800;
final kColorHttpMethodHead = kColorHttpMethodGet;
final kColorHttpMethodPost = Colors.blue.shade800;
final kColorHttpMethodPut = Colors.amber.shade900;
final kColorHttpMethodPatch = kColorHttpMethodPut;
final kColorHttpMethodDelete = Colors.red.shade800;

enum RequestItemMenuOption { edit, delete, duplicate }

enum HTTPVerb { get, head, post, put, patch, delete }

enum FormDataType { text, file }

const kSupportedUriSchemes = ["https", "http"];
const kDefaultUriScheme = "https";
const kMethodsWithBody = [
  HTTPVerb.post,
  HTTPVerb.put,
  HTTPVerb.patch,
  HTTPVerb.delete,
];

const kDefaultHttpMethod = HTTPVerb.get;
const kDefaultContentType = ContentType.json;

enum CodegenLanguage {
  curl("cURL", "bash", "curl"),
  har("HAR", "json", "har"),
  cCurlCodeGen("C (Curl)", "C", "c"),
  cSharpRestSharp("C# (Rest Sharp)", "cs", "cs"),
  dartHttp("Dart (http)", "dart", "dart"),
  dartDio("Dart (dio)", "dart", "dart"),
  goHttp("Go (http)", "go", "go"),
  jsAxios("JavaScript (axios)", "javascript", "js"),
  jsFetch("JavaScript (fetch)", "javascript", "js"),
  nodejsAxios("node.js (axios)", "javascript", "js"),
  nodejsFetch("node.js (fetch)", "javascript", "js"),
  kotlinOkHttp("Kotlin (okhttp3)", "java", "kt"),
  pythonRequests("Python (requests)", "python", "py"),
  pythonHttpClient("Python (http.client)", "python", "py"),
  rubyFaraday("Ruby (Faraday)", "ruby", "rb"),
  rubyNetHttp("Ruby (Net::Http)", "Ruby", "rb"),
  rustActix("Rust (Actix Client)", "rust", "rs"),
  rustReqwest("Rust (reqwest)", "rust", "rs"),
  rustCurl("Rust (curl-rust)", "rust", "rs"),
  rustUreq("Rust (ureq)", "rust", "rs"),
  javaOkHttp("Java (okhttp3)", "java", 'java'),
  javaAsyncHttpClient("Java (asynchttpclient)", "java", "java"),
  javaHttpClient("Java (HttpClient)", "java", "java"),
  javaUnirest("Java (Unirest)", "java", "java"),
  juliaHttp("Julia (HTTP)", "julia", "jl"),
  phpCurl("PHP (cURL)", "php", "php"),
  phpGuzzle("PHP (guzzle)", "php", "php"),
  phpHttpPlug("PHP (httpPlug)", "php", "php");

  const CodegenLanguage(this.label, this.codeHighlightLang, this.ext);
  final String label;
  final String codeHighlightLang;
  final String ext;
}

const JsonEncoder kEncoder = JsonEncoder.withIndent('  ');
const LineSplitter kSplitter = LineSplitter();

const kHeaderContentType = "Content-Type";

const kTypeApplication = 'application';
// application
const kSubTypeJson = 'json';
const kSubTypeOctetStream = 'octet-stream';
const kSubTypePdf = 'pdf';
const kSubTypeSql = 'sql';
const kSubTypeXml = 'xml';
const kSubTypeYaml = 'yaml';
const kSubTypeXYaml = 'x-yaml';
const kSubTypeYml = 'x-yml';
// in future need to add support for url-encoded form data
const kSubTypeXWwwFormUrlencoded = 'x-www-form-urlencoded';

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

const kTypeMultipart = "multipart";
const kSubTypeFormData = "form-data";

const kSubTypeDefaultViewOptions = 'all';

enum ContentType {
  json("$kTypeApplication/$kSubTypeJson"),
  text("$kTypeText/$kSubTypePlain"),
  formdata("$kTypeMultipart/$kSubTypeFormData");

  const ContentType(this.header);
  final String header;
}

enum ResponseBodyView {
  preview("Preview", Icons.visibility_rounded),
  code("Preview", Icons.code_rounded),
  raw("Raw", Icons.text_snippet_rounded),
  none("Preview", Icons.warning);

  const ResponseBodyView(this.label, this.icon);
  final String label;
  final IconData icon;
}

const kNoBodyViewOptions = [ResponseBodyView.none];
const kNoRawBodyViewOptions = [ResponseBodyView.none, ResponseBodyView.raw];
const kRawBodyViewOptions = [ResponseBodyView.raw];
const kCodeRawBodyViewOptions = [ResponseBodyView.code, ResponseBodyView.raw];
const kPreviewBodyViewOptions = [
  ResponseBodyView.preview,
];
const kPreviewRawBodyViewOptions = [
  ResponseBodyView.preview,
  ResponseBodyView.raw
];
const kPreviewCodeRawBodyViewOptions = [
  ResponseBodyView.preview,
  ResponseBodyView.code,
  ResponseBodyView.raw
];

const Map<String, Map<String, List<ResponseBodyView>>>
    kResponseBodyViewOptions = {
  kTypeApplication: {
    kSubTypeDefaultViewOptions: kNoRawBodyViewOptions,
    kSubTypeJson: kPreviewRawBodyViewOptions,
    kSubTypeOctetStream: kNoBodyViewOptions,
    kSubTypePdf: kPreviewBodyViewOptions,
    kSubTypeSql: kCodeRawBodyViewOptions,
    kSubTypeXml: kCodeRawBodyViewOptions,
    kSubTypeYaml: kCodeRawBodyViewOptions,
    kSubTypeXYaml: kCodeRawBodyViewOptions,
    kSubTypeYml: kCodeRawBodyViewOptions,
  },
  kTypeImage: {
    kSubTypeDefaultViewOptions: kPreviewBodyViewOptions,
    kSubTypeSvg: kPreviewRawBodyViewOptions,
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
    kSubTypeCsv: kPreviewRawBodyViewOptions,
    kSubTypeJavascript: kCodeRawBodyViewOptions,
    kSubTypeMarkdown: kCodeRawBodyViewOptions,
    kSubTypeTextXml: kCodeRawBodyViewOptions,
    kSubTypeTextYaml: kCodeRawBodyViewOptions,
    kSubTypeTextYml: kCodeRawBodyViewOptions,
  },
};

const Map<String, String> kCodeHighlighterMap = {
  kSubTypeHtml: "xml",
  kSubTypeSvg: "xml",
  kSubTypeYaml: "yaml",
  kSubTypeXYaml: "yaml",
  kSubTypeYml: "yaml",
  //kSubTypeTextYaml: "yaml",
  kSubTypeTextYml: "yaml",
};

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

const kMimeTypeRawRaiseIssueStart =
    "Please click on 'Raw' to view the unformatted raw results as the response preview for Content-Type ";

const kMimeTypeRaiseIssueStart = "Response preview for Content-Type ";

const kMimeTypeRaiseIssue =
    " is currently not supported.\nPlease raise an issue in API Dash GitHub repo so that we can add a Previewer for this content-type.";

const kUnexpectedRaiseIssue =
    "\nIf the behaviour is unexpected, please raise an issue in API Dash GitHub repo so that we can resolve it.";

const kVideoError =
    "There seems to be an issue playing this video. Please raise an issue in API Dash GitHub repo so that we can resolve it.";

const kImageError =
    "There seems to be an issue rendering this image. Please raise an issue in API Dash GitHub repo so that we can resolve it.";

const kSvgError =
    "There seems to be an issue rendering this SVG image. Please raise an issue in API Dash GitHub repo so that we can resolve it.";

const kPdfError =
    "There seems to be an issue rendering this pdf. Please raise an issue in API Dash GitHub repo so that we can resolve it.";

const kAudioError =
    "There seems to be an issue playing this audio. Please raise an issue in API Dash GitHub repo so that we can resolve it.";

const kRaiseIssue =
    "\nPlease raise an issue in API Dash GitHub repo so that we can resolve it.";

const kCsvError =
    "There seems to be an issue rendering this CSV. Please raise an issue in API Dash GitHub repo so that we can resolve it.";

const kHintTextUrlCard = "Enter API endpoint like https://$kDefaultUri/";
const kLabelPlusNew = "+ New";
const kLabelSend = "Send";
const kLabelSending = "Sending..";
const kLabelBusy = "Busy";
const kLabelCopy = "Copy";
const kLabelSave = "Save";
const kLabelDownload = "Download";
const kLabelSaving = "Saving";
const kLabelSaved = "Saved";
// Request Pane
const kLabelRequest = "Request";
const kLabelHideCode = "Hide Code";
const kLabelViewCode = "View Code";
const kLabelURLParams = "URL Params";
const kLabelHeaders = "Headers";
const kLabelBody = "Body";
const kNameCheckbox = "Checkbox";
const kNameURLParam = "URL Parameter";
const kNameHeader = "Header Name";
const kNameValue = "Value";
const kNameField = "Field";
const kHintAddURLParam = "Add URL Parameter";
const kHintAddValue = "Add Value";
const kHintAddName = "Add Name";
const kHintAddFieldName = "Add Field Name";
const kLabelAddParam = "Add Param";
const kLabelAddHeader = "Add Header";
const kLabelSelectFile = "Select File";
const kLabelAddFormField = "Add Form Field";
// Response Pane
const kLabelNotSent = "Not Sent";
const kLabelResponse = "Response";
const kLabelResponseBody = "Response Body";
const kTooltipClearResponse = "Clear Response";
const kHeaderRow = ["Header Name", "Header Value"];
const kLabelRequestHeaders = "Request Headers";
const kLabelResponseHeaders = "Response Headers";
const kLabelItems = "items";
const kMsgError = "Error: Response data does not exist.";
const kMsgNullBody = "Response body is missing (null).";
const kMsgNoContent = "No content";
const kMsgUnknowContentType = "Unknown Response Content-Type";
