import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
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
              CodegenLanguage.phpHttpPlug, requestModelGet1, "https"),
          expectedCode);
    });
    test('GET2', () {
      const expectedCode = r'''
<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;

$uri = "https://api.apidash.dev/country/data";
$queryParams = [
 "code" => "US"
];
$uri .= '?' . http_build_query($queryParams);
$request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('GET', $uri);
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
              CodegenLanguage.phpHttpPlug, requestModelGet2, "https"),
          expectedCode);
    });
    test('GET3', () {
      const expectedCode = r'''
<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;

$uri = "https://api.apidash.dev/country/data";
$queryParams = [
 "code" => "IND"
];
$uri .= '?' . http_build_query($queryParams);
$request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('GET', $uri);
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
              CodegenLanguage.phpHttpPlug, requestModelGet3, "https"),
          expectedCode);
    });
    test('GET4', () {
      const expectedCode = r'''
<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;

$uri = "https://api.apidash.dev/humanize/social";
$queryParams = [
 "num" => "8700000",
 "digits" => "3",
 "system" => "SS",
 "add_space" => "true",
 "trailing_zeros" => "true"
];
$uri .= '?' . http_build_query($queryParams);
$request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('GET', $uri);
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
              CodegenLanguage.phpHttpPlug, requestModelGet4, "https"),
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
              CodegenLanguage.phpHttpPlug, requestModelGet5, "https"),
          expectedCode);
    });
    test('GET6', () {
      const expectedCode = r'''
<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;

$uri = "https://api.github.com/repos/foss42/apidash";
$queryParams = [
 "raw" => "true"
];
$uri .= '?' . http_build_query($queryParams);
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
              CodegenLanguage.phpHttpPlug, requestModelGet6, "https"),
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
              CodegenLanguage.phpHttpPlug, requestModelGet7, "https"),
          expectedCode);
    });
    test('GET8', () {
      const expectedCode = r'''
<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;

$uri = "https://api.github.com/repos/foss42/apidash";
$queryParams = [
 "raw" => "true"
];
$uri .= '?' . http_build_query($queryParams);
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
              CodegenLanguage.phpHttpPlug, requestModelGet8, "https"),
          expectedCode);
    });
    test('GET9', () {
      const expectedCode = r'''
<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;

$uri = "https://api.apidash.dev/humanize/social";
$queryParams = [
 "num" => "8700000",
 "add_space" => "true"
];
$uri .= '?' . http_build_query($queryParams);
$request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('GET', $uri);
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
              CodegenLanguage.phpHttpPlug, requestModelGet9, "https"),
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
              CodegenLanguage.phpHttpPlug, requestModelGet10, "https"),
          expectedCode);
    });
    test('GET11', () {
      const expectedCode = r'''
<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;

$uri = "https://api.apidash.dev/humanize/social";
$queryParams = [
 "num" => "8700000",
 "digits" => "3"
];
$uri .= '?' . http_build_query($queryParams);
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
              CodegenLanguage.phpHttpPlug, requestModelGet11, "https"),
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
              CodegenLanguage.phpHttpPlug, requestModelGet12, "https"),
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
              CodegenLanguage.phpHttpPlug, requestModelHead1, "https"),
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
              CodegenLanguage.phpHttpPlug, requestModelHead2, "http"),
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
              CodegenLanguage.phpHttpPlug, requestModelPost1, "https"),
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
              CodegenLanguage.phpHttpPlug, requestModelPost2, "https"),
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
              CodegenLanguage.phpHttpPlug, requestModelPost3, "https"),
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
              CodegenLanguage.phpHttpPlug, requestModelPost4, "https"),
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
              CodegenLanguage.phpHttpPlug, requestModelPost5, "https"),
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
              CodegenLanguage.phpHttpPlug, requestModelPost6, "https"),
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
              CodegenLanguage.phpHttpPlug, requestModelPost7, "https"),
          expectedCode);
    });
    test('POST8', () {
      const expectedCode = r'''
<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;
use Http\Message\MultipartStream\MultipartStreamBuilder;
$uri = "https://api.apidash.dev/io/form";
$queryParams = [
 "size" => "2",
 "len" => "3"
];
$uri .= '?' . http_build_query($queryParams);
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
              CodegenLanguage.phpHttpPlug, requestModelPost8, "https"),
          expectedCode);
    });
    test('POST9', () {
      const expectedCode = r'''
<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;
use Http\Message\MultipartStream\MultipartStreamBuilder;
$uri = "https://api.apidash.dev/io/img";
$queryParams = [
 "size" => "2",
 "len" => "3"
];
$uri .= '?' . http_build_query($queryParams);
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
              CodegenLanguage.phpHttpPlug, requestModelPost9, "https"),
          expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT1', () {
      const expectedCode = r'''
<?php
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
              CodegenLanguage.phpHttpPlug, requestModelPut1, "https"),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH1', () {
      const expectedCode = r'''
<?php
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
              CodegenLanguage.phpHttpPlug, requestModelPatch1, "https"),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE1', () {
      const expectedCode = r'''
<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;

$uri = "https://reqres.in/api/users/2";
$request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('DELETE', $uri);
$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
              CodegenLanguage.phpHttpPlug, requestModelDelete1, "https"),
          expectedCode);
    });
    test('DELETE2', () {
      const expectedCode = r'''
<?php
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
              CodegenLanguage.phpHttpPlug, requestModelDelete2, "https"),
          expectedCode);
    });
  });
}
