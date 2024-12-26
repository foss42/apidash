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
  
 
  (Uri?, String?) uriRec = getValidRequestUri(
    requestModel.url,
    null,
    defaultUriScheme: defaultUriScheme,
  );
  Map<String, String> headers = requestModel.enabledHeadersMap;
  
  final HttpLink httpLink = HttpLink(
        uriRec.$2!,
        defaultHeaders: headers
  );


  if (uriRec.$1 != null) {
    Uri requestUrl = uriRec.$1!;
   
    QueryResult? response;
    
    try {
      Stopwatch stopwatch = Stopwatch()..start();
      
      final GraphQLClient client = GraphQLClient(
            link: httpLink,
            cache: GraphQLCache(),
      );


      final QueryOptions options = QueryOptions(
          document: requestModel.query?.isNotEmpty == true ? gql(requestModel.query!) : gql(""),
          variables: requestModel.graphqlVariablesMap,
      );

  final QueryResult result = await client.query(options);
      print(result);
      
      stopwatch.stop();
      return (response, stopwatch.elapsed, null);
    } catch (e) {
      
      return (null, null, e.toString());
    } 
  } else {
    return (null, null, uriRec.$2);
  }
}
