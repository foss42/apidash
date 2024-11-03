import 'package:apidash_core/apidash_core.dart';

/// Basic GET request model
const httpRequestModelGet1 = HttpRequestModel(
  method: HTTPVerb.get,
  url: 'https://api.apidash.dev',
);

/// GET request model with query params
const httpRequestModelGet2 = HttpRequestModel(
  method: HTTPVerb.get,
  url: 'https://api.apidash.dev/country/data',
  params: [
    NameValueModel(name: 'code', value: 'US'),
  ],
);

/// GET request model with override query params
const httpRequestModelGet3 = HttpRequestModel(
  url: 'https://api.apidash.dev/country/data?code=US',
  method: HTTPVerb.get,
  params: [
    NameValueModel(name: 'code', value: 'IND'),
  ],
);

/// GET request model with different types of query params
const httpRequestModelGet4 = HttpRequestModel(
  method: HTTPVerb.get,
  url: 'https://api.apidash.dev/humanize/social',
  params: [
    NameValueModel(name: 'num', value: '8700000'),
    NameValueModel(name: 'digits', value: '3'),
    NameValueModel(name: 'system', value: 'SS'),
    NameValueModel(name: 'add_space', value: 'true'),
    NameValueModel(name: 'trailing_zeros', value: 'true'),
  ],
);

/// GET request model with headers
const httpRequestModelGet5 = HttpRequestModel(
  method: HTTPVerb.get,
  url: 'https://api.github.com/repos/foss42/apidash',
  headers: [
    NameValueModel(name: 'User-Agent', value: 'Test Agent'),
  ],
);

/// GET request model with headers & query params
const httpRequestModelGet6 = HttpRequestModel(
  method: HTTPVerb.get,
  url: 'https://api.github.com/repos/foss42/apidash',
  headers: [
    NameValueModel(name: 'User-Agent', value: 'Test Agent'),
  ],
  params: [
    NameValueModel(name: 'raw', value: 'true'),
  ],
);

/// GET request model with body
const httpRequestModelGet7 = HttpRequestModel(
  method: HTTPVerb.get,
  url: 'https://api.apidash.dev',
  bodyContentType: ContentType.text,
  body: 'This is a random text which should not be attached with a GET request',
);

/// GET request model with empty header & query param name
const httpRequestModelGet8 = HttpRequestModel(
  method: HTTPVerb.get,
  url: 'https://api.github.com/repos/foss42/apidash',
  headers: [
    NameValueModel(name: 'User-Agent', value: 'Test Agent'),
    NameValueModel(name: '', value: 'Bearer XYZ'),
  ],
  params: [
    NameValueModel(name: 'raw', value: 'true'),
    NameValueModel(name: '', value: 'true'),
  ],
);

/// GET request model with some params enabled
const httpRequestModelGet9 = HttpRequestModel(
  method: HTTPVerb.get,
  url: 'https://api.apidash.dev/humanize/social',
  params: [
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
const httpRequestModelGet10 = HttpRequestModel(
  method: HTTPVerb.get,
  url: 'https://api.apidash.dev/humanize/social',
  headers: [
    NameValueModel(name: 'User-Agent', value: 'Test Agent'),
    NameValueModel(name: 'Content-Type', value: 'application/json'),
  ],
  isHeaderEnabledList: [
    true,
    false,
  ],
);

/// GET Request model with some headers & URL parameters enabled
const httpRequestModelGet11 = HttpRequestModel(
  method: HTTPVerb.get,
  url: 'https://api.apidash.dev/humanize/social',
  params: [
    NameValueModel(name: 'num', value: '8700000'),
    NameValueModel(name: 'digits', value: '3'),
    NameValueModel(name: 'system', value: 'SS'),
    NameValueModel(name: 'add_space', value: 'true'),
  ],
  headers: [
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
const httpRequestModelGet12 = HttpRequestModel(
  method: HTTPVerb.get,
  url: 'https://api.apidash.dev/humanize/social',
  params: [
    NameValueModel(name: 'num', value: '8700000'),
    NameValueModel(name: 'digits', value: '3'),
    NameValueModel(name: 'system', value: 'SS'),
    NameValueModel(name: 'add_space', value: 'true'),
  ],
  headers: [
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
const httpRequestModelHead1 = HttpRequestModel(
  method: HTTPVerb.head,
  url: 'https://api.apidash.dev',
);

/// Without URI Scheme (pass default as http)
const httpRequestModelHead2 = HttpRequestModel(
  method: HTTPVerb.head,
  url: 'api.apidash.dev',
);

/// Basic POST request model (txt body)
const httpRequestModelPost1 = HttpRequestModel(
  method: HTTPVerb.post,
  url: 'https://api.apidash.dev/case/lower',
  body: r"""{
"text": "I LOVE Flutter"
}""",
  bodyContentType: ContentType.text,
);

/// POST request model with JSON body
const httpRequestModelPost2 = HttpRequestModel(
  method: HTTPVerb.post,
  url: 'https://api.apidash.dev/case/lower',
  body: r"""{
"text": "I LOVE Flutter",
"flag": null,
"male": true,
"female": false,
"no": 1.2,
"arr": ["null", "true", "false", null]
}""",
);

/// POST request model with headers
const httpRequestModelPost3 = HttpRequestModel(
  method: HTTPVerb.post,
  url: 'https://api.apidash.dev/case/lower',
  body: r"""{
"text": "I LOVE Flutter"
}""",
  bodyContentType: ContentType.json,
  headers: [
    NameValueModel(name: 'User-Agent', value: 'Test Agent'),
  ],
);

/// POST request model with multipart body(text)
const httpRequestModelPost4 = HttpRequestModel(
  method: HTTPVerb.post,
  url: 'https://api.apidash.dev/io/form',
  bodyContentType: ContentType.formdata,
  formData: [
    FormDataModel(name: "text", value: "API", type: FormDataType.text),
    FormDataModel(name: "sep", value: "|", type: FormDataType.text),
    FormDataModel(name: "times", value: "3", type: FormDataType.text),
  ],
);

/// POST request model with multipart body and headers
const httpRequestModelPost5 = HttpRequestModel(
  method: HTTPVerb.post,
  url: 'https://api.apidash.dev/io/form',
  headers: [
    NameValueModel(name: 'User-Agent', value: 'Test Agent'),
  ],
  bodyContentType: ContentType.formdata,
  formData: [
    FormDataModel(name: "text", value: "API", type: FormDataType.text),
    FormDataModel(name: "sep", value: "|", type: FormDataType.text),
    FormDataModel(name: "times", value: "3", type: FormDataType.text),
  ],
);

/// POST request model with multipart body(text, file)
const httpRequestModelPost6 = HttpRequestModel(
  method: HTTPVerb.post,
  url: 'https://api.apidash.dev/io/img',
  bodyContentType: ContentType.formdata,
  formData: [
    FormDataModel(name: "token", value: "xyz", type: FormDataType.text),
    FormDataModel(
        name: "imfile", value: "/Documents/up/1.png", type: FormDataType.file),
  ],
);

/// POST request model with multipart body and requestBody (the requestBody shouldn't be in codegen)
const httpRequestModelPost7 = HttpRequestModel(
  method: HTTPVerb.post,
  url: 'https://api.apidash.dev/io/img',
  bodyContentType: ContentType.formdata,
  body: r"""{
"text": "I LOVE Flutter"
}""",
  formData: [
    FormDataModel(name: "token", value: "xyz", type: FormDataType.text),
    FormDataModel(
        name: "imfile", value: "/Documents/up/1.png", type: FormDataType.file),
  ],
);

/// POST request model with multipart body and requestParams
const httpRequestModelPost8 = HttpRequestModel(
  method: HTTPVerb.post,
  url: 'https://api.apidash.dev/io/form',
  params: [
    NameValueModel(name: 'size', value: '2'),
    NameValueModel(name: 'len', value: '3'),
  ],
  bodyContentType: ContentType.formdata,
  formData: [
    FormDataModel(name: "text", value: "API", type: FormDataType.text),
    FormDataModel(name: "sep", value: "|", type: FormDataType.text),
    FormDataModel(name: "times", value: "3", type: FormDataType.text),
  ],
);

/// POST request model with multipart body(file and text), requestParams, requestHeaders and requestBody
const httpRequestModelPost9 = HttpRequestModel(
  method: HTTPVerb.post,
  url: 'https://api.apidash.dev/io/img',
  headers: [
    NameValueModel(name: 'User-Agent', value: 'Test Agent'),
    NameValueModel(name: 'Keep-Alive', value: 'true'),
  ],
  params: [
    NameValueModel(name: 'size', value: '2'),
    NameValueModel(name: 'len', value: '3'),
  ],
  bodyContentType: ContentType.formdata,
  body: r"""{
"text": "I LOVE Flutter"
}""",
  formData: [
    FormDataModel(name: "token", value: "xyz", type: FormDataType.text),
    FormDataModel(
        name: "imfile", value: "/Documents/up/1.png", type: FormDataType.file),
  ],
);

/// POST request model with content type override and all other params
const httpRequestModelPost10 = HttpRequestModel(
  method: HTTPVerb.post,
  url: 'https://api.apidash.dev/case/lower',
  headers: [
    NameValueModel(name: 'User-Agent', value: 'Test Agent'),
    NameValueModel(
        name: 'Content-Type', value: 'application/json; charset=utf-8'),
  ],
  params: [
    NameValueModel(name: 'size', value: '2'),
    NameValueModel(name: 'len', value: '3'),
  ],
  isHeaderEnabledList: [false, true],
  isParamEnabledList: null,
  bodyContentType: ContentType.json,
  body: r"""{
"text": "I LOVE Flutter"
}""",
  formData: [
    FormDataModel(name: "token", value: "xyz", type: FormDataType.text),
    FormDataModel(
        name: "imfile", value: "/Documents/up/1.png", type: FormDataType.file),
  ],
);

/// PUT request model
const httpRequestModelPut1 = HttpRequestModel(
  method: HTTPVerb.put,
  url: 'https://reqres.in/api/users/2',
  bodyContentType: ContentType.json,
  body: r"""{
"name": "morpheus",
"job": "zion resident"
}""",
);

/// PATCH request model
const httpRequestModelPatch1 = HttpRequestModel(
  method: HTTPVerb.patch,
  url: 'https://reqres.in/api/users/2',
  bodyContentType: ContentType.json,
  body: r"""{
"name": "marfeus",
"job": "accountant"
}""",
);

/// Basic DELETE request model
const httpRequestModelDelete1 = HttpRequestModel(
  method: HTTPVerb.delete,
  url: 'https://reqres.in/api/users/2',
);

/// Basic DELETE with body
const httpRequestModelDelete2 = HttpRequestModel(
  method: HTTPVerb.delete,
  url: 'https://reqres.in/api/users/2',
  bodyContentType: ContentType.json,
  body: r"""{
"name": "marfeus",
"job": "accountant"
}""",
);

// JSONs

const httpRequestModelGet4Json = <String, dynamic>{
  "method": 'get',
  "url": 'https://api.apidash.dev/humanize/social',
  "headers": null,
  "params": [
    {'name': 'num', 'value': '8700000'},
    {'name': 'digits', 'value': '3'},
    {'name': 'system', 'value': 'SS'},
    {'name': 'add_space', 'value': 'true'},
    {'name': 'trailing_zeros', 'value': 'true'}
  ],
  "isHeaderEnabledList": null,
  "isParamEnabledList": null,
  "bodyContentType": "json",
  "body": null,
  "formData": null
};

const httpRequestModelPost10Json = <String, dynamic>{
  "method": 'post',
  "url": 'https://api.apidash.dev/case/lower',
  "headers": [
    {'name': 'User-Agent', 'value': 'Test Agent'},
    {'name': 'Content-Type', 'value': 'application/json; charset=utf-8'}
  ],
  'params': [
    {'name': 'size', 'value': '2'},
    {'name': 'len', 'value': '3'}
  ],
  'isHeaderEnabledList': [false, true],
  'isParamEnabledList': null,
  "bodyContentType": 'json',
  "body": '''{
"text": "I LOVE Flutter"
}''',
  'formData': [
    {'name': 'token', 'value': 'xyz', 'type': 'text'},
    {'name': 'imfile', 'value': '/Documents/up/1.png', 'type': 'file'}
  ],
};
