import 'dart:io';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

const kWindowTitle = "API Dash";
const kMinWindowSize = Size(320, 640);
const kMinInitialWindowWidth = 1200.0;
const kMinInitialWindowHeight = 800.0;
const kMinRequestEditorDetailsCardPaneSize = 300.0;
const kCompactWindowWidth = 600.0;
const kMediumWindowWidth = 840.0;
const kExpandedWindowWidth = 1200.0;
const kLargeWindowWidth = 1600.0;

final kHomeScaffoldKey = GlobalKey<ScaffoldState>();
final kEnvScaffoldKey = GlobalKey<ScaffoldState>();
final kHisScaffoldKey = GlobalKey<ScaffoldState>();

const kTabAnimationDuration = Duration(milliseconds: 200);
const kTabHeight = 40.0;
const kHeaderHeight = 32.0;
const kSegmentHeight = 24.0;
const kTextButtonMinWidth = 44.0;

const kRandMax = 100000;

const kSuggestionsMenuWidth = 300.0;
const kSuggestionsMenuMaxHeight = 200.0;

const kSegmentedTabWidth = 140.0;
const kSegmentedTabHeight = 32.0;

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

enum HistoryRetentionPeriod {
  oneWeek("1 Week", Icons.calendar_view_week_rounded),
  oneMonth("1 Month", Icons.calendar_view_month_rounded),
  threeMonths("3 Months", Icons.calendar_month_rounded),
  forever("Forever", Icons.all_inclusive_rounded);

  const HistoryRetentionPeriod(this.label, this.icon);
  final String label;
  final IconData icon;
}

enum ItemMenuOption {
  edit("Rename"),
  delete("Delete"),
  duplicate("Duplicate");

  const ItemMenuOption(this.label);
  final String label;
}

enum SidebarMenuOption {
  import("Import");

  const SidebarMenuOption(this.label);
  final String label;
}

enum EnvironmentVariableType { variable, secret }

final kEnvVarRegEx = RegExp(r'{{([^{}]*)}}');

enum CodegenLanguage {
  curl("cURL", "bash", "curl"),
  har("HAR", "json", "har"),
  cCurlCodeGen("C (Curl)", "cpp", "c"),
  cSharpHttpClient("C# (Http Client)", "cs", "cs"),
  cSharpRestSharp("C# (Rest Sharp)", "cs", "cs"),
  dartHttp("Dart (http)", "dart", "dart"),
  dartDio("Dart (dio)", "dart", "dart"),
  goHttp("Go (http)", "go", "go"),
  jsAxios("JavaScript (axios)", "javascript", "js"),
  jsFetch("JavaScript (fetch)", "javascript", "js"),
  nodejsAxios("node.js (axios)", "javascript", "js"),
  nodejsFetch("node.js (fetch)", "javascript", "js"),
  kotlinOkHttp("Kotlin (okhttp3)", "kotlin", "kt"),
  pythonRequests("Python (requests)", "python", "py"),
  pythonHttpClient("Python (http.client)", "python", "py"),
  rubyFaraday("Ruby (Faraday)", "ruby", "rb"),
  rubyNetHttp("Ruby (Net::Http)", "ruby", "rb"),
  rustActix("Rust (Actix Client)", "rust", "rs"),
  rustHyper("Rust (Hyper)", "rust", "rs"),
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

enum ImportFormat {
  curl("cURL");

  const ImportFormat(this.label);
  final String label;
}

const String kGlobalEnvironmentId = "global";

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

Map<String, String> kHttpHeadersMap = {
  "Accept": "Specifies the media types that are acceptable for the response.",
  "Accept-Encoding":
      "Indicates the encoding methods the client can understand.",
  "Accept-Charset": "Specifies the character sets that are acceptable.",
  "Access-Control-Allow-Headers":
      "Specifies a list of HTTP headers that can be used in an actual request after a preflight request including the Access-Control-Request-Headers header is made.",
  "Access-Control-Allow-Methods":
      "Specifies a list of HTTP request methods allowed during CORS. ",
  "Access-Control-Allow-Origin":
      "Indicates whether the response can be shared with the requesting code from the given origin.",
  "Access-Control-Max-Age":
      "Indicates the maximum amount of time the results of a preflight request can be cached.",
  "Access-Control-Request-Headers":
      "Used in preflight requests during CORS to specify the headers that will be included in the actual request.",
  "Access-Control-Request-Method":
      "Used in preflight requests during CORS to indicate the HTTP method that will be used in the actual request.",
  "Accept-Language":
      "Specifies the preferred natural language and locale for the response.",
  "Authorization":
      "Contains credentials for authenticating the client with the server.",
  "Authorization Bearer Token": "Often used for token-based authentication.",
  "Cache-Control":
      "Provides directives for caching mechanisms in both requests and responses.",
  "Connection":
      "Informs whether the connection stays open or close after the current transaction finishes.",
  "Content-Disposition":
      "Specifies the presentation style (inline or attachment) of the response.",
  "Content-Encoding":
      "Indicates the encoding transformations that have been applied to the entity body of the response.",
  "Content-Length":
      "Indicates the size of the message body sent to the recipient in bytes.",
  "Content-Security-Policy":
      "Controls the sources from which content can be loaded on a web page to mitigate various types of attacks.",
  "Content-Type":
      "Indicates the original media type of the resource (prior to any content encoding applied for sending)",
  "Cookie": "Used to send previously stored cookies back to the server.",
  "Cross-Origin-Embedder-Policy":
      "Controls whether a document is allowed to be embedded in another document.",
  "Cross-Origin-Opener-Policy":
      "Controls which documents are allowed to open a new window or access the current window.",
  "Cross-Origin-Resource-Policy":
      "Controls how cross-origin requests for resources are handled.",
  "Date": "Indicates the date and time at which the message was sent.",
  "Device-Memory":
      "Indicates the approximate amount of device memory in gigabytes.",
  "DNT":
      "Informs websites whether the user's preference is to opt out of online tracking.",
  "Expect": "Indicates certain expectations that need to be met by the server.",
  "Expires":
      "Contains the date/time after which the response is considered expired",
  "Forwarded":
      "Contains information from the client-facing side of proxy servers that is altered or lost when a proxy is involved in the path of the request.",
  "From":
      "Contains an Internet email address for a human user who controls the requesting user agent.",
  "Host": "Specifies the domain name of the server and the port number.",
  "If-Match":
      "Used for conditional requests, allows the server to respond based on certain conditions.",
  "If-Modified-Since":
      "Used for conditional requests, allows the server to respond based on certain conditions.",
  "If-None-Match":
      "Used for conditional requests, allows the server to respond based on certain conditions.",
  "If-Range":
      "Used in conjunction with the Range header to conditionally request a partial resource.",
  "If-Unmodified-Since":
      "Used for conditional requests, allows the server to respond based on certain conditions.",
  "Keep-Alive":
      "Used to allow the connection to be reused for further requests.",
  "Location":
      "Indicates the URL a client should redirect to for further interaction.",
  "Max-Forwards":
      "Indicates the remaining number of times a request can be forwarded by proxies.",
  "Origin": "Specifies the origin of a cross-origin request.",
  "Proxy-Authorization":
      "Contains credentials for authenticating a client with a proxy server.",
  "Range":
      "Used to request only part of a resource, typically in the context of downloading large files.",
  "Referer":
      "Indicates the URL of the page that referred the client to the current URL.",
  "Referrer-Policy":
      "Specifies how much information the browser should include in the Referer header when navigating to other pages.",
  "Retry-After":
      "Informs the client how long it should wait before making another request after a server has responded with a rate-limiting status code.",
  "Save-Data": "Indicates the client's preference for reduced data usage.",
  "Server": "Indicates the software used by the origin server.",
  "Strict-Transport-Security":
      "Instructs the browser to always use HTTPS for the given domain.",
  "TE": "Specifies the transfer encodings that are acceptable to the client.",
  "Upgrade-Insecure-Requests":
      "Instructs the browser to prefer secure connections when available.",
  "User-Agent":
      "Identifies the client software and version making the request.",
  "Via":
      "Indicates intermediate proxies or gateways through which the request or response has passed.",
  "X-Api-Key": "Used to authenticate requests to an API with an API key.",
  "X-Content-Type-Options":
      "Used to prevent browsers from MIME-sniffing a response.",
  "X-CSRF-Token":
      "Used for protection against Cross-Site Request Forgery (CSRF) attacks.",
  "X-Forwarded-For":
      "Identifies the client's original IP address when behind a proxy or load balancer.",
  "X-Frame-Options":
      "Controls whether a webpage can be displayed within an iframe or other embedded frame elements.",
  "X-Requested-With":
      "Indicates whether the request was made with JavaScript using XMLHttpRequest.",
  "X-XSS-Protection":
      "Enables or disables the browser's built-in cross-site scripting (XSS) filter.",
};

const kMimeTypeRaiseIssue =
    "{% if showRaw %}Please click on 'Raw' to view the unformatted raw results as we{% else %}We{% endif %} encountered an error rendering this {% if showContentType %}Content-Type {% endif %}{{type}}.\nPlease raise an issue in API Dash GitHub repo so that we can look into this issue.";

const kUnexpectedRaiseIssue =
    "\nIf the behaviour is unexpected, please raise an issue in API Dash GitHub repo so that we can resolve it.";

const kRaiseIssue =
    "\nPlease raise an issue in API Dash GitHub repo so that we can resolve it.";

const kHintTextUrlCard = "Enter API endpoint like https://$kDefaultUri/";
const kLabelPlusNew = "+ New";
const kLabelMoreOptions = "More Options";
const kLabelSend = "Send";
const kLabelSending = "Sending..";
const kLabelBusy = "Busy";
const kLabelCopy = "Copy";
const kLabelSave = "Save";
const kLabelDownload = "Download";
const kLabelSaving = "Saving";
const kLabelSaved = "Saved";
const kLabelCode = "Code";
const kLabelDuplicate = "Duplicate";
const kLabelSelect = "Select";
const kLabelContinue = "Continue";
const kLabelCancel = "Cancel";
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
const kLabelAddVariable = "Add Variable";
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
const kNullResponseModelError = "Error: Response data does not exist.";
const kMsgNullBody = "Response body is missing (null).";
const kMsgNoContent = "No content";
const kMsgUnknowContentType = "Unknown Response Content-Type";
// Workspace Selector
const kMsgSelectWorkspace = "Create your workspace";
