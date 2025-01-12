import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:seed/seed.dart';
import '../consts.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import 'http_client_manager.dart';
import 'package:graphql/client.dart';


Future<(QueryResult?, Duration?, String?)> graphRequest(
  String requestId,
  GraphqlRequestModel requestModel, {
  SupportedUriSchemes defaultUriScheme = kDefaultUriScheme,
}) async {
  print("entered graphRequest");
  final clientManager = HttpClientManager();
  
  
 
  (Uri?, String?) uriRec = getValidRequestUri(
    requestModel.url,
    null,
    defaultUriScheme: defaultUriScheme,
  );
  print("uriRec:${uriRec}");
  Map<String, String> headers = requestModel.enabledHeadersMap;
  print("headers:${headers}");
  print(requestModel.url);
  final HttpLink httpLink = HttpLink(
        requestModel.url.trim(),
        defaultHeaders: headers
  );

  
  final client = clientManager.createGraphqlClient(requestId,httpLink);

  print("httpLink:${httpLink.uri}");


  if (uriRec.$1 != null) {
    Uri requestUrl = uriRec.$1!;
   print("requestUrl ${requestUrl}");
    
    
    try {
      Stopwatch stopwatch = Stopwatch()..start();
      
      
      print("query: ${requestModel.query}");
      print("graphqlvariables:${requestModel.graphqlVariablesMap}");

      final QueryOptions options = QueryOptions(
          document: gql(requestModel.query?.isNotEmpty == true ? requestModel.query! : ""),
          variables: requestModel.graphqlVariablesMap,
          fetchPolicy: FetchPolicy.networkOnly
      );

  final QueryResult result = await client.query(options);
  //    print("I am printing query inside grphqq $result");
      
      stopwatch.stop();
       if (result.hasException) {
       return (null, null, result.exception.toString());
    } else {
          return (result, stopwatch.elapsed, null);
    }
    
    } catch (e) {
      if (clientManager.wasRequestCancelled(requestId)) {
          print("entering catched of graphql");
        return (null, null, kMsgRequestCancelled);
      }
      print("entered catch $e ::: ${e.toString()}");
      
      return (null, null, e.toString());
    }finally{
      clientManager.closeClient(requestId);
    }
  } else {
    return (null, null, uriRec.$2);
  }
}
