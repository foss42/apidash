import 'package:apidash/models/models.dart' show KVRow, RequestModel;
import 'package:apidash/consts.dart';

/// Basic GET request model
const requestModelGet1 = RequestModel(
  id: 'get1',
  url: 'https://api.foss42.com',
  method: HTTPVerb.get,
);

/// GET request model with query params
const requestModelGet2 = RequestModel(
  id: 'get2',
  url: 'https://api.foss42.com/country/data',
  method: HTTPVerb.get,
  requestParams: [
    KVRow('code', 'US'),
  ],
);

/// GET request model with override query params
const requestModelGet3 = RequestModel(
  id: 'get3',
  url: 'https://api.foss42.com/country/data?code=US',
  method: HTTPVerb.get,
  requestParams: [
    KVRow('code', 'IND'),
  ],
);

/// GET request model with different types of query params
const requestModelGet4 = RequestModel(
  id: 'get4',
  url: 'https://api.foss42.com/humanize/social',
  method: HTTPVerb.get,
  requestParams: [
    KVRow('num', '8700000'),
    KVRow('digits', '3'),
    KVRow('system', 'SS'),
    KVRow('add_space', 'true'),
    KVRow('trailing_zeros', 'true'),
  ],
);

/// GET request model with headers
const requestModelGet5 = RequestModel(
  id: 'get5',
  url: 'https://api.github.com/repos/foss42/api-dash',
  method: HTTPVerb.get,
  requestHeaders: [
    KVRow('Authorization', 'Bearer XYZ'),
  ],
);

/// GET request model with headers & query params
const requestModelGet6 = RequestModel(
  id: 'get6',
  url: 'https://api.foss42.com/humanize/social',
  method: HTTPVerb.get,
  requestHeaders: [
    KVRow('Authorization', 'Bearer XYZ'),
  ],
  requestParams: [
    KVRow('raw', 'true'),
  ],
);

/// GET request model with body
const requestModelGet7 = RequestModel(
  id: 'get7',
  url: 'https://api.foss42.com/humanize/social',
  method: HTTPVerb.get,
  requestBodyContentType: ContentType.text,
  requestBody:
      'This is a random text which should not be attached with a GET request',
);

/// Basic HEAD request model
const requestModelHead1 = RequestModel(
  id: 'head1',
  url: 'https://api.foss42.com',
  method: HTTPVerb.head,
);

/// Without URI Scheme (pass default as http)
const requestModelHead2 = RequestModel(
  id: 'head2',
  url: 'api.foss42.com',
  method: HTTPVerb.head,
);

/// Basic POST request model
const requestModelPost1 = RequestModel(
  id: 'post1',
  url: 'https://api.foss42.com/case/lower',
  method: HTTPVerb.post,
  requestBody: r"""{
"text": "I LOVE Flutter"
}""",
);

/// POST request model with txt body
const requestModelPost2 = RequestModel(
  id: 'post1',
  url: 'https://api.foss42.com/case/lower',
  method: HTTPVerb.post,
  requestBody: r"""{
"text": "I LOVE Flutter"
}""",
  requestBodyContentType: ContentType.json,
);

/// POST request model with headers

/// PUT request model

/// PATCH request model

/// Basic DELETE request model
const requestModelDelete1 = RequestModel(
  id: 'delete1',
  url: 'https://jsonplaceholder.typicode.com/posts/1',
  method: HTTPVerb.delete,
  requestBody: '{"title": "foo","body": "bar","userId": 1}',
  requestBodyContentType: ContentType.json,
);
