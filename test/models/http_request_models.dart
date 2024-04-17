import 'package:apidash/models/models.dart'
    show FormDataModel, NameValueModel, HttpRequestModel;
import 'package:apidash/consts.dart';

/// Basic GET request model
const requestModelGet1 = HttpRequestModel(
  method: HTTPVerb.get,
  url: 'https://api.apidash.dev',
);

/// GET request model with query params
const requestModelGet2 = HttpRequestModel(
  method: HTTPVerb.get,
  url: 'https://api.apidash.dev/country/data',
  params: [
    NameValueModel(name: 'code', value: 'US'),
  ],
);

/// GET request model with override query params
const requestModelGet3 = HttpRequestModel(
  url: 'https://api.apidash.dev/country/data?code=US',
  method: HTTPVerb.get,
  params: [
    NameValueModel(name: 'code', value: 'IND'),
  ],
);

/// GET request model with different types of query params
const requestModelGet4 = HttpRequestModel(
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
const requestModelGet5 = HttpRequestModel(
  method: HTTPVerb.get,
  url: 'https://api.github.com/repos/foss42/apidash',
  headers: [
    NameValueModel(name: 'User-Agent', value: 'Test Agent'),
  ],
);

/// GET request model with headers & query params
const requestModelGet6 = HttpRequestModel(
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
const requestModelGet7 = HttpRequestModel(
  method: HTTPVerb.get,
  url: 'https://api.apidash.dev',
  bodyContentType: ContentType.text,
  body: 'This is a random text which should not be attached with a GET request',
);

/// GET request model with empty header & query param name
const requestModelGet8 = HttpRequestModel(
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
const requestModelGet9 = HttpRequestModel(
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
const requestModelGet10 = HttpRequestModel(
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
const requestModelGet11 = HttpRequestModel(
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
const requestModelGet12 = HttpRequestModel(
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
const requestModelHead1 = HttpRequestModel(
  method: HTTPVerb.head,
  url: 'https://api.apidash.dev',
);

/// Without URI Scheme (pass default as http)
const requestModelHead2 = HttpRequestModel(
  method: HTTPVerb.head,
  url: 'api.apidash.dev',
);

/// Basic POST request model (txt body)
const requestModelPost1 = HttpRequestModel(
  method: HTTPVerb.post,
  url: 'https://api.apidash.dev/case/lower',
  body: r"""{
"text": "I LOVE Flutter"
}""",
  bodyContentType: ContentType.text,
);

/// POST request model with JSON body
const requestModelPost2 = HttpRequestModel(
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
const requestModelPost3 = HttpRequestModel(
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
const requestModelPost4 = HttpRequestModel(
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
const requestModelPost5 = HttpRequestModel(
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
const requestModelPost6 = HttpRequestModel(
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
const requestModelPost7 = HttpRequestModel(
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
const requestModelPost8 = HttpRequestModel(
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
const requestModelPost9 = HttpRequestModel(
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
const requestModelPost10 = HttpRequestModel(
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
const requestModelPut1 = HttpRequestModel(
  method: HTTPVerb.put,
  url: 'https://reqres.in/api/users/2',
  bodyContentType: ContentType.json,
  body: r"""{
"name": "morpheus",
"job": "zion resident"
}""",
);

/// PATCH request model
const requestModelPatch1 = HttpRequestModel(
  method: HTTPVerb.patch,
  url: 'https://reqres.in/api/users/2',
  bodyContentType: ContentType.json,
  body: r"""{
"name": "marfeus",
"job": "accountant"
}""",
);

/// Basic DELETE request model
const requestModelDelete1 = HttpRequestModel(
  method: HTTPVerb.delete,
  url: 'https://reqres.in/api/users/2',
);

/// Basic DELETE with body
const requestModelDelete2 = HttpRequestModel(
  method: HTTPVerb.delete,
  url: 'https://reqres.in/api/users/2',
  bodyContentType: ContentType.json,
  body: r"""{
"name": "marfeus",
"job": "accountant"
}""",
);
