import 'package:curl_parser/curl_parser.dart';

void main() {
  // Parse a cURL command
  final curlString = 'curl -X GET https://api.apidash.dev/';
  final curl = Curl.parse(curlString);

  // Access parsed data
  print(curl.method); // GET
  print(curl.uri); // https://api.apidash.dev/

  // Format Curl object to a cURL command
  final formattedCurlString = curl.toCurlString();
  print(formattedCurlString); // curl "https://api.apidash.dev/""
}
