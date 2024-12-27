// import 'package:graphql_flutter/graphql_flutter.dart';

// Future<void> graphq() async{
// print("hi");
//   final HttpLink httpLink = HttpLink(
//   'https://rickandmortyapi.com/graphql',
//   defaultHeaders: {
//     'Authorization': 'Bearer your_token',
//     'Custom-Header': 'value',
//   },
// );

// final GraphQLClient client = GraphQLClient(
//   link: httpLink,
//   cache: GraphQLCache(),
// );

const String query = r'''
  query {
  characters(page: 2, filter: { name: "rick" }) {
    info {
      count
    }
    results {
      name
    }
  }
  location(id: 1) {
    id
  }
  episodesByIds(ids: [1, 2]) {
    id
  }
}
// ''';


//   final QueryOptions options = QueryOptions(
//     document: gql(query),
//     variables: {
//       'id': 1,
//     },
//   );

//   final QueryResult result = await client.query(options);
//   result.
//   if (result.hasException) {
//     print("ERROR");
//     print('GraphQL Exception: ${result.exception.toString()}');
//   } else {
//    // print('GraphQL Data: ${result.data}');
//   }
// }

