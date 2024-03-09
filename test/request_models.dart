import 'package:apidash/models/models.dart'
    show FormDataModel, NameValueModel, RequestModel;
import 'package:apidash/consts.dart';

/// Basic GET request model
const requestModelGet1 = RequestModel(
  id: 'get1',
  url: 'https://api.apidash.dev',
  method: HTTPVerb.get,
);

/// GET request model with query params
const requestModelGet2 = RequestModel(
  id: 'get2',
  url: 'https://api.apidash.dev/country/data',
  method: HTTPVerb.get,
  requestParams: [
    NameValueModel(name: 'code', value: 'US'),
  ],
);

/// GET request model with override query params
const requestModelGet3 = RequestModel(
  id: 'get3',
  url: 'https://api.apidash.dev/country/data?code=US',
  method: HTTPVerb.get,
  requestParams: [
    NameValueModel(name: 'code', value: 'IND'),
  ],
);

/// GET request model with different types of query params
const requestModelGet4 = RequestModel(
  id: 'get4',
  url: 'https://api.apidash.dev/humanize/social',
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
  url: 'https://api.apidash.dev',
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
  id: 'get9',
  url: 'https://api.apidash.dev/humanize/social',
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
  id: 'get10',
  url: 'https://api.apidash.dev/humanize/social',
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
  id: 'get11',
  url: 'https://api.apidash.dev/humanize/social',
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
  id: 'get12',
  url: 'https://api.apidash.dev/humanize/social',
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
  url: 'https://api.apidash.dev',
  method: HTTPVerb.head,
);

/// Without URI Scheme (pass default as http)
const requestModelHead2 = RequestModel(
  id: 'head2',
  url: 'api.apidash.dev',
  method: HTTPVerb.head,
);

/// Basic POST request model (txt body)
const requestModelPost1 = RequestModel(
    id: 'post1',
    url: 'https://api.apidash.dev/case/lower',
    method: HTTPVerb.post,
    requestBody: r"""{
"text": "I LOVE Flutter"
}""",
    requestBodyContentType: ContentType.text);

/// POST request model with JSON body
const requestModelPost2 = RequestModel(
  id: 'post2',
  url: 'https://api.apidash.dev/case/lower',
  method: HTTPVerb.post,
  requestBody: r"""{
"text": "I LOVE Flutter"
}""",
);

/// POST request model with headers
const requestModelPost3 = RequestModel(
  id: 'post3',
  url: 'https://api.apidash.dev/case/lower',
  method: HTTPVerb.post,
  requestBody: r"""{
"text": "I LOVE Flutter"
}""",
  requestBodyContentType: ContentType.json,
  requestHeaders: [
    NameValueModel(name: 'User-Agent', value: 'Test Agent'),
  ],
);

/// POST request model with multipart body(text)
const requestModelPost4 = RequestModel(
  id: 'post4',
  url: 'https://api.apidash.dev/io/form',
  method: HTTPVerb.post,
  requestFormDataList: [
    FormDataModel(name: "text", value: "API", type: FormDataType.text),
    FormDataModel(name: "sep", value: "|", type: FormDataType.text),
    FormDataModel(name: "times", value: "3", type: FormDataType.text),
  ],
  requestBodyContentType: ContentType.formdata,
);

/// POST request model with multipart body and headers
const requestModelPost5 = RequestModel(
  id: 'post5',
  url: 'https://api.apidash.dev/io/form',
  method: HTTPVerb.post,
  requestFormDataList: [
    FormDataModel(name: "text", value: "API", type: FormDataType.text),
    FormDataModel(name: "sep", value: "|", type: FormDataType.text),
    FormDataModel(name: "times", value: "3", type: FormDataType.text),
  ],
  requestHeaders: [
    NameValueModel(name: 'User-Agent', value: 'Test Agent'),
  ],
  requestBodyContentType: ContentType.formdata,
);

/// POST request model with multipart body(text, file)
const requestModelPost6 = RequestModel(
  id: 'post6',
  url: 'https://api.apidash.dev/io/img',
  method: HTTPVerb.post,
  requestFormDataList: [
    FormDataModel(name: "token", value: "xyz", type: FormDataType.text),
    FormDataModel(
        name: "imfile", value: "/Documents/up/1.png", type: FormDataType.file),
  ],
  requestBodyContentType: ContentType.formdata,
);

/// POST request model with multipart body and requestBody (the requestBody shouldn't be in codegen)
const requestModelPost7 = RequestModel(
  id: 'post7',
  url: 'https://api.apidash.dev/io/img',
  method: HTTPVerb.post,
  requestBody: r"""{
"text": "I LOVE Flutter"
}""",
  requestFormDataList: [
    FormDataModel(name: "token", value: "xyz", type: FormDataType.text),
    FormDataModel(
        name: "imfile", value: "/Documents/up/1.png", type: FormDataType.file),
  ],
  requestBodyContentType: ContentType.formdata,
);

/// POST request model with multipart body and requestParams
const requestModelPost8 = RequestModel(
  id: 'post8',
  url: 'https://api.apidash.dev/io/form',
  method: HTTPVerb.post,
  requestFormDataList: [
    FormDataModel(name: "text", value: "API", type: FormDataType.text),
    FormDataModel(name: "sep", value: "|", type: FormDataType.text),
    FormDataModel(name: "times", value: "3", type: FormDataType.text),
  ],
  requestParams: [
    NameValueModel(name: 'size', value: '2'),
    NameValueModel(name: 'len', value: '3'),
  ],
  requestBodyContentType: ContentType.formdata,
);

/// POST request model with multipart body(file and text), requestParams, requestHeaders and requestBody
const requestModelPost9 = RequestModel(
  id: 'post9',
  url: 'https://api.apidash.dev/io/img',
  method: HTTPVerb.post,
  requestBody: r"""{
"text": "I LOVE Flutter"
}""",
  requestFormDataList: [
    FormDataModel(name: "token", value: "xyz", type: FormDataType.text),
    FormDataModel(
        name: "imfile", value: "/Documents/up/1.png", type: FormDataType.file),
  ],
  requestParams: [
    NameValueModel(name: 'size', value: '2'),
    NameValueModel(name: 'len', value: '3'),
  ],
  requestHeaders: [
    NameValueModel(name: 'User-Agent', value: 'Test Agent'),
    NameValueModel(name: 'Keep-Alive', value: 'true'),
  ],
  requestBodyContentType: ContentType.formdata,
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
