import 'dart:convert';

enum APIType {
  rest("HTTP", "HTTP"),
  graphql("GraphQL", "GQL");

  const APIType(this.label, this.abbr);
  final String label;
  final String abbr;
}

enum APIAuthType {
  none("None"),
  basic("Basic Auth"),
  apiKey("API Key"),
  bearer("Bearer Token"),
  jwt("JWT Bearer"),
  digest("Digest Auth"),
  oauth1("OAuth 1.0"),
  oauth2("OAuth 2.0");

  const APIAuthType(this.displayType);
  final String displayType;
}

const kDigestAlgos = ['MD5', 'MD5-sess', 'SHA-256', 'SHA-256-sess'];
const kQop = ['auth', 'auth-int'];

const kJwtAlgos = [
  'HS256',
  'HS384',
  'HS512',
  'RS256',
  'RS384',
  'RS512',
  'PS256',
  'PS384',
  'PS512',
  'ES256',
  'ES256K',
  'ES384',
  'ES512',
  'EdDSA',
];

enum HTTPVerb {
  get("GET"),
  head("HEAD"),
  post("POST"),
  put("PUT"),
  patch("PAT"),
  delete("DEL"),
  options("OPT");

  const HTTPVerb(this.abbr);
  final String abbr;
}

enum SupportedUriSchemes { https, http }

final kSupportedUriSchemes = SupportedUriSchemes.values
    .map((i) => i.name)
    .toList();
const kDefaultUriScheme = SupportedUriSchemes.https;
final kLocalhostRegex = RegExp(r'^localhost(:\d+)?(/.*)?$');
final kIPHostRegex = RegExp(
  r'^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}(:\d+)?(/.*)?$',
);

const kMethodsWithBody = [
  HTTPVerb.post,
  HTTPVerb.put,
  HTTPVerb.patch,
  HTTPVerb.delete,
  HTTPVerb.options,
];

const kDefaultHttpMethod = HTTPVerb.get;
const kDefaultContentType = ContentType.json;

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
const kSubTypeXWwwFormUrlencoded = 'x-www-form-urlencoded';
const kSubTypeXNdjson = 'x-ndjson';
const kSubTypeNdjson = 'ndjson';
const kSubTypeJsonSeq = 'json-seq';
const kSubTypeXLdjson = 'x-ldjson';
const kSubTypeLdjson = 'ldjson';
const kSubTypeXJsonStream = 'x-json-stream';
const kSubTypeJsonStream = 'json-stream';
const kSubTypeJsonstream = 'jsonstream';
const kSubTypeStreamJson = 'stream+json';

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
const kSubTypeEventStream = 'event-stream';

const kTypeImage = 'image';
//image
const kSubTypeSvg = 'svg+xml';

const kTypeAudio = 'audio';
const kTypeVideo = 'video';

const kTypeMultipart = "multipart";
const kSubTypeFormData = "form-data";

const kSubTypeDefaultViewOptions = 'all';

List<String> kStreamingResponseTypes = [
  '$kTypeText/$kSubTypeEventStream',
  '$kTypeApplication/$kSubTypeXNdjson',
  '$kTypeApplication/$kSubTypeNdjson',
  '$kTypeApplication/$kSubTypeJsonSeq',
  '$kTypeApplication/$kSubTypeXLdjson',
  '$kTypeApplication/$kSubTypeLdjson',
  '$kTypeApplication/$kSubTypeXJsonStream',
  '$kTypeApplication/$kSubTypeJsonStream',
  '$kTypeApplication/$kSubTypeJsonstream',
  '$kTypeApplication/$kSubTypeStreamJson',
];

enum ContentType {
  json("$kTypeApplication/$kSubTypeJson"),
  text("$kTypeText/$kSubTypePlain"),
  formdata("$kTypeMultipart/$kSubTypeFormData");

  const ContentType(this.header);
  final String header;
}

const JsonEncoder kJsonEncoder = JsonEncoder.withIndent('  ');
const JsonDecoder kJsonDecoder = JsonDecoder();
const LineSplitter kSplitter = LineSplitter();

const kCodeCharsPerLineLimit = 200;

const kHeaderContentType = "Content-Type";
const kHeaderWwwAuthenticate = 'www-authenticate';
const kMsgRequestCancelled = 'Request Cancelled';
