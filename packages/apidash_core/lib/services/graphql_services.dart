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
  
 
  (Uri?, String?) uriRec = getValidRequestUri(
    requestModel.url,
    null,
    defaultUriScheme: defaultUriScheme,
  );
  Map<String, String> headers = requestModel.enabledHeadersMap;
  print("headers:${headers}");
  print(requestModel.url);
  final HttpLink httpLink = HttpLink(
        requestModel.url,
        defaultHeaders: headers
  );


  if (uriRec.$1 != null) {
    Uri requestUrl = uriRec.$1!;
   print("requestUrl ${requestUrl}");
    
    
    try {
      Stopwatch stopwatch = Stopwatch()..start();
      
      final GraphQLClient client = GraphQLClient(
            link: httpLink,
            cache: GraphQLCache(),
      );
      print("query: ${requestModel.query}");

      final QueryOptions options = QueryOptions(
          document: gql(requestModel.query?.isNotEmpty == true ? requestModel.query! : ""),
          variables: requestModel.graphqlVariablesMap,
      );

  final QueryResult result = await client.query(options);
      print("I am printing query inside grphqq ${result}");
      
      stopwatch.stop();
      return (result, stopwatch.elapsed, null);
    } catch (e) {
      print("entered catch ${e} ::: ${e.toString()}");
      
      return (null, null, e.toString());
    } 
  } else {
    return (null, null, uriRec.$2);
  }
}
