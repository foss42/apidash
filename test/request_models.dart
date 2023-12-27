import 'package:apidash/models/models.dart' show NameValueModel, RequestModel;
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
    NameValueModel(name: 'code', value: 'US'),
  ],
);

/// GET request model with override query params
const requestModelGet3 = RequestModel(
  id: 'get3',
  url: 'https://api.foss42.com/country/data?code=US',
  method: HTTPVerb.get,
  requestParams: [
    NameValueModel(name: 'code', value: 'IND'),
  ],
);

/// GET request model with different types of query params
const requestModelGet4 = RequestModel(
  id: 'get4',
  url: 'https://api.foss42.com/humanize/social',
  method: HTTPVerb.get,
  requestParams: [
    NameValueModel(name: 'num', value: '8700000'),
    NameValueModel(name: 'digits', value: '3'),
    NameValueModel(name: 'system', value: 'SS'),
    NameValueModel(name: 'add_space', value: 'true'),
    NameValueModel(name: 'trailing_zeros', value: 'true'),
  ],
);

/// GET request model with headers
const requestModelGet5 = RequestModel(
  id: 'get5',
  url: 'https://api.github.com/repos/foss42/apidash',
  method: HTTPVerb.get,
  requestHeaders: [
    NameValueModel(name: 'User-Agent', value: 'Test Agent'),
  ],
);

/// GET request model with headers & query params
const requestModelGet6 = RequestModel(
  id: 'get6',
  url: 'https://api.github.com/repos/foss42/apidash',
  method: HTTPVerb.get,
  requestHeaders: [
    NameValueModel(name: 'User-Agent', value: 'Test Agent'),
  ],
  requestParams: [
    NameValueModel(name: 'raw', value: 'true'),
  ],
);

/// GET request model with body
const requestModelGet7 = RequestModel(
  id: 'get7',
  url: 'https://api.foss42.com',
  method: HTTPVerb.get,
  requestBodyContentType: ContentType.text,
  requestBody:
      'This is a random text which should not be attached with a GET request',
);

/// GET request model with empty header & query param name
const requestModelGet8 = RequestModel(
  id: 'get8',
  url: 'https://api.github.com/repos/foss42/apidash',
  method: HTTPVerb.get,
  requestHeaders: [
    NameValueModel(name: 'User-Agent', value: 'Test Agent'),
    NameValueModel(name: '', value: 'Bearer XYZ'),
  ],
  requestParams: [
    NameValueModel(name: 'raw', value: 'true'),
    NameValueModel(name: '', value: 'true'),
  ],
);

/// GET request model with some params enabled
const requestModelGet9 = RequestModel(
  id: 'enabledParams',
  url: 'https://api.foss42.com/humanize/social',
  method: HTTPVerb.get,
  requestParams: [
    NameValueModel(name: 'num', value: '8700000'),
    NameValueModel(name: 'digits', value: '3'),
    NameValueModel(name: 'system', value: 'SS'),
    NameValueModel(name: 'add_space', value: 'true'),
  ],
  isParamEnabledList: [
    true,
    false,
    false,
    true,
  ],
);

/// GET Request model with some headers enabled
const requestModelGet10 = RequestModel(
  id: 'enabledParams',
  url: 'https://api.foss42.com/humanize/social',
  method: HTTPVerb.get,
  requestHeaders: [
    NameValueModel(name: 'User-Agent', value: 'Test Agent'),
    NameValueModel(name: 'Content-Type', value: 'application/json'),
  ],
  isHeaderEnabledList: [
    true,
    false,
  ],
);

/// GET Request model with some headers & URL parameters enabled
const requestModelGet11 = RequestModel(
  id: 'enabledRows',
  url: 'https://api.foss42.com/humanize/social',
  method: HTTPVerb.get,
  requestParams: [
    NameValueModel(name: 'num', value: '8700000'),
    NameValueModel(name: 'digits', value: '3'),
    NameValueModel(name: 'system', value: 'SS'),
    NameValueModel(name: 'add_space', value: 'true'),
  ],
  requestHeaders: [
    NameValueModel(name: 'User-Agent', value: 'Test Agent'),
    NameValueModel(name: 'Content-Type', value: 'application/json'),
  ],
  isParamEnabledList: [
    true,
    true,
    false,
    false,
  ],
  isHeaderEnabledList: [
    true,
    false,
  ],
);

/// Request model with all headers & URL parameters disabled
const requestModelGet12 = RequestModel(
  id: 'disabledRows',
  url: 'https://api.foss42.com/humanize/social',
  method: HTTPVerb.get,
  requestParams: [
    NameValueModel(name: 'num', value: '8700000'),
    NameValueModel(name: 'digits', value: '3'),
    NameValueModel(name: 'system', value: 'SS'),
    NameValueModel(name: 'add_space', value: 'true'),
  ],
  requestHeaders: [
    NameValueModel(name: 'User-Agent', value: 'Test Agent'),
    NameValueModel(name: 'Content-Type', value: 'application/json'),
  ],
  isParamEnabledList: [
    false,
    false,
    false,
    false,
  ],
  isHeaderEnabledList: [
    false,
    false,
  ],
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

/// Basic POST request model (txt body)
const requestModelPost1 = RequestModel(
    id: 'post1',
    url: 'https://api.foss42.com/case/lower',
    method: HTTPVerb.post,
    requestBody: r"""{
"text": "I LOVE Flutter"
}""",
    requestBodyContentType: ContentType.text);

/// POST request model with JSON body
const requestModelPost2 = RequestModel(
  id: 'post2',
  url: 'https://api.foss42.com/case/lower',
  method: HTTPVerb.post,
  requestBody: r"""{
"text": "I LOVE Flutter"
}""",
);

/// POST request model with headers
const requestModelPost3 = RequestModel(
  id: 'post3',
  url: 'https://api.foss42.com/case/lower',
  method: HTTPVerb.post,
  requestBody: r"""{
"text": "I LOVE Flutter"
}""",
  requestBodyContentType: ContentType.json,
  requestHeaders: [
    NameValueModel(name: 'User-Agent', value: 'Test Agent'),
  ],
);

/// PUT request model
const requestModelPut1 = RequestModel(
  id: 'put1',
  url: 'https://reqres.in/api/users/2',
  method: HTTPVerb.put,
  requestBody: r"""{
"name": "morpheus",
"job": "zion resident"
}""",
  requestBodyContentType: ContentType.json,
);

/// PATCH request model
const requestModelPatch1 = RequestModel(
  id: 'patch1',
  url: 'https://reqres.in/api/users/2',
  method: HTTPVerb.patch,
  requestBody: r"""{
"name": "marfeus",
"job": "accountant"
}""",
  requestBodyContentType: ContentType.json,
);

/// Basic DELETE request model
const requestModelDelete1 = RequestModel(
  id: 'delete1',
  url: 'https://reqres.in/api/users/2',
  method: HTTPVerb.delete,
);

/// Basic DELETE with body
const requestModelDelete2 = RequestModel(
  id: 'delete2',
  url: 'https://reqres.in/api/users/2',
  method: HTTPVerb.delete,
  requestBody: r"""{
"name": "marfeus",
"job": "accountant"
}""",
  requestBodyContentType: ContentType.json,
);
