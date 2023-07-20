import 'package:apidash/models/models.dart' show KVRow, RequestModel;
import 'package:apidash/consts.dart';

/// Basic GET request model
const requestModelGet1 = RequestModel(
  url: 'https://api.foss42.com',
  method: HTTPVerb.get,
  id: '',
);

/// GET request model with headers and query params
const requestModelGet2 = RequestModel(
  url: 'https://jsonplaceholder.typicode.com/posts',
  method: HTTPVerb.get,
  requestParams: [
    KVRow('userId', 1),
  ],
  requestHeaders: [
    KVRow('Custom-Header-1', 'Value-1'),
    KVRow('Custom-Header-2', 'Value-2')
  ],
  id: '1',
);

/// Basic HEAD request model
const requestModelHead1 = RequestModel(
  url: 'https://jsonplaceholder.typicode.com/posts/1',
  method: HTTPVerb.head,
  id: '1',
);

/// Basic POST request model
const requestModelPost1 = RequestModel(
  url: 'https://api.foss42.com/case/lower',
  method: HTTPVerb.post,
  requestBody: '{"text": "IS Upper"}',
  requestBodyContentType: ContentType.json,
  id: '1',
);

/// Basic DELETE request model
const requestModelDelete1 = RequestModel(
  url: 'https://jsonplaceholder.typicode.com/posts/1',
  method: HTTPVerb.delete,
  requestBody: '{"title": "foo","body": "bar","userId": 1}',
  requestBodyContentType: ContentType.json,
  id: '1',
);
