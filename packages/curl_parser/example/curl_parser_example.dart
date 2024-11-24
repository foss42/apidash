import 'package:curl_parser/curl_parser.dart';

void main() {
  // GET
  print("Example #1: GET");
  final curlGetStr = 'curl https://api.apidash.dev/';
  final curlGet = Curl.parse(curlGetStr);

  // Parsed data
  print(curlGet.method);
  // GET
  print(curlGet.uri);
  // https://api.apidash.dev/

  // Object to cURL command
  final formattedCurlGetStr = curlGet.toCurlString();
  print(formattedCurlGetStr);
  // curl "https://api.apidash.dev/"

  // HEAD
  print("Example #2: HEAD");
  final curlHeadStr = 'curl -I https://api.apidash.dev/';
  final curlHead = Curl.parse(curlHeadStr);

  // Access parsed data
  print(curlHead.method);
  // HEAD
  print(curlHead.uri);
  // https://api.apidash.dev/

  // Object to cURL command
  final formattedCurlHeadStr = curlHead.toCurlString();
  print(formattedCurlHeadStr);
  // curl -I "https://api.apidash.dev/"

  // With Headers
  print("Example #3: With Headers");
  final curlHeadersStr = 'curl -H "X-Header: Test" https://api.apidash.dev/';
  final curlHeader = Curl.parse(curlHeadersStr);

  // Access parsed data
  print(curlHeader.method);
  // GET
  print(curlHeader.uri);
  // https://api.apidash.dev/
  print(curlHeader.headers);
  // {"X-Header": "Test"}

  // Object to cURL command
  final formattedCurlHeaderStr = curlHeader.toCurlString();
  print(formattedCurlHeaderStr);
  // curl "https://api.apidash.dev/" \
  //  -H "X-Header: Test"

  // POST
  print("Example #4: POST");
  final curlPostStr = r"""curl -X 'POST' \
  'https://api.apidash.dev/case/lower' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "text": "Grass is green"
}'""";
  final curlPost = Curl.parse(curlPostStr);

  // Access parsed data
  print(curlPost.method);
  // POST
  print(curlPost.uri);
  // https://api.apidash.dev/case/lower
  print(curlPost.headers);
  // {"accept": "application/json", "Content-Type": "application/json"}
  print(curlPost.data);
  // {
  //   "text": "Grass is green"
  // }

  // Object to cURL command
  final formattedCurlPostStr = curlPost.toCurlString();
  print(formattedCurlPostStr);
  // curl -X POST "https://api.apidash.dev/case/lower" \
  //  -H "accept: application/json" \
  //  -H "Content-Type: application/json" \
  //  -d '{
  //   "text": "Grass is green"
  // }'
}
