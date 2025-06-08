import 'package:apidash/models/models.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/models/generic_request_model.dart';
import 'http_request_models.dart';
import 'http_response_models.dart';

/// Basic GET request model
const requestModelGet1 = RequestModel(
  id: 'get1',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelGet1,
  ),
);

/// GET request model with query params
const requestModelGet2 = RequestModel(
  id: 'get2',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelGet2,
  ),
);

/// GET request model with override query params
const requestModelGet3 = RequestModel(
  id: 'get3',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelGet3,
  ),
);

/// GET request model with different types of query params
const requestModelGet4 = RequestModel(
  id: 'get4',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelGet4,
  ),
);

/// GET request model with headers
const requestModelGet5 = RequestModel(
  id: 'get5',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelGet5,
  ),
);

/// GET request model with headers & query params
const requestModelGet6 = RequestModel(
  id: 'get6',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelGet6,
  ),
);

/// GET request model with body
const requestModelGet7 = RequestModel(
  id: 'get7',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelGet7,
  ),
);

/// GET request model with empty header & query param name
const requestModelGet8 = RequestModel(
  id: 'get8',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelGet8,
  ),
);

/// GET request model with some params enabled
const requestModelGet9 = RequestModel(
  id: 'get9',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelGet9,
  ),
);

/// GET Request model with some headers enabled
const requestModelGet10 = RequestModel(
  id: 'get10',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelGet10,
  ),
);

/// GET Request model with some headers & URL parameters enabled
const requestModelGet11 = RequestModel(
  id: 'get11',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelGet11,
  ),
);

/// Request model with all headers & URL parameters disabled
const requestModelGet12 = RequestModel(
  id: 'get12',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelGet12,
  ),
);

/// Basic HEAD request model
const requestModelHead1 = RequestModel(
  id: 'head1',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelHead1,
  ),
);

/// Without URI Scheme (pass default as http)
const requestModelHead2 = RequestModel(
  id: 'head2',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelHead2,
  ),
);

/// Basic POST request model (txt body)
const requestModelPost1 = RequestModel(
  id: 'post1',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelPost1,
  ),
);

/// POST request model with JSON body
const requestModelPost2 = RequestModel(
  id: 'post2',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelPost2,
  ),
);

/// POST request model with headers
const requestModelPost3 = RequestModel(
  id: 'post3',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelPost3,
  ),
);

/// POST request model with multipart body(text)
const requestModelPost4 = RequestModel(
  id: 'post4',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelPost4,
  ),
);

/// POST request model with multipart body and headers
const requestModelPost5 = RequestModel(
  id: 'post5',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelPost5,
  ),
);

/// POST request model with multipart body(text, file)
const requestModelPost6 = RequestModel(
  id: 'post6',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelPost6,
  ),
);

/// POST request model with multipart body and requestBody (the requestBody shouldn't be in codegen)
const requestModelPost7 = RequestModel(
  id: 'post7',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelPost7,
  ),
);

/// POST request model with multipart body and requestParams
const requestModelPost8 = RequestModel(
  id: 'post8',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelPost8,
  ),
);

/// POST request model with multipart body(file and text), requestParams, requestHeaders and requestBody
const requestModelPost9 = RequestModel(
  id: 'post9',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelPost9,
  ),
);

const requestModelPost10 = RequestModel(
  id: 'post9',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelPost10,
  ),
);

/// PUT request model
const requestModelPut1 = RequestModel(
  id: 'put1',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelPut1,
  ),
);

/// PATCH request model
const requestModelPatch1 = RequestModel(
  id: 'patch1',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelPatch1,
  ),
);

/// Basic DELETE request model
const requestModelDelete1 = RequestModel(
  id: 'delete1',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelDelete1,
  ),
);

/// Basic DELETE with body
const requestModelDelete2 = RequestModel(
  id: 'delete2',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelDelete2,
  ),
);

// full request model
RequestModel testRequestModel = RequestModel(
  id: '1',
  apiType: APIType.rest,
  responseStatus: 200,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelPost10,
  ),
);

// JSON
Map<String, dynamic> requestModelJson = {
  'id': '1',
  'apiType': 'rest',
  'name': '',
  'description': '',
  'httpRequestModel': httpRequestModelPost10Json,
  'responseStatus': 200,
  'message': null,
  'httpResponseModel': responseModelJson,
};

/// Basic GET request model for apidash.dev
const requestModelGet13 = RequestModel(
  id: 'get13',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelGet13,
  ),
);

/// Basic GET request model for badSSL
const requestModelGetBadSSL = RequestModel(
  id: 'badSSL',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelGetBadSSL,
  ),
);

/// POST request model with content type override having no charset
const requestModelPost11 = RequestModel(
  id: 'post11',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelPost11,
  ),
);

/// POST request model with default (utf-8) content type charset
const requestModelPost12 = RequestModel(
  id: 'post12',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelPost12,
  ),
);

/// POST request model with charset override (latin1)
const requestModelPost13 = RequestModel(
  id: 'post13',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelPost13,
  ),
);

const requestModelOptions1 = RequestModel(
  id: 'options1',
  apiType: APIType.rest,
  genericRequestModel: GenericRequestModel(
    aiRequestModel: null,
    httpRequestModel: httpRequestModelOptions1,
  ),
);
