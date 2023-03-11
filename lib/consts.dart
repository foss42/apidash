import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final colorTransparent = MaterialStateProperty.all<Color>(Colors.transparent);
const colorBg = Colors.white;
final colorGrey50 = Colors.grey.shade50;
final colorGrey100 = Colors.grey.shade100;
final colorGrey200 = Colors.grey.shade200;
final colorGrey300 = Colors.grey.shade300;
final colorGrey400 = Colors.grey.shade400;
final colorGrey500 = Colors.grey.shade500;
final colorErrorMsg = colorGrey500;

final codeStyle = GoogleFonts.sourceCodePro();
final codeHintStyle = codeStyle.copyWith(color: colorGrey500);

const textStyleButton = TextStyle(fontWeight: FontWeight.bold);

final borderRadius10 = BorderRadius.circular(10);
const border12 = BorderRadius.all(Radius.circular(12));

const tableContainerDecoration = BoxDecoration(
  color: colorBg,
  borderRadius: border12,
);

const p1 = EdgeInsets.all(1);
const p5 = EdgeInsets.all(5);
const p8 = EdgeInsets.all(8);
const ps8 = EdgeInsets.only(left: 8);
const p10 = EdgeInsets.all(10);

const hspacer5 = SizedBox(width: 5);
const hspacer10 = SizedBox(width: 10);
const hspacer20 = SizedBox(width: 20);
const vspacer5 = SizedBox(height: 5);
const vspacer8 = SizedBox(height: 8);
const vspacer10 = SizedBox(height: 10);

const tabAnimationDuration = Duration(milliseconds: 200);
const kTabHeight = 45.0;

const randRange = 100000;

enum HTTPVerb { get, head, post, put, patch, delete }

enum ContentType { json, text }

const DEFAULT_METHOD = HTTPVerb.get;
const DEFAULT_BODY_CONTENT_TYPE = ContentType.json;
const JSON_MIMETYPE = 'application/json';

const sendingIndicator = AssetImage("assets/sending.gif");

const RESPONSE_CODE_REASONS = {
  // 100s
  100: 'Continue',
  101: 'Switching Protocols',
  // 200s
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
  // 300s
  300: 'Multiple Choices',
  301: 'Moved Permanently',
  302: 'Found',
  303: 'See Other',
  304: 'Not Modified',
  305: 'Use Proxy',
  306: 'Switch Proxy',
  307: 'Temporary Redirect',
  308: 'Permanent Redirect',
  // 400s
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
  // 500s
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
