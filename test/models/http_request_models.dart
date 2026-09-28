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
  params: [NameValueModel(name: 'code', value: 'US')],
);

/// GET request model with  query param having multiple values (The code should  handle both paramaters)
const httpRequestModelGet3 = HttpRequestModel(
  url: 'https://api.apidash.dev/country/filtercodes?country=India',
  method: HTTPVerb.get,
  params: [NameValueModel(name: 'country', value: 'United States')],
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
  headers: [NameValueModel(name: 'User-Agent', value: 'Test Agent')],
);

/// GET request model with headers & query params
const httpRequestModelGet6 = HttpRequestModel(
  method: HTTPVerb.get,
  url: 'https://api.github.com/repos/foss42/apidash',
  headers: [NameValueModel(name: 'User-Agent', value: 'Test Agent')],
  params: [NameValueModel(name: 'raw', value: 'true')],
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
  isParamEnabledList: [true, false, false, true],
);

/// GET Request model with some headers enabled
const httpRequestModelGet10 = HttpRequestModel(
  method: HTTPVerb.get,
  url: 'https://api.apidash.dev/humanize/social',
  headers: [
    NameValueModel(name: 'User-Agent', value: 'Test Agent'),
    NameValueModel(name: 'Content-Type', value: 'application/json'),
  ],
  isHeaderEnabledList: [true, false],
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
  isParamEnabledList: [true, true, false, false],
  isHeaderEnabledList: [true, false],
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
  isParamEnabledList: [false, false, false, false],
  isHeaderEnabledList: [false, false],
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
  headers: [NameValueModel(name: 'User-Agent', value: 'Test Agent')],
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
  headers: [NameValueModel(name: 'User-Agent', value: 'Test Agent')],
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
      name: "imfile",
      value: "/Documents/up/1.png",
      type: FormDataType.file,
    ),
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
      name: "imfile",
      value: "/Documents/up/1.png",
      type: FormDataType.file,
    ),
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
      name: "imfile",
      value: "/Documents/up/1.png",
      type: FormDataType.file,
    ),
  ],
);

/// POST request model with content type override and all other params
const httpRequestModelPost10 = HttpRequestModel(
  method: HTTPVerb.post,
  url: 'https://api.apidash.dev/case/lower',
  headers: [
    NameValueModel(name: 'User-Agent', value: 'Test Agent'),
    NameValueModel(
      name: 'Content-Type',
      value: 'application/json; charset=utf-8',
    ),
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
      name: "imfile",
      value: "/Documents/up/1.png",
      type: FormDataType.file,
    ),
  ],
);

/// PUT request model
const httpRequestModelPut1 = HttpRequestModel(
  method: HTTPVerb.put,
  url: 'https://reqres.in/api/users/2',
  headers:[
  NameValueModel(name: 'x-api-key', value: 'reqres-free-v1')
  ],
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
  headers:[
  NameValueModel(name: 'x-api-key', value: 'reqres-free-v1')
  ],
  body: r"""{
"name": "marfeus",
"job": "accountant"
}""",
);

/// Basic DELETE request model
const httpRequestModelDelete1 = HttpRequestModel(
  method: HTTPVerb.delete,
  headers:[
  NameValueModel(name: 'x-api-key', value: 'reqres-free-v1')
  ],
  url: 'https://reqres.in/api/users/2',
);

/// Basic DELETE with body
const httpRequestModelDelete2 = HttpRequestModel(
  method: HTTPVerb.delete,
  url: 'https://reqres.in/api/users/2',
  bodyContentType: ContentType.json,
  headers:[
  NameValueModel(name: 'x-api-key', value: 'reqres-free-v1')
  ],
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
    {'name': 'trailing_zeros', 'value': 'true'},
  ],
  'authModel': {
    'type': 'none',
    'apikey': null,
    'bearer': null,
    'basic': null,
    'jwt': null,
    'digest': null,
    'oauth1': null,
    'oauth2': null,
  },
  "isHeaderEnabledList": null,
  "isParamEnabledList": null,
  "bodyContentType": "json",
  "body": null,
  "query": null,
  "formData": null,
};

const httpRequestModelPost10Json = <String, dynamic>{
  "method": 'post',
  "url": 'https://api.apidash.dev/case/lower',
  "headers": [
    {'name': 'User-Agent', 'value': 'Test Agent'},
    {'name': 'Content-Type', 'value': 'application/json; charset=utf-8'},
  ],
  'params': [
    {'name': 'size', 'value': '2'},
    {'name': 'len', 'value': '3'},
  ],
  'authModel': {
    'type': 'none',
    'apikey': null,
    'bearer': null,
    'basic': null,
    'jwt': null,
    'digest': null,
    'oauth1': null,
    'oauth2': null,
  },
  'isHeaderEnabledList': [false, true],
  'isParamEnabledList': null,
  "bodyContentType": 'json',
  "body": '''{
"text": "I LOVE Flutter"
}''',
  "query": null,
  'formData': [
    {'name': 'token', 'value': 'xyz', 'type': 'text'},
    {'name': 'imfile', 'value': '/Documents/up/1.png', 'type': 'file'},
  ],
};

/// Basic GET request model for apidash.dev
const httpRequestModelGet13 = HttpRequestModel(
  method: HTTPVerb.get,
  url: 'https://apidash.dev',
);

/// Basic GET request model for Certificate expired site
const httpRequestModelGetBadSSL = HttpRequestModel(
  method: HTTPVerb.get,
  url: 'https://expired.badssl.com/',
);

/// POST request model with content type override having no charset
const httpRequestModelPost11 = HttpRequestModel(
  method: HTTPVerb.post,
  url: 'https://api.apidash.dev/case/lower',
  headers: [NameValueModel(name: 'Content-Type', value: 'application/json')],
  isHeaderEnabledList: [true],
  bodyContentType: ContentType.json,
  body: r"""{
"text": "I LOVE Flutter"
}""",
);

/// POST request model with default (utf-8) content type charset
const httpRequestModelPost12 = HttpRequestModel(
  method: HTTPVerb.post,
  url: 'https://api.apidash.dev/case/lower',
  bodyContentType: ContentType.json,
  body: r"""{
"text": "I LOVE Flutter"
}""",
);

/// POST request model with charset override (latin1)
const httpRequestModelPost13 = HttpRequestModel(
  method: HTTPVerb.post,
  url: 'https://api.apidash.dev/case/lower',
  headers: [
    NameValueModel(
      name: 'Content-Type',
      value: 'application/json; charset=latin1',
    ),
  ],
  isHeaderEnabledList: [true],
  bodyContentType: ContentType.json,
  body: r"""{
"text": "I LOVE Flutter"
}""",
);

/// Basic OPTIONS request model
const httpRequestModelOptions1 = HttpRequestModel(
  method: HTTPVerb.options,
  url: 'https://reqbin.com/echo/options',
);

/// GET request model with quotes, backslashes and newlines in params and headers
const httpRequestModelEscape1 = HttpRequestModel(
  method: HTTPVerb.get,
  url: 'https://api.apidash.dev/case/lower',
  params: [NameValueModel(name: "it's", value: 'say "hi"\nC:\\new')],
  headers: [NameValueModel(name: 'If-Match', value: '"abc123"')],
);

/// POST request model with a text body that cannot be a raw string
const httpRequestModelEscape2 = HttpRequestModel(
  method: HTTPVerb.post,
  url: 'https://api.apidash.dev/case/lower',
  bodyContentType: ContentType.text,
  body: "a ''' b \\",
);

/// POST request model with JSON literals and escapes inside string values
const httpRequestModelEscape3 = HttpRequestModel(
  method: HTTPVerb.post,
  url: 'https://api.apidash.dev/case/lower',
  bodyContentType: ContentType.json,
  body: r'''{
"text": "say \"true\" or null",
"path": "a\/b",
"flag": false
}''',
);

/// POST request model with quotes and backslashes in multipart form data
const httpRequestModelEscape4 = HttpRequestModel(
  method: HTTPVerb.post,
  url: 'https://api.apidash.dev/io/form',
  bodyContentType: ContentType.formdata,
  formData: [
    FormDataModel(
        name: 'note', value: 'say "hi"\nbye', type: FormDataType.text),
    FormDataModel(
        name: 'file', value: r'C:\Users\new\file.txt', type: FormDataType.file),
  ],
);

/// GET request model with a quote in the URL path
const httpRequestModelEscape5 = HttpRequestModel(
  method: HTTPVerb.get,
  url: "https://api.apidash.dev/it's/data",
);

/// POST request model with a text body that has trailing spaces and shared
/// indentation, which Java text blocks would strip
const httpRequestModelEscape6 = HttpRequestModel(
  method: HTTPVerb.post,
  url: 'https://api.apidash.dev/case/lower',
  bodyContentType: ContentType.text,
  body: '  name:  \n  value',
);

/// POST request model with `$` in the JSON body, which starts a string
/// template in Kotlin
const httpRequestModelEscape7 = HttpRequestModel(
  method: HTTPVerb.post,
  url: 'https://api.apidash.dev/case/lower',
  bodyContentType: ContentType.json,
  body: r'''{
"cmd": "echo $HOME ${x}",
"price": "$5"
}''',
);

/// POST request model with `"""` in a multi-line text body
const httpRequestModelEscape8 = HttpRequestModel(
  method: HTTPVerb.post,
  url: 'https://api.apidash.dev/case/lower',
  bodyContentType: ContentType.text,
  body: 'say """hi"""\nand """"bye""""',
);

/// POST request model with Windows line endings in the text body
const httpRequestModelEscape9 = HttpRequestModel(
  method: HTTPVerb.post,
  url: 'https://api.apidash.dev/case/lower',
  bodyContentType: ContentType.text,
  body: 'line 1\r\nline 2',
);

/// POST request model with a quote followed by `#` in the text body, which
/// ends a Rust raw string unless it uses more `#`s
const httpRequestModelEscape10 = HttpRequestModel(
  method: HTTPVerb.post,
  url: 'https://api.apidash.dev/case/lower',
  bodyContentType: ContentType.text,
  body: 'color: "#fff" and "##"',
);

/// POST request model with non-ASCII text in multipart form data
const httpRequestModelEscape11 = HttpRequestModel(
  method: HTTPVerb.post,
  url: 'https://api.apidash.dev/io/form',
  bodyContentType: ContentType.formdata,
  formData: [
    FormDataModel(name: 'note', value: 'café ☕', type: FormDataType.text),
  ],
);

/// POST request model with form values that curl's `--form` would misread:
/// `;` starts options, `@` reads a file, and `,` separates file names
const httpRequestModelEscape12 = HttpRequestModel(
  method: HTTPVerb.post,
  url: 'https://api.apidash.dev/io/form',
  bodyContentType: ContentType.formdata,
  formData: [
    FormDataModel(name: 'note', value: 'a; b', type: FormDataType.text),
    FormDataModel(name: 'user', value: '@dash', type: FormDataType.text),
    FormDataModel(
        name: 'file', value: 'C:/Users/new/a,b.txt', type: FormDataType.file),
  ],
);

/// POST request model with a text body starting with `@`, which curl's
/// `--data` reads as a file name
const httpRequestModelEscape13 = HttpRequestModel(
  method: HTTPVerb.post,
  url: 'https://api.apidash.dev/case/lower',
  bodyContentType: ContentType.text,
  body: '@dash',
);

/// GET request model with a header that has an empty value
const httpRequestModelEscape14 = HttpRequestModel(
  method: HTTPVerb.get,
  url: 'https://api.apidash.dev/case/lower',
  headers: [NameValueModel(name: 'X-Empty', value: '')],
);
