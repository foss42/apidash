import 'dart:convert';

enum APIType {
  rest("HTTP", "HTTP"),
  graphql("GraphQL", "GQL");

  const APIType(this.label, this.abbr);
  final String label;
  final String abbr;
}

enum APIAuthType {
  none,
  basic,
  apiKey,
  bearerToken,
  jwtBearer,
  digest,
  oauth1,
  oauth2,
}


enum EnvironmentVariableType { variable, secret }
