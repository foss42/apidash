import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:test/test.dart';
import '../models/request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r'''<?php

$uri = 'https://api.apidash.dev';

$request = curl_init($uri);

curl_setopt_array($request, [
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_CUSTOMREQUEST => 'GET',
    CURLOPT_FOLLOWLOCATION => true,
]);

$response = curl_exec($request);

curl_close($request);

$httpCode = curl_getinfo($request, CURLINFO_HTTP_CODE);
echo "Status Code: " . $httpCode . "\n";
echo $response . "\n";
''';
      expect(
          codeGen.getCode(CodegenLanguage.phpCurl, requestModelGet1, 'https'),
          expectedCode);
    });
    test('GET 2', () {
      const expectedCode = r'''<?php

$uri = 'https://api.apidash.dev/country/data';

$queryParams = [
    'code' => 'US',
];
$uri .= '?' . http_build_query($queryParams);

$request = curl_init($uri);

curl_setopt_array($request, [
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_CUSTOMREQUEST => 'GET',
    CURLOPT_FOLLOWLOCATION => true,
]);

$response = curl_exec($request);

curl_close($request);

$httpCode = curl_getinfo($request, CURLINFO_HTTP_CODE);
echo "Status Code: " . $httpCode . "\n";
echo $response . "\n";
''';
      expect(
          codeGen.getCode(CodegenLanguage.phpCurl, requestModelGet2, 'https'),
          expectedCode);
    });
    test('GET 3', () {
      const expectedCode = r'''<?php

$uri = 'https://api.apidash.dev/country/data';

$queryParams = [
    'code' => 'IND',
];
$uri .= '?' . http_build_query($queryParams);

$request = curl_init($uri);

curl_setopt_array($request, [
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_CUSTOMREQUEST => 'GET',
    CURLOPT_FOLLOWLOCATION => true,
]);

$response = curl_exec($request);

curl_close($request);

$httpCode = curl_getinfo($request, CURLINFO_HTTP_CODE);
echo "Status Code: " . $httpCode . "\n";
echo $response . "\n";
''';
      expect(
          codeGen.getCode(CodegenLanguage.phpCurl, requestModelGet3, "https"),
          expectedCode);
    });
    test('GET 4', () {
      const expectedCode = r'''<?php

$uri = 'https://api.apidash.dev/humanize/social';

$queryParams = [
    'num' => '8700000',
    'digits' => '3',
    'system' => 'SS',
    'add_space' => 'true',
    'trailing_zeros' => 'true',
];
$uri .= '?' . http_build_query($queryParams);

$request = curl_init($uri);

curl_setopt_array($request, [
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_CUSTOMREQUEST => 'GET',
    CURLOPT_FOLLOWLOCATION => true,
]);

$response = curl_exec($request);

curl_close($request);

$httpCode = curl_getinfo($request, CURLINFO_HTTP_CODE);
echo "Status Code: " . $httpCode . "\n";
echo $response . "\n";
''';
      expect(
          codeGen.getCode(CodegenLanguage.phpCurl, requestModelGet4, "https"),
          expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r'''<?php

$uri = 'https://api.github.com/repos/foss42/apidash';

$headers = [
    'User-Agent: Test Agent',
];

$request = curl_init($uri);

curl_setopt_array($request, [
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_CUSTOMREQUEST => 'GET',
    CURLOPT_HTTPHEADER => $headers,
    CURLOPT_FOLLOWLOCATION => true,
]);

$response = curl_exec($request);

curl_close($request);

$httpCode = curl_getinfo($request, CURLINFO_HTTP_CODE);
echo "Status Code: " . $httpCode . "\n";
echo $response . "\n";
''';
      expect(
          codeGen.getCode(CodegenLanguage.phpCurl, requestModelGet5, 'https'),
          expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r'''<?php

$uri = 'https://api.github.com/repos/foss42/apidash';

$queryParams = [
    'raw' => 'true',
];
$uri .= '?' . http_build_query($queryParams);

$headers = [
    'User-Agent: Test Agent',
];

$request = curl_init($uri);

curl_setopt_array($request, [
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_CUSTOMREQUEST => 'GET',
    CURLOPT_HTTPHEADER => $headers,
    CURLOPT_FOLLOWLOCATION => true,
]);

$response = curl_exec($request);

curl_close($request);

$httpCode = curl_getinfo($request, CURLINFO_HTTP_CODE);
echo "Status Code: " . $httpCode . "\n";
echo $response . "\n";
''';
      expect(
          codeGen.getCode(CodegenLanguage.phpCurl, requestModelGet6, "https"),
          expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r'''<?php

$uri = 'https://api.apidash.dev';

$request = curl_init($uri);

curl_setopt_array($request, [
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_CUSTOMREQUEST => 'GET',
    CURLOPT_FOLLOWLOCATION => true,
]);

$response = curl_exec($request);

curl_close($request);

$httpCode = curl_getinfo($request, CURLINFO_HTTP_CODE);
echo "Status Code: " . $httpCode . "\n";
echo $response . "\n";
''';
      expect(
          codeGen.getCode(CodegenLanguage.phpCurl, requestModelGet7, "https"),
          expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r'''<?php

$uri = 'https://api.github.com/repos/foss42/apidash';

$queryParams = [
    'raw' => 'true',
];
$uri .= '?' . http_build_query($queryParams);

$headers = [
    'User-Agent: Test Agent',
];

$request = curl_init($uri);

curl_setopt_array($request, [
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_CUSTOMREQUEST => 'GET',
    CURLOPT_HTTPHEADER => $headers,
    CURLOPT_FOLLOWLOCATION => true,
]);

$response = curl_exec($request);

curl_close($request);

$httpCode = curl_getinfo($request, CURLINFO_HTTP_CODE);
echo "Status Code: " . $httpCode . "\n";
echo $response . "\n";
''';
      expect(
          codeGen.getCode(CodegenLanguage.phpCurl, requestModelGet8, "https"),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r'''<?php

$uri = 'https://api.apidash.dev/humanize/social';

$queryParams = [
    'num' => '8700000',
    'add_space' => 'true',
];
$uri .= '?' . http_build_query($queryParams);

$request = curl_init($uri);

curl_setopt_array($request, [
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_CUSTOMREQUEST => 'GET',
    CURLOPT_FOLLOWLOCATION => true,
]);

$response = curl_exec($request);

curl_close($request);

$httpCode = curl_getinfo($request, CURLINFO_HTTP_CODE);
echo "Status Code: " . $httpCode . "\n";
echo $response . "\n";
''';
      expect(
          codeGen.getCode(CodegenLanguage.phpCurl, requestModelGet9, "https"),
          expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r'''<?php

$uri = 'https://api.apidash.dev/humanize/social';

$headers = [
    'User-Agent: Test Agent',
];

$request = curl_init($uri);

curl_setopt_array($request, [
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_CUSTOMREQUEST => 'GET',
    CURLOPT_HTTPHEADER => $headers,
    CURLOPT_FOLLOWLOCATION => true,
]);

$response = curl_exec($request);

curl_close($request);

$httpCode = curl_getinfo($request, CURLINFO_HTTP_CODE);
echo "Status Code: " . $httpCode . "\n";
echo $response . "\n";
''';
      expect(
          codeGen.getCode(CodegenLanguage.phpCurl, requestModelGet10, "https"),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r'''<?php

$uri = 'https://api.apidash.dev/humanize/social';

$queryParams = [
    'num' => '8700000',
    'digits' => '3',
];
$uri .= '?' . http_build_query($queryParams);

$headers = [
    'User-Agent: Test Agent',
];

$request = curl_init($uri);

curl_setopt_array($request, [
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_CUSTOMREQUEST => 'GET',
    CURLOPT_HTTPHEADER => $headers,
    CURLOPT_FOLLOWLOCATION => true,
]);

$response = curl_exec($request);

curl_close($request);

$httpCode = curl_getinfo($request, CURLINFO_HTTP_CODE);
echo "Status Code: " . $httpCode . "\n";
echo $response . "\n";
''';
      expect(
          codeGen.getCode(CodegenLanguage.phpCurl, requestModelGet11, "https"),
          expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r'''<?php

$uri = 'https://api.apidash.dev/humanize/social';

$request = curl_init($uri);

curl_setopt_array($request, [
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_CUSTOMREQUEST => 'GET',
    CURLOPT_FOLLOWLOCATION => true,
]);

$response = curl_exec($request);

curl_close($request);

$httpCode = curl_getinfo($request, CURLINFO_HTTP_CODE);
echo "Status Code: " . $httpCode . "\n";
echo $response . "\n";
''';
      expect(
          codeGen.getCode(CodegenLanguage.phpCurl, requestModelGet12, "https"),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r'''<?php

$uri = 'https://api.apidash.dev';

$request = curl_init($uri);

curl_setopt_array($request, [
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_CUSTOMREQUEST => 'HEAD',
    CURLOPT_FOLLOWLOCATION => true,
]);

$response = curl_exec($request);

curl_close($request);

$httpCode = curl_getinfo($request, CURLINFO_HTTP_CODE);
echo "Status Code: " . $httpCode . "\n";
echo $response . "\n";
''';
      expect(
          codeGen.getCode(CodegenLanguage.phpCurl, requestModelHead1, "https"),
          expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r'''<?php

$uri = 'http://api.apidash.dev';

$request = curl_init($uri);

curl_setopt_array($request, [
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_CUSTOMREQUEST => 'HEAD',
    CURLOPT_FOLLOWLOCATION => true,
]);

$response = curl_exec($request);

curl_close($request);

$httpCode = curl_getinfo($request, CURLINFO_HTTP_CODE);
echo "Status Code: " . $httpCode . "\n";
echo $response . "\n";
''';
      expect(
          codeGen.getCode(CodegenLanguage.phpCurl, requestModelHead2, "http"),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r'''<?php

$uri = 'https://api.apidash.dev/case/lower';

$request_body = '{
"text": "I LOVE Flutter"
}';

$headers = [
    'Content-Type: text/plain',
];

$request = curl_init($uri);

curl_setopt_array($request, [
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_CUSTOMREQUEST => 'POST',
    CURLOPT_HTTPHEADER => $headers,
    CURLOPT_POSTFIELDS => $request_body,
    CURLOPT_FOLLOWLOCATION => true,
]);

$response = curl_exec($request);

curl_close($request);

$httpCode = curl_getinfo($request, CURLINFO_HTTP_CODE);
echo "Status Code: " . $httpCode . "\n";
echo $response . "\n";
''';
      expect(
          codeGen.getCode(CodegenLanguage.phpCurl, requestModelPost1, "https"),
          expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r'''<?php

$uri = 'https://api.apidash.dev/case/lower';

$request_body = '{
"text": "I LOVE Flutter",
"flag": null,
"male": true,
"female": false,
"no": 1.2,
"arr": ["null", "true", "false", null]
}';

$headers = [
    'Content-Type: application/json',
];

$request = curl_init($uri);

curl_setopt_array($request, [
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_CUSTOMREQUEST => 'POST',
    CURLOPT_HTTPHEADER => $headers,
    CURLOPT_POSTFIELDS => $request_body,
    CURLOPT_FOLLOWLOCATION => true,
]);

$response = curl_exec($request);

curl_close($request);

$httpCode = curl_getinfo($request, CURLINFO_HTTP_CODE);
echo "Status Code: " . $httpCode . "\n";
echo $response . "\n";
''';
      expect(
          codeGen.getCode(CodegenLanguage.phpCurl, requestModelPost2, "https"),
          expectedCode);
    });
    test('POST 3', () {
      const expectedCode = r'''<?php

$uri = 'https://api.apidash.dev/case/lower';

$request_body = '{
"text": "I LOVE Flutter"
}';

$headers = [
    'User-Agent: Test Agent',
    'Content-Type: application/json',
];

$request = curl_init($uri);

curl_setopt_array($request, [
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_CUSTOMREQUEST => 'POST',
    CURLOPT_HTTPHEADER => $headers,
    CURLOPT_POSTFIELDS => $request_body,
    CURLOPT_FOLLOWLOCATION => true,
]);

$response = curl_exec($request);

curl_close($request);

$httpCode = curl_getinfo($request, CURLINFO_HTTP_CODE);
echo "Status Code: " . $httpCode . "\n";
echo $response . "\n";
''';
      expect(
          codeGen.getCode(CodegenLanguage.phpCurl, requestModelPost3, "https"),
          expectedCode);
    });

    test('POST 4', () {
      const expectedCode = r'''<?php

$uri = 'https://api.apidash.dev/io/form';

$request_body = [
    'text' => 'API',
    'sep' => '|',
    'times' => '3',
];

$request = curl_init($uri);

curl_setopt_array($request, [
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_CUSTOMREQUEST => 'POST',
    CURLOPT_POSTFIELDS => $request_body,
    CURLOPT_FOLLOWLOCATION => true,
]);

$response = curl_exec($request);

curl_close($request);

$httpCode = curl_getinfo($request, CURLINFO_HTTP_CODE);
echo "Status Code: " . $httpCode . "\n";
echo $response . "\n";
''';
      expect(
          codeGen.getCode(CodegenLanguage.phpCurl, requestModelPost4, "https"),
          expectedCode);
    });

    test('POST 5', () {
      const expectedCode = r'''<?php

$uri = 'https://api.apidash.dev/io/form';

$request_body = [
    'text' => 'API',
    'sep' => '|',
    'times' => '3',
];

$headers = [
    'User-Agent: Test Agent',
];

$request = curl_init($uri);

curl_setopt_array($request, [
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_CUSTOMREQUEST => 'POST',
    CURLOPT_HTTPHEADER => $headers,
    CURLOPT_POSTFIELDS => $request_body,
    CURLOPT_FOLLOWLOCATION => true,
]);

$response = curl_exec($request);

curl_close($request);

$httpCode = curl_getinfo($request, CURLINFO_HTTP_CODE);
echo "Status Code: " . $httpCode . "\n";
echo $response . "\n";
''';
      expect(
          codeGen.getCode(CodegenLanguage.phpCurl, requestModelPost5, "https"),
          expectedCode);
    });
    test('POST 6', () {
      const expectedCode = r'''<?php

$uri = 'https://api.apidash.dev/io/img';

$request_body = [
    'token' => 'xyz',
    'imfile' => new CURLFILE('/Documents/up/1.png'),
];

$request = curl_init($uri);

curl_setopt_array($request, [
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_CUSTOMREQUEST => 'POST',
    CURLOPT_POSTFIELDS => $request_body,
    CURLOPT_FOLLOWLOCATION => true,
]);

$response = curl_exec($request);

curl_close($request);

$httpCode = curl_getinfo($request, CURLINFO_HTTP_CODE);
echo "Status Code: " . $httpCode . "\n";
echo $response . "\n";
''';
      expect(
          codeGen.getCode(CodegenLanguage.phpCurl, requestModelPost6, "https"),
          expectedCode);
    });
    test('POST 7', () {
      const expectedCode = r'''<?php

$uri = 'https://api.apidash.dev/io/img';

$request_body = [
    'token' => 'xyz',
    'imfile' => new CURLFILE('/Documents/up/1.png'),
];

$request = curl_init($uri);

curl_setopt_array($request, [
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_CUSTOMREQUEST => 'POST',
    CURLOPT_POSTFIELDS => $request_body,
    CURLOPT_FOLLOWLOCATION => true,
]);

$response = curl_exec($request);

curl_close($request);

$httpCode = curl_getinfo($request, CURLINFO_HTTP_CODE);
echo "Status Code: " . $httpCode . "\n";
echo $response . "\n";
''';
      expect(
          codeGen.getCode(CodegenLanguage.phpCurl, requestModelPost7, "https"),
          expectedCode);
    });
    test('POST 8', () {
      const expectedCode = r'''<?php

$uri = 'https://api.apidash.dev/io/form';

$request_body = [
    'text' => 'API',
    'sep' => '|',
    'times' => '3',
];

$queryParams = [
    'size' => '2',
    'len' => '3',
];
$uri .= '?' . http_build_query($queryParams);

$request = curl_init($uri);

curl_setopt_array($request, [
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_CUSTOMREQUEST => 'POST',
    CURLOPT_POSTFIELDS => $request_body,
    CURLOPT_FOLLOWLOCATION => true,
]);

$response = curl_exec($request);

curl_close($request);

$httpCode = curl_getinfo($request, CURLINFO_HTTP_CODE);
echo "Status Code: " . $httpCode . "\n";
echo $response . "\n";
''';
      expect(
          codeGen.getCode(CodegenLanguage.phpCurl, requestModelPost8, "https"),
          expectedCode);
    });
    test('POST 9', () {
      const expectedCode = r'''<?php

$uri = 'https://api.apidash.dev/io/img';

$request_body = [
    'token' => 'xyz',
    'imfile' => new CURLFILE('/Documents/up/1.png'),
];

$queryParams = [
    'size' => '2',
    'len' => '3',
];
$uri .= '?' . http_build_query($queryParams);

$headers = [
    'User-Agent: Test Agent',
    'Keep-Alive: true',
];

$request = curl_init($uri);

curl_setopt_array($request, [
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_CUSTOMREQUEST => 'POST',
    CURLOPT_HTTPHEADER => $headers,
    CURLOPT_POSTFIELDS => $request_body,
    CURLOPT_FOLLOWLOCATION => true,
]);

$response = curl_exec($request);

curl_close($request);

$httpCode = curl_getinfo($request, CURLINFO_HTTP_CODE);
echo "Status Code: " . $httpCode . "\n";
echo $response . "\n";
''';
      expect(
          codeGen.getCode(CodegenLanguage.phpCurl, requestModelPost9, "https"),
          expectedCode);
    });
  });
  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r'''<?php

$uri = 'https://reqres.in/api/users/2';

$request_body = '{
"name": "morpheus",
"job": "zion resident"
}';

$headers = [
    'Content-Type: application/json',
];

$request = curl_init($uri);

curl_setopt_array($request, [
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_CUSTOMREQUEST => 'PUT',
    CURLOPT_HTTPHEADER => $headers,
    CURLOPT_POSTFIELDS => $request_body,
    CURLOPT_FOLLOWLOCATION => true,
]);

$response = curl_exec($request);

curl_close($request);

$httpCode = curl_getinfo($request, CURLINFO_HTTP_CODE);
echo "Status Code: " . $httpCode . "\n";
echo $response . "\n";
''';
      expect(
          codeGen.getCode(CodegenLanguage.phpCurl, requestModelPut1, "https"),
          expectedCode);
    });
  });
  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r'''<?php

$uri = 'https://reqres.in/api/users/2';

$request_body = '{
"name": "marfeus",
"job": "accountant"
}';

$headers = [
    'Content-Type: application/json',
];

$request = curl_init($uri);

curl_setopt_array($request, [
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_CUSTOMREQUEST => 'PATCH',
    CURLOPT_HTTPHEADER => $headers,
    CURLOPT_POSTFIELDS => $request_body,
    CURLOPT_FOLLOWLOCATION => true,
]);

$response = curl_exec($request);

curl_close($request);

$httpCode = curl_getinfo($request, CURLINFO_HTTP_CODE);
echo "Status Code: " . $httpCode . "\n";
echo $response . "\n";
''';
      expect(
          codeGen.getCode(CodegenLanguage.phpCurl, requestModelPatch1, "https"),
          expectedCode);
    });
  });
  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r'''<?php

$uri = 'https://reqres.in/api/users/2';

$request = curl_init($uri);

curl_setopt_array($request, [
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_CUSTOMREQUEST => 'DELETE',
    CURLOPT_FOLLOWLOCATION => true,
]);

$response = curl_exec($request);

curl_close($request);

$httpCode = curl_getinfo($request, CURLINFO_HTTP_CODE);
echo "Status Code: " . $httpCode . "\n";
echo $response . "\n";
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.phpCurl, requestModelDelete1, "https"),
          expectedCode);
    });
    test('DELETE 2', () {
      const expectedCode = r'''<?php

$uri = 'https://reqres.in/api/users/2';

$request_body = '{
"name": "marfeus",
"job": "accountant"
}';

$headers = [
    'Content-Type: application/json',
];

$request = curl_init($uri);

curl_setopt_array($request, [
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_CUSTOMREQUEST => 'DELETE',
    CURLOPT_HTTPHEADER => $headers,
    CURLOPT_POSTFIELDS => $request_body,
    CURLOPT_FOLLOWLOCATION => true,
]);

$response = curl_exec($request);

curl_close($request);

$httpCode = curl_getinfo($request, CURLINFO_HTTP_CODE);
echo "Status Code: " . $httpCode . "\n";
echo $response . "\n";
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.phpCurl, requestModelDelete2, "https"),
          expectedCode);
    });
  });
}
