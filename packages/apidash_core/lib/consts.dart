import 'dart:convert';

enum HTTPVerb { get, head, post, put, patch, delete }

enum FormDataType { text, file }

enum SupportedUriSchemes { https, http }

final kSupportedUriSchemes =
    SupportedUriSchemes.values.map((i) => i.name).toList();
const kDefaultUriScheme = "https";
final kLocalhostRegex = RegExp(r'^localhost(:\d+)?(/.*)?$');

const kMethodsWithBody = [
  HTTPVerb.post,
  HTTPVerb.put,
  HTTPVerb.patch,
  HTTPVerb.delete,
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

const JsonEncoder kJsonEncoder = JsonEncoder.withIndent('  ');
const JsonDecoder kJsonDecoder = JsonDecoder();
const LineSplitter kSplitter = LineSplitter();

const kCodeCharsPerLineLimit = 200;

const kHeaderContentType = "Content-Type";
