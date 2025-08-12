import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';
import '../models/request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET1', () {
      const expectedCode = r'''
<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;

$uri = "https://api.apidash.dev";
$request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('GET', $uri);
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
            CodegenLanguage.phpHttpPlug,
            requestModelGet1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('GET2', () {
      const expectedCode = r'''<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;

$uri = "https://api.apidash.dev/country/data";
  $queryParams = [
  'code' => ['US']
  ];
  $queryString = http_build_query($queryParams, '', '&', PHP_QUERY_RFC3986);
  $queryString = preg_replace('/%5B[0-9]+%5D/', '', $queryString);

  $uri .= '?'.$queryString;


  $request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('GET', $uri);
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
            CodegenLanguage.phpHttpPlug,
            requestModelGet2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('GET3', () {
      const expectedCode = r'''<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;

$uri = "https://api.apidash.dev/country/data";
  $queryParams = [
  'code' => ['IND', 'US']
  ];
  $queryString = http_build_query($queryParams, '', '&', PHP_QUERY_RFC3986);
  $queryString = preg_replace('/%5B[0-9]+%5D/', '', $queryString);

  $uri .= '?'.$queryString;


  $request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('GET', $uri);
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
            CodegenLanguage.phpHttpPlug,
            requestModelGet3,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('GET4', () {
      const expectedCode = r'''<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;

$uri = "https://api.apidash.dev/humanize/social";
  $queryParams = [
  'num' => ['8700000'],
'digits' => ['3'],
'system' => ['SS'],
'add_space' => ['true'],
'trailing_zeros' => ['true']
  ];
  $queryString = http_build_query($queryParams, '', '&', PHP_QUERY_RFC3986);
  $queryString = preg_replace('/%5B[0-9]+%5D/', '', $queryString);

  $uri .= '?'.$queryString;


  $request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('GET', $uri);
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
            CodegenLanguage.phpHttpPlug,
            requestModelGet4,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('GET5', () {
      const expectedCode = r'''
<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;

$uri = "https://api.github.com/repos/foss42/apidash";
$request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('GET', $uri);
$headers = [
    'User-Agent' => 'Test Agent',
];
foreach ($headers as $name => $value) {
    $request = $request->withHeader($name, $value);
}
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
            CodegenLanguage.phpHttpPlug,
            requestModelGet5,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('GET6', () {
      const expectedCode = r'''<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;

$uri = "https://api.github.com/repos/foss42/apidash";
  $queryParams = [
  'raw' => ['true']
  ];
  $queryString = http_build_query($queryParams, '', '&', PHP_QUERY_RFC3986);
  $queryString = preg_replace('/%5B[0-9]+%5D/', '', $queryString);

  $uri .= '?'.$queryString;


  $request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('GET', $uri);
$headers = [
    'User-Agent' => 'Test Agent',
];
foreach ($headers as $name => $value) {
    $request = $request->withHeader($name, $value);
}
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
            CodegenLanguage.phpHttpPlug,
            requestModelGet6,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('GET7', () {
      const expectedCode = r'''
<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;

$uri = "https://api.apidash.dev";
$request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('GET', $uri);
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
            CodegenLanguage.phpHttpPlug,
            requestModelGet7,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('GET8', () {
      const expectedCode = r'''<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;

$uri = "https://api.github.com/repos/foss42/apidash";
  $queryParams = [
  'raw' => ['true']
  ];
  $queryString = http_build_query($queryParams, '', '&', PHP_QUERY_RFC3986);
  $queryString = preg_replace('/%5B[0-9]+%5D/', '', $queryString);

  $uri .= '?'.$queryString;


  $request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('GET', $uri);
$headers = [
    'User-Agent' => 'Test Agent',
];
foreach ($headers as $name => $value) {
    $request = $request->withHeader($name, $value);
}
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
            CodegenLanguage.phpHttpPlug,
            requestModelGet8,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('GET9', () {
      const expectedCode = r'''<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;

$uri = "https://api.apidash.dev/humanize/social";
  $queryParams = [
  'num' => ['8700000'],
'add_space' => ['true']
  ];
  $queryString = http_build_query($queryParams, '', '&', PHP_QUERY_RFC3986);
  $queryString = preg_replace('/%5B[0-9]+%5D/', '', $queryString);

  $uri .= '?'.$queryString;


  $request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('GET', $uri);
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
            CodegenLanguage.phpHttpPlug,
            requestModelGet9,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('GET10', () {
      const expectedCode = r'''
<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;

$uri = "https://api.apidash.dev/humanize/social";
$request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('GET', $uri);
$headers = [
    'User-Agent' => 'Test Agent',
];
foreach ($headers as $name => $value) {
    $request = $request->withHeader($name, $value);
}
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
            CodegenLanguage.phpHttpPlug,
            requestModelGet10,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('GET11', () {
      const expectedCode = r'''<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;

$uri = "https://api.apidash.dev/humanize/social";
  $queryParams = [
  'num' => ['8700000'],
'digits' => ['3']
  ];
  $queryString = http_build_query($queryParams, '', '&', PHP_QUERY_RFC3986);
  $queryString = preg_replace('/%5B[0-9]+%5D/', '', $queryString);

  $uri .= '?'.$queryString;


  $request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('GET', $uri);
$headers = [
    'User-Agent' => 'Test Agent',
];
foreach ($headers as $name => $value) {
    $request = $request->withHeader($name, $value);
}
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
            CodegenLanguage.phpHttpPlug,
            requestModelGet11,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('GET12', () {
      const expectedCode = r'''
<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;

$uri = "https://api.apidash.dev/humanize/social";
$request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('GET', $uri);
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
            CodegenLanguage.phpHttpPlug,
            requestModelGet12,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD1', () {
      const expectedCode = r'''
<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;

$uri = "https://api.apidash.dev";
$request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('HEAD', $uri);
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
            CodegenLanguage.phpHttpPlug,
            requestModelHead1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('HEAD2', () {
      const expectedCode = r'''
<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;

$uri = "http://api.apidash.dev";
$request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('HEAD', $uri);
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
            CodegenLanguage.phpHttpPlug,
            requestModelHead2,
            SupportedUriSchemes.http,
          ),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST1', () {
      const expectedCode = r'''
<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;

$uri = "https://api.apidash.dev/case/lower";
$request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('POST', $uri);
$body = <<<'EOF'
{
"text": "I LOVE Flutter"
}
EOF;

$request = $request->withBody(Psr17FactoryDiscovery::findStreamFactory()->createStream($body));
$headers = [
    'Content-Type' => 'text/plain',
];
foreach ($headers as $name => $value) {
    $request = $request->withHeader($name, $value);
}
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
            CodegenLanguage.phpHttpPlug,
            requestModelPost1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST2', () {
      const expectedCode = r'''
<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;

$uri = "https://api.apidash.dev/case/lower";
$request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('POST', $uri);
$body = <<<'EOF'
{
"text": "I LOVE Flutter",
"flag": null,
"male": true,
"female": false,
"no": 1.2,
"arr": ["null", "true", "false", null]
}
EOF;

$request = $request->withBody(Psr17FactoryDiscovery::findStreamFactory()->createStream($body));
$headers = [
    'Content-Type' => 'application/json',
];
foreach ($headers as $name => $value) {
    $request = $request->withHeader($name, $value);
}
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
            CodegenLanguage.phpHttpPlug,
            requestModelPost2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST3', () {
      const expectedCode = r'''
<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;

$uri = "https://api.apidash.dev/case/lower";
$request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('POST', $uri);
$body = <<<'EOF'
{
"text": "I LOVE Flutter"
}
EOF;

$request = $request->withBody(Psr17FactoryDiscovery::findStreamFactory()->createStream($body));
$headers = [
    'User-Agent' => 'Test Agent',
    'Content-Type' => 'application/json',
];
foreach ($headers as $name => $value) {
    $request = $request->withHeader($name, $value);
}
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
            CodegenLanguage.phpHttpPlug,
            requestModelPost3,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST4', () {
      const expectedCode = r'''
<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;
use Http\Message\MultipartStream\MultipartStreamBuilder;
$uri = "https://api.apidash.dev/io/form";
$request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('POST', $uri);
$builder = new MultipartStreamBuilder();
$builder->addResource('text', 'API');
$builder->addResource('sep', '|');
$builder->addResource('times', '3');

$request = $request->withBody($builder->build());
$headers = [
    'Content-Type' => 'multipart/form-data; boundary=' . $builder->getBoundary(),
];
foreach ($headers as $name => $value) {
    $request = $request->withHeader($name, $value);
}
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
            CodegenLanguage.phpHttpPlug,
            requestModelPost4,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST5', () {
      const expectedCode = r'''
<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;
use Http\Message\MultipartStream\MultipartStreamBuilder;
$uri = "https://api.apidash.dev/io/form";
$request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('POST', $uri);
$builder = new MultipartStreamBuilder();
$builder->addResource('text', 'API');
$builder->addResource('sep', '|');
$builder->addResource('times', '3');

$request = $request->withBody($builder->build());
$headers = [
    'User-Agent' => 'Test Agent',
    'Content-Type' => 'multipart/form-data; boundary=' . $builder->getBoundary(),
];
foreach ($headers as $name => $value) {
    $request = $request->withHeader($name, $value);
}
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
            CodegenLanguage.phpHttpPlug,
            requestModelPost5,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST6', () {
      const expectedCode = r'''
<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;
use Http\Message\MultipartStream\MultipartStreamBuilder;
$uri = "https://api.apidash.dev/io/img";
$request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('POST', $uri);
$builder = new MultipartStreamBuilder();
$builder->addResource('token', 'xyz');

$builder->addResource('imfile', fopen('/Documents/up/1.png', 'r'), ['filename' => '/Documents/up/1.png']);

$request = $request->withBody($builder->build());
$headers = [
    'Content-Type' => 'multipart/form-data; boundary=' . $builder->getBoundary(),
];
foreach ($headers as $name => $value) {
    $request = $request->withHeader($name, $value);
}
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
            CodegenLanguage.phpHttpPlug,
            requestModelPost6,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST7', () {
      const expectedCode = r'''
<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;
use Http\Message\MultipartStream\MultipartStreamBuilder;
$uri = "https://api.apidash.dev/io/img";
$request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('POST', $uri);
$builder = new MultipartStreamBuilder();
$builder->addResource('token', 'xyz');

$builder->addResource('imfile', fopen('/Documents/up/1.png', 'r'), ['filename' => '/Documents/up/1.png']);

$request = $request->withBody($builder->build());
$headers = [
    'Content-Type' => 'multipart/form-data; boundary=' . $builder->getBoundary(),
];
foreach ($headers as $name => $value) {
    $request = $request->withHeader($name, $value);
}
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
            CodegenLanguage.phpHttpPlug,
            requestModelPost7,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST8', () {
      const expectedCode = r'''<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;
use Http\Message\MultipartStream\MultipartStreamBuilder;
$uri = "https://api.apidash.dev/io/form";
  $queryParams = [
  'size' => ['2'],
'len' => ['3']
  ];
  $queryString = http_build_query($queryParams, '', '&', PHP_QUERY_RFC3986);
  $queryString = preg_replace('/%5B[0-9]+%5D/', '', $queryString);

  $uri .= '?'.$queryString;


  $request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('POST', $uri);
$builder = new MultipartStreamBuilder();
$builder->addResource('text', 'API');
$builder->addResource('sep', '|');
$builder->addResource('times', '3');

$request = $request->withBody($builder->build());
$headers = [
    'Content-Type' => 'multipart/form-data; boundary=' . $builder->getBoundary(),
];
foreach ($headers as $name => $value) {
    $request = $request->withHeader($name, $value);
}
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
            CodegenLanguage.phpHttpPlug,
            requestModelPost8,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST9', () {
      const expectedCode = r'''<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;
use Http\Message\MultipartStream\MultipartStreamBuilder;
$uri = "https://api.apidash.dev/io/img";
  $queryParams = [
  'size' => ['2'],
'len' => ['3']
  ];
  $queryString = http_build_query($queryParams, '', '&', PHP_QUERY_RFC3986);
  $queryString = preg_replace('/%5B[0-9]+%5D/', '', $queryString);

  $uri .= '?'.$queryString;


  $request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('POST', $uri);
$builder = new MultipartStreamBuilder();
$builder->addResource('token', 'xyz');

$builder->addResource('imfile', fopen('/Documents/up/1.png', 'r'), ['filename' => '/Documents/up/1.png']);

$request = $request->withBody($builder->build());
$headers = [
    'User-Agent' => 'Test Agent',
    'Keep-Alive' => 'true',
    'Content-Type' => 'multipart/form-data; boundary=' . $builder->getBoundary(),
];
foreach ($headers as $name => $value) {
    $request = $request->withHeader($name, $value);
}
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
            CodegenLanguage.phpHttpPlug,
            requestModelPost9,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT1', () {
      const expectedCode = r'''<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;

$uri = "https://reqres.in/api/users/2";
$request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('PUT', $uri);
$body = <<<'EOF'
{
"name": "morpheus",
"job": "zion resident"
}
EOF;

$request = $request->withBody(Psr17FactoryDiscovery::findStreamFactory()->createStream($body));
$headers = [
    'x-api-key' => 'reqres-free-v1',
    'Content-Type' => 'application/json',
];
foreach ($headers as $name => $value) {
    $request = $request->withHeader($name, $value);
}
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
            CodegenLanguage.phpHttpPlug,
            requestModelPut1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH1', () {
      const expectedCode = r'''<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;

$uri = "https://reqres.in/api/users/2";
$request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('PATCH', $uri);
$body = <<<'EOF'
{
"name": "marfeus",
"job": "accountant"
}
EOF;

$request = $request->withBody(Psr17FactoryDiscovery::findStreamFactory()->createStream($body));
$headers = [
    'x-api-key' => 'reqres-free-v1',
    'Content-Type' => 'application/json',
];
foreach ($headers as $name => $value) {
    $request = $request->withHeader($name, $value);
}
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
            CodegenLanguage.phpHttpPlug,
            requestModelPatch1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE1', () {
      const expectedCode = r'''<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;

$uri = "https://reqres.in/api/users/2";
$request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('DELETE', $uri);
$headers = [
    'x-api-key' => 'reqres-free-v1',
];
foreach ($headers as $name => $value) {
    $request = $request->withHeader($name, $value);
}
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
            CodegenLanguage.phpHttpPlug,
            requestModelDelete1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('DELETE2', () {
      const expectedCode = r'''<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;

$uri = "https://reqres.in/api/users/2";
$request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('DELETE', $uri);
$body = <<<'EOF'
{
"name": "marfeus",
"job": "accountant"
}
EOF;

$request = $request->withBody(Psr17FactoryDiscovery::findStreamFactory()->createStream($body));
$headers = [
    'x-api-key' => 'reqres-free-v1',
    'Content-Type' => 'application/json',
];
foreach ($headers as $name => $value) {
    $request = $request->withHeader($name, $value);
}
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
            CodegenLanguage.phpHttpPlug,
            requestModelDelete2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });
}
