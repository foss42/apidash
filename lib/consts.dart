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
const kAssetGenerateCodeLottie = "assets/generate.json";
const kAssetApiServerLottie = "assets/api_server.json";
const kAssetFolderLottie = "assets/files.json";

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
  javaAsyncHttpClient("Java (asynchttpclient)", "java", "java"),
  javaHttpClient("Java (HttpClient)", "java", "java"),
  javaOkHttp("Java (okhttp3)", "java", 'java'),
  javaUnirest("Java (Unirest)", "java", "java"),
  juliaHttp("Julia (HTTP)", "julia", "jl"),
  kotlinOkHttp("Kotlin (okhttp3)", "kotlin", "kt"),
  phpCurl("PHP (cURL)", "php", "php"),
  phpGuzzle("PHP (guzzle)", "php", "php"),
  phpHttpPlug("PHP (httpPlug)", "php", "php"),
  pythonRequests("Python (requests)", "python", "py"),
  pythonHttpClient("Python (http.client)", "python", "py"),
  rubyFaraday("Ruby (Faraday)", "ruby", "rb"),
  rubyNetHttp("Ruby (Net::Http)", "ruby", "rb"),
  rustActix("Rust (Actix Client)", "rust", "rs"),
  rustHyper("Rust (Hyper)", "rust", "rs"),
  rustReqwest("Rust (reqwest)", "rust", "rs"),
  rustCurl("Rust (curl-rust)", "rust", "rs"),
  rustUreq("Rust (ureq)", "rust", "rs"),
  swiftAlamofire("Swift (Alamofire)", "swift", "swift"),
  swiftUrlSession("Swift (URLSession)", "swift", "swift");

  const CodegenLanguage(this.label, this.codeHighlightLang, this.ext);
  final String label;
  final String codeHighlightLang;
  final String ext;
}

enum ImportFormat {
  curl("cURL"),
  postman("Postman Collection v2.1"),
  insomnia("Insomnia v4");

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
const kLabelShare = "Share";
const kLabelSave = "Save";
const kLabelDownload = "Download";
const kLabelSaving = "Saving";
const kLabelSaved = "Saved";
const kLabelCode = "Code";
const kLabelDuplicate = "Duplicate";
const kLabelSelect = "Select";
const kLabelContinue = "Continue";
const kLabelCancel = "Cancel";
const kLabelOk = "Ok";
const kLabelImport = "Import";
const kUntitled = "untitled";
// Request Pane
const kLabelRequest = "Request";
const kLabelHideCode = "Hide Code";
const kLabelViewCode = "View Code";
const kLabelURLParams = "URL Params";
const kLabelHeaders = "Headers";
const kLabelBody = "Body";
const kLabelScripts = "Scripts";
const kLabelQuery = "Query";
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
const kHintContent = "Enter content";
const kHintText = "Enter text";
const kHintJson = "Enter JSON";
const kHintQuery = "Enter Query";
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
// History Page
const kTitleClearHistory = 'Clear History';
const kMsgClearHistory =
    'Clearing History is permanent. Do you want to continue?';
const kMsgClearHistorySuccess = 'History cleared successfully';
const kMsgClearHistoryError = 'Error clearing history';
const kMsgShareError = "Unable to share";


const String setupScript = r"""
// === APIDash Setup Script ===

// --- 1. Parse Injected Data ---
// These variables are expected to be populated by Dart before this script runs.
// Example: const injectedRequestJson = '{"method":"get", "url":"...", ...}';

let request = {}; // Will hold the RequestModel data
let response = {}; // Will hold the ResponseModel data (only for post-request)
let environment = {}; // Will hold the active environment variables

// Note: Using 'let' because environment might be completely cleared/reassigned.

try {
  // 'injectedRequestJson' should always be provided (even if empty for some edge case)
  if (typeof injectedRequestJson !== 'undefined' && injectedRequestJson) {
    request = JSON.parse(injectedRequestJson);
    // Ensure essential arrays exist if they are null/undefined after parsing
    request.headers = request.headers || [];
    request.params = request.params || [];
    request.formData = request.formData || [];
  } else {
     // Should not happen based on the plan, but good to log
     sendMessage('consoleError', JSON.stringify(['Setup Error: injectedRequestJson is missing or empty.']));
  }

  // 'injectedResponseJson' is only for post-response scripts
  if (typeof injectedResponseJson !== 'undefined' && injectedResponseJson) {
    response = JSON.parse(injectedResponseJson);
    // Ensure response headers map exists
    response.headers = response.headers || {};
    response.requestHeaders = response.requestHeaders || {};
  }

  // 'injectedEnvironmentJson' should always be provided
  if (typeof injectedEnvironmentJson !== 'undefined' && injectedEnvironmentJson) {
    environment = JSON.parse(injectedEnvironmentJson);
  } else {
     // Should not happen based on the plan, but good to log
     sendMessage('consoleError', JSON.stringify(['Setup Error: injectedEnvironmentJson is missing or empty.']));
     environment = {}; // Initialize to empty object to avoid errors later
  }

} catch (e) {
  // Send error back to Dart if parsing fails catastrophically
  sendMessage('fatalError', JSON.stringify({
      message: 'Failed to parse injected JSON data.',
      error: e.toString(),
      stack: e.stack
  }));
  // Optionally, re-throw to halt script execution immediately
  // throw new Error('Failed to parse injected JSON data: ' + e.toString());
}


// --- 2. Define APIDash Helper (`ad`) Object ---
// This object provides functions to interact with the request, response,
// environment, and the Dart host application.

const ad = {
  /**
   * Functions to modify the request object *before* it is sent.
   * Only available in pre-request scripts.
   * Changes are made directly to the 'request' JS object.
   */
  request: {
    /**
     * Access and modify request headers. Remember header names are case-insensitive in HTTP,
     * but comparisons here might be case-sensitive unless handled carefully.
     * Headers are represented as an array of objects: [{name: string, value: string}, ...]
     */
    headers: {
      /**
       * Adds or updates a header. If a header with the same name (case-sensitive)
       * already exists, it updates its value. Otherwise, adds a new header.
       * @param {string} key The header name.
       * @param {string} value The header value.
       */
      set: (key, value) => {
        if (!request || typeof request !== 'object' || !Array.isArray(request.headers)) return; // Safety check
        if (typeof key !== 'string') return; // Safety check
        const stringValue = String(value); // Ensure value is a string
        const existingHeaderIndex = request.headers.findIndex(h => typeof h === 'object' && h.name === key);
        if (existingHeaderIndex > -1) {
          request.headers[existingHeaderIndex].value = stringValue;
        } else {
          request.headers.push({ name: key, value: stringValue });
        }
      },
       /**
       * Gets the value of the first header matching the key (case-sensitive).
       * @param {string} key The header name.
       * @returns {string|undefined} The header value or undefined if not found.
       */
      get: (key) => {
        if (!request || typeof request !== 'object' || !Array.isArray(request.headers)) return undefined; // Safety check
        const header = request.headers.find(h => typeof h === 'object' && h.name === key);
        return header ? header.value : undefined;
      },
      /**
       * Removes all headers with the given name (case-sensitive).
       * @param {string} key The header name to remove.
       */
      remove: (key) => {
         if (!request || typeof request !== 'object' || !Array.isArray(request.headers)) return; // Safety check
         request.headers = request.headers.filter(h => !(typeof h === 'object' && h.name === key));
      },
       /**
       * Checks if a header with the given name exists (case-sensitive).
       * @param {string} key The header name.
       * @returns {boolean} True if the header exists, false otherwise.
       */
      has: (key) => {
        if (!request || typeof request !== 'object' || !Array.isArray(request.headers)) return false; // Safety check
        return request.headers.some(h => typeof h === 'object' && h.name === key);
      },
      /**
       * Clears all request headers.
       */
      clear: () => {
        if (!request || typeof request !== 'object') return; // Safety check
        request.headers = [];
      }
    },

    /**
     * Access and modify URL query parameters.
     * Params are represented as an array of objects: [{name: string, value: string}, ...]
     */
    params: {
       /**
       * Adds or updates a query parameter. If a param with the same name (case-sensitive)
       * already exists, it updates its value. Use multiple times for duplicate keys if needed by server.
       * Consider URL encoding implications - values should likely be pre-encoded if necessary.
       * @param {string} key The parameter name.
       * @param {string} value The parameter value.
       */
       set: (key, value) => {
        if (!request || typeof request !== 'object' || !Array.isArray(request.params)) return; // Safety check
        if (typeof key !== 'string') return; // Safety check
        const stringValue = String(value); // Ensure value is a string
         // Note: Unlike headers, duplicate param keys are sometimes meaningful.
         // This simple 'set' replaces the *first* occurrence or adds if not found.
         // A different method like 'add' could be used to allow duplicates.
        const existingParamIndex = request.params.findIndex(p => typeof p === 'object' && p.name === key);
        if (existingParamIndex > -1) {
          request.params[existingParamIndex].value = stringValue;
        } else {
          request.params.push({ name: key, value: stringValue });
        }
      },
       /**
       * Gets the value of the first query parameter matching the key (case-sensitive).
       * @param {string} key The parameter name.
       * @returns {string|undefined} The parameter value or undefined if not found.
       */
      get: (key) => {
         if (!request || typeof request !== 'object' || !Array.isArray(request.params)) return undefined; // Safety check
         const param = request.params.find(p => typeof p === 'object' && p.name === key);
         return param ? param.value : undefined;
      },
       /**
       * Removes all query parameters with the given name (case-sensitive).
       * @param {string} key The parameter name to remove.
       */
      remove: (key) => {
         if (!request || typeof request !== 'object' || !Array.isArray(request.params)) return; // Safety check
         request.params = request.params.filter(p => !(typeof p === 'object' && p.name === key));
      },
       /**
       * Checks if a query parameter with the given name exists (case-sensitive).
       * @param {string} key The parameter name.
       * @returns {boolean} True if the parameter exists, false otherwise.
       */
      has: (key) => {
        if (!request || typeof request !== 'object' || !Array.isArray(request.params)) return false; // Safety check
        return request.params.some(p => typeof p === 'object' && p.name === key);
      },
       /**
       * Clears all query parameters.
       */
      clear: () => {
        if (!request || typeof request !== 'object') return; // Safety check
        request.params = [];
      }
    },

    /**
     * Access or modify the request URL.
     */
    url: {
        /**
         * Gets the current request URL string.
         * @returns {string} The URL.
         */
        get: () => {
            return (request && typeof request === 'object') ? request.url : '';
        },
        /**
         * Sets the request URL string.
         * @param {string} newUrl The new URL.
         */
        set: (newUrl) => {
            if (request && typeof request === 'object' && typeof newUrl === 'string') {
                request.url = newUrl;
            }
        }
        // Future: Could add methods to manipulate parts (host, path, query) if needed
    },

    /**
     * Access or modify the request body.
     */
    body: {
        /**
         * Gets the current request body content (string).
         * Note: For form-data, this returns the raw string body (if any), not the structured data. Use `ad.request.formData` for that.
         * @returns {string|null|undefined} The request body string.
         */
        get: () => {
            return (request && typeof request === 'object') ? request.body : undefined;
        },
        /**
         * Sets the request body content (string).
         * Important: Also updates the Content-Type if setting JSON/Text, unless a Content-Type header is already explicitly set.
         * Setting the body will clear form-data if the content type changes away from form-data.
         * @param {string|object} newBody The new body content. If an object is provided, it's stringified as JSON.
         * @param {string} [contentType] Optionally specify the Content-Type (e.g., 'application/json', 'text/plain'). If not set, defaults to 'text/plain' or 'application/json' if newBody is an object.
         */
        set: (newBody, contentType) => {
            if (!request || typeof request === 'object') return; // Safety check

            let finalBody = '';
            let finalContentType = contentType;

            if (typeof newBody === 'object' && newBody !== null) {
                try {
                    finalBody = JSON.stringify(newBody);
                    finalContentType = contentType || 'application/json'; // Default to JSON if object
                    request.bodyContentType = 'json'; // Update internal model type
                } catch (e) {
                     sendMessage('consoleError', JSON.stringify(['Error stringifying object for request body:', e.toString()]));
                     return; // Don't proceed if stringify fails
                }
            } else {
                finalBody = String(newBody); // Ensure it's a string
                finalContentType = contentType || 'text/plain'; // Default to text
                 request.bodyContentType = 'text'; // Update internal model type
            }

            request.body = finalBody;

            // Clear form data if we are setting a string/json body
            request.formData = [];

            // Set Content-Type header if not already set by user explicitly in headers
            // Use case-insensitive check for existing Content-Type
            const hasContentTypeHeader = request.headers.some(h => typeof h === 'object' && h.name.toLowerCase() === 'content-type');
            if (!hasContentTypeHeader && finalContentType) {
                ad.request.headers.set('Content-Type', finalContentType);
            }
        }
        // TODO: Add helpers for request.formData if needed (similar to headers/params)
    },

     /**
     * Access or modify the request method (e.g., 'GET', 'POST').
     */
    method: {
         /**
         * Gets the current request method.
         * @returns {string} The HTTP method (e.g., "get", "post").
         */
        get: () => {
             return (request && typeof request === 'object') ? request.method : '';
        },
        /**
         * Sets the request method.
         * @param {string} newMethod The new HTTP method (e.g., "POST", "put"). Case might matter for the Dart model enum.
         */
        set: (newMethod) => {
            if (request && typeof request === 'object' && typeof newMethod === 'string') {
                 // Consider converting to lowercase to match HTTPVerb enum likely usage
                 request.method = newMethod.toLowerCase();
            }
        }
    }
  },

  /**
   * Read-only access to the response data.
   * Only available in post-response scripts.
   */
  response: {
    /**
     * The HTTP status code of the response.
     * @type {number|undefined}
     */
    get status() { return (response && typeof response === 'object') ? response.statusCode : undefined; },

    /**
     * The response body as a string. If the response was binary, this might be decoded text
     * based on Content-Type or potentially garbled. Use `bodyBytes` for raw binary data access (if provided).
     * @type {string|undefined}
     */
    get body() { return (response && typeof response === 'object') ? response.body : undefined; },

     /**
     * The response body automatically formatted (e.g., pretty-printed JSON). Provided by Dart.
     * @type {string|undefined}
     */
    get formattedBody() { return (response && typeof response === 'object') ? response.formattedBody : undefined; },

    /**
     * The raw response body as an array of bytes (numbers).
     * Note: This relies on the Dart side serializing Uint8List correctly (e.g., as List<int>).
     * Accessing large byte arrays in JS might be memory-intensive.
     * @type {number[]|undefined}
     */
     get bodyBytes() { return (response && typeof response === 'object') ? response.bodyBytes : undefined; },


    /**
     * The approximate time taken for the request-response cycle. Provided by Dart.
     * Assumes Dart sends it as microseconds and converts it to milliseconds here.
     * @type {number|undefined} Time in milliseconds.
     */
     get time() {
        // Assuming response.time is in microseconds from Dart's DurationConverter
        return (response && typeof response === 'object' && typeof response.time === 'number') ? response.time / 1000 : undefined;
     },

    /**
     * An object containing the response headers (keys are header names, values are header values).
     * Header names are likely lowercase from the http package.
     * @type {object|undefined} e.g., {'content-type': 'application/json', ...}
     */
    get headers() { return (response && typeof response === 'object') ? response.headers : undefined; },

    /**
     * An object containing the request headers that were actually sent (useful for verification).
     * Header names are likely lowercase.
     * @type {object|undefined} e.g., {'user-agent': '...', ...}
     */
    get requestHeaders() { return (response && typeof response === 'object') ? response.requestHeaders : undefined; },


    /**
     * Attempts to parse the response body as JSON.
     * @returns {object|undefined} The parsed JSON object, or undefined if parsing fails or body is empty.
     */
    json: () => {
      if (!ad.response.body) {
        return undefined;
      }
      try {
        return JSON.parse(ad.response.body);
      } catch (e) {
        ad.console.error("Failed to parse response body as JSON:", e.toString());
        return undefined;
      }
    },

    /**
     * Gets a specific response header value (case-insensitive key lookup).
     * @param {string} key The header name.
     * @returns {string|undefined} The header value or undefined if not found.
     */
    getHeader: (key) => {
        const headers = ad.response.headers;
        if (!headers || typeof key !== 'string') return undefined;
        const lowerKey = key.toLowerCase();
        const headerKey = Object.keys(headers).find(k => k.toLowerCase() === lowerKey);
        return headerKey ? headers[headerKey] : undefined;
    }
  },

  /**
   * Access and modify environment variables for the active environment.
   * Changes are made to the 'environment' JS object and sent back to Dart.
   */
  environment: {
    /**
     * Gets the value of an environment variable.
     * @param {string} key The variable name.
     * @returns {any} The variable value or undefined if not found.
     */
    get: (key) => {
      return (environment && typeof environment === 'object') ? environment[key] : undefined;
    },
    /**
     * Sets the value of an environment variable.
     * @param {string} key The variable name.
     * @param {any} value The variable value. Should be JSON-serializable (string, number, boolean, object, array).
     */
    set: (key, value) => {
      if (environment && typeof environment === 'object' && typeof key === 'string') {
        environment[key] = value;
      }
    },
    /**
     * Removes an environment variable.
     * @param {string} key The variable name to remove.
     */
    unset: (key) => {
      if (environment && typeof environment === 'object') {
        delete environment[key];
      }
    },
    /**
     * Checks if an environment variable exists.
     * @param {string} key The variable name.
     * @returns {boolean} True if the variable exists, false otherwise.
     */
    has: (key) => {
       return (environment && typeof environment === 'object') ? environment.hasOwnProperty(key) : false;
    },
    /**
     * Removes all variables from the current environment scope.
     */
    clear: () => {
      if (environment && typeof environment === 'object') {
          for (const key in environment) {
              if (environment.hasOwnProperty(key)) {
                  delete environment[key];
              }
          }
      }
    }
    // Note: A separate 'globals' object could be added here if global variables are implemented distinctly.
  },

  /**
   * Provides logging capabilities. Messages are sent back to Dart via the bridge.
   */
  console: {
    /**
     * Logs informational messages.
     * @param {...any} args Values to log. They will be JSON-stringified.
     */
    log: (...args) => {
      try {
        sendMessage('consoleLog', JSON.stringify(args));
      } catch(e) { /* Ignore stringify errors for console? Or maybe log the error itself? */ }
    },
    /**
     * Logs warning messages.
     * @param {...any} args Values to log.
     */
    warn: (...args) => {
       try {
         sendMessage('consoleWarn', JSON.stringify(args));
       } catch(e) { /* Ignore */ }
    },
    /**
     * Logs error messages.
     * @param {...any} args Values to log.
     */
    error: (...args) => {
      try {
        sendMessage('consoleError', JSON.stringify(args));
      } catch(e) { /* Ignore */ }
    }
  },

  /**
   * Basic testing functions (example structure).
   * Results might need to be collected and sent back via the bridge or at the end.
   */
  // test: (testName, callback) => {
  //   try {
  //     callback();
  //     ad.console.log(`Test Passed: ${testName}`);
  //     // TODO: Potentially collect results: sendMessage('testResult', JSON.stringify({ name: testName, status: 'passed' }));
  //   } catch (e) {
  //     ad.console.error(`Test Failed: ${testName}`, e.toString(), e.stack);
  //      // TODO: Potentially collect results: sendMessage('testResult', JSON.stringify({ name: testName, status: 'failed', error: e.toString() }));
  //   }
  // },

  // expect: (value) => {
  //   // Very basic assertion example (can be expanded or use a tiny library)
  //   return {
  //     toBe: (expected) => {
  //       if (value !== expected) {
  //         throw new Error(`Assertion Failed: Expected ${JSON.stringify(value)} to be ${JSON.stringify(expected)}`);
  //       }
  //     },
       // Add more assertions: toBeTruthy, toEqual (deep compare), etc.
  //   };
  // }

  // TODO: Add other utilities if needed: crypto, base64 (atob/btoa - might need polyfills)
  // E.g.,
  // crypto: { /* methods */ },
  // btoa: (str) => btoa(str), // Needs btoa to be available in the JS context
  // atob: (encodedStr) => atob(encodedStr) // Needs atob

};

// --- End of APIDash Setup Script ---

// User's script will be appended below this line by Dart.
// Dart will also append the final JSON.stringify() call to return results.
""";