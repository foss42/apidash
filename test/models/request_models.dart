import 'package:apidash/models/models.dart';
import 'http_request_models.dart';
import 'http_response_models.dart';

/// Basic GET request model
const requestModelGet1 = RequestModel(
  id: 'get1',
  httpRequestModel: httpRequestModelGet1,
);

/// GET request model with query params
const requestModelGet2 = RequestModel(
  id: 'get2',
  httpRequestModel: httpRequestModelGet2,
);

/// GET request model with override query params
const requestModelGet3 = RequestModel(
  id: 'get3',
  httpRequestModel: httpRequestModelGet3,
);

/// GET request model with different types of query params
const requestModelGet4 = RequestModel(
  id: 'get4',
  httpRequestModel: httpRequestModelGet4,
);

/// GET request model with headers
const requestModelGet5 = RequestModel(
  id: 'get5',
  httpRequestModel: httpRequestModelGet5,
);

/// GET request model with headers & query params
const requestModelGet6 = RequestModel(
  id: 'get6',
  httpRequestModel: httpRequestModelGet6,
);

/// GET request model with body
const requestModelGet7 = RequestModel(
  id: 'get7',
  httpRequestModel: httpRequestModelGet7,
);

/// GET request model with empty header & query param name
const requestModelGet8 = RequestModel(
  id: 'get8',
  httpRequestModel: httpRequestModelGet8,
);

/// GET request model with some params enabled
const requestModelGet9 = RequestModel(
  id: 'get9',
  httpRequestModel: httpRequestModelGet9,
);

/// GET Request model with some headers enabled
const requestModelGet10 = RequestModel(
  id: 'get10',
  httpRequestModel: httpRequestModelGet10,
);

/// GET Request model with some headers & URL parameters enabled
const requestModelGet11 = RequestModel(
  id: 'get11',
  httpRequestModel: httpRequestModelGet11,
);

/// Request model with all headers & URL parameters disabled
const requestModelGet12 = RequestModel(
  id: 'get12',
  httpRequestModel: httpRequestModelGet12,
);

/// Basic HEAD request model
const requestModelHead1 = RequestModel(
  id: 'head1',
  httpRequestModel: httpRequestModelHead1,
);

/// Without URI Scheme (pass default as http)
const requestModelHead2 = RequestModel(
  id: 'head2',
  httpRequestModel: httpRequestModelHead2,
);

/// Basic POST request model (txt body)
const requestModelPost1 = RequestModel(
  id: 'post1',
  httpRequestModel: httpRequestModelPost1,
);

/// POST request model with JSON body
const requestModelPost2 = RequestModel(
  id: 'post2',
  httpRequestModel: httpRequestModelPost2,
);

/// POST request model with headers
const requestModelPost3 = RequestModel(
  id: 'post3',
  httpRequestModel: httpRequestModelPost3,
);

/// POST request model with multipart body(text)
const requestModelPost4 = RequestModel(
  id: 'post4',
  httpRequestModel: httpRequestModelPost4,
);

/// POST request model with multipart body and headers
const requestModelPost5 = RequestModel(
  id: 'post5',
  httpRequestModel: httpRequestModelPost5,
);

/// POST request model with multipart body(text, file)
const requestModelPost6 = RequestModel(
  id: 'post6',
  httpRequestModel: httpRequestModelPost6,
);

/// POST request model with multipart body and requestBody (the requestBody shouldn't be in codegen)
const requestModelPost7 = RequestModel(
  id: 'post7',
  httpRequestModel: httpRequestModelPost7,
);

/// POST request model with multipart body and requestParams
const requestModelPost8 = RequestModel(
  id: 'post8',
  httpRequestModel: httpRequestModelPost8,
);

/// POST request model with multipart body(file and text), requestParams, requestHeaders and requestBody
const requestModelPost9 = RequestModel(
  id: 'post9',
  httpRequestModel: httpRequestModelPost9,
);

const requestModelPost10 = RequestModel(
  id: 'post9',
  httpRequestModel: httpRequestModelPost10,
);

/// PUT request model
const requestModelPut1 = RequestModel(
  id: 'put1',
  httpRequestModel: httpRequestModelPut1,
);

/// PATCH request model
const requestModelPatch1 = RequestModel(
  id: 'patch1',
  httpRequestModel: httpRequestModelPatch1,
);

/// Basic DELETE request model
const requestModelDelete1 = RequestModel(
  id: 'delete1',
  httpRequestModel: httpRequestModelDelete1,
);

/// Basic DELETE with body
const requestModelDelete2 = RequestModel(
  id: 'delete2',
  httpRequestModel: httpRequestModelDelete2,
);

// full request model
RequestModel testRequestModel = RequestModel(
  id: '1',
  httpRequestModel: httpRequestModelPost10,
  responseStatus: 200,
  httpResponseModel: responseModel,
);

// JSON
Map<String, dynamic> requestModelJson = {
  'id': '1',
  'name': '',
  'description': '',
  'httpRequestModel': httpRequestModelPost10Json,
  'responseStatus': 200,
  'message': null,
  'httpResponseModel': responseModelJson,
};
