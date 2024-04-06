import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:test/test.dart';
import '../request_models.dart';

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
$headers = [
				'Content-Type' => 'text/plain', 
];
foreach ($headers as $name => $value) {
    $request = $request->withHeader($name, $value);
}
$request = $request->withBody(Psr17FactoryDiscovery::findStreamFactory()->createStream($body));

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
$headers = [
				'Content-Type' => 'application/json', 
];
foreach ($headers as $name => $value) {
    $request = $request->withHeader($name, $value);
}
$request = $request->withBody(Psr17FactoryDiscovery::findStreamFactory()->createStream($body));

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
$headers = [
				'Content-Type' => 'application/json', 
				'User-Agent' => 'Test Agent', 
];
foreach ($headers as $name => $value) {
    $request = $request->withHeader($name, $value);
}
$request = $request->withBody(Psr17FactoryDiscovery::findStreamFactory()->createStream($body));

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
function build_data($boundary, $fields)
{
    $data = '';
    $eol = "\r\n";
    $delimiter = $boundary;

    foreach ($fields as $name => $content) {
        $data .= "--" . $delimiter . $eol
            . 'Content-Disposition: form-data; name="' . $name . "\"" . $eol . $eol
            . $content . $eol;
    }

    $data .= "--" . $delimiter . "--" . $eol;

    return $data;
}

$uri = "https://api.apidash.dev/io/form";
$request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('POST', $uri);
$boundary = "b9826c20-773c-1f0c-814d-a1b3d90cd6b3";
$fields = [
 "text" => "API",
 "sep" => "|",
 "times" => "3",
];
$body = build_data($boundary, $fields);

$headers = [
				'Content-Type' => 'multipart/form-data; boundary=b9826c20-773c-1f0c-814d-a1b3d90cd6b3', 
];
foreach ($headers as $name => $value) {
    $request = $request->withHeader($name, $value);
}
$request = $request->withBody(Psr17FactoryDiscovery::findStreamFactory()->createStream($body));

$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
              CodegenLanguage.phpHttpPlug, requestModelPost4, "https", boundary: "b9826c20-773c-1f0c-814d-a1b3d90cd6b3"),
          expectedCode);
    });
    test('POST5', () {
      const expectedCode = r'''
<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;
function build_data($boundary, $fields)
{
    $data = '';
    $eol = "\r\n";
    $delimiter = $boundary;

    foreach ($fields as $name => $content) {
        $data .= "--" . $delimiter . $eol
            . 'Content-Disposition: form-data; name="' . $name . "\"" . $eol . $eol
            . $content . $eol;
    }

    $data .= "--" . $delimiter . "--" . $eol;

    return $data;
}

$uri = "https://api.apidash.dev/io/form";
$request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('POST', $uri);
$boundary = "b9826c20-773c-1f0c-814d-a1b3d90cd6b3";
$fields = [
 "text" => "API",
 "sep" => "|",
 "times" => "3",
];
$body = build_data($boundary, $fields);

$headers = [
				'Content-Type' => 'multipart/form-data; boundary=b9826c20-773c-1f0c-814d-a1b3d90cd6b3', 
				'User-Agent' => 'Test Agent', 
];
foreach ($headers as $name => $value) {
    $request = $request->withHeader($name, $value);
}
$request = $request->withBody(Psr17FactoryDiscovery::findStreamFactory()->createStream($body));

$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
              CodegenLanguage.phpHttpPlug, requestModelPost5, "https", boundary: "b9826c20-773c-1f0c-814d-a1b3d90cd6b3"),
          expectedCode);
    });
    test('POST6', () {
      const expectedCode = r'''
<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;
class File
{
    public string $name;
    public string $filename;
    public string $content;

    function __construct($name, $filename)
    {
        $this->name = $name;
        $this->filename = $filename;
        $available_content = file_get_contents($this->filename);
        $this->content = $available_content ? $available_content : "";
    }
}

function build_data_files($boundary, $fields, $files)
{
    $data = '';
    $eol = "\r\n";
    $delimiter = $boundary;

    foreach ($fields as $name => $content) {
        $data .= "--" . $delimiter . $eol
            . 'Content-Disposition: form-data; name="' . $name . "\"" . $eol . $eol
            . $content . $eol;
    }

    foreach ($files as $uploaded_file) {
        if ($uploaded_file instanceof File) {
            $data .= "--" . $delimiter . $eol
                . 'Content-Disposition: form-data; name="' . $uploaded_file->name . '"; filename="' . $uploaded_file->filename . '"' . $eol
                . 'Content-Transfer-Encoding: binary' . $eol;
            $data .= $eol;
            $data .= $uploaded_file->content . $eol;
        }
    }

    $data .= "--" . $delimiter . "--" . $eol;

    return $data;
}

$uri = "https://api.apidash.dev/io/img";
$request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('POST', $uri);
$boundary = "b9826c20-773c-1f0c-814d-a1b3d90cd6b3";
$fields = [
 "token" => "xyz",
];
$files = [
 new File("imfile", "/Documents/up/1.png"),
];
$body = build_data_files($boundary, $fields, $files);

$headers = [
				'Content-Type' => 'multipart/form-data; boundary=b9826c20-773c-1f0c-814d-a1b3d90cd6b3', 
];
foreach ($headers as $name => $value) {
    $request = $request->withHeader($name, $value);
}
$request = $request->withBody(Psr17FactoryDiscovery::findStreamFactory()->createStream($body));

$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
              CodegenLanguage.phpHttpPlug, requestModelPost6, "https", boundary: "b9826c20-773c-1f0c-814d-a1b3d90cd6b3"),
          expectedCode);
    });
    test('POST7', () {
      const expectedCode = r'''
<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;
class File
{
    public string $name;
    public string $filename;
    public string $content;

    function __construct($name, $filename)
    {
        $this->name = $name;
        $this->filename = $filename;
        $available_content = file_get_contents($this->filename);
        $this->content = $available_content ? $available_content : "";
    }
}

function build_data_files($boundary, $fields, $files)
{
    $data = '';
    $eol = "\r\n";
    $delimiter = $boundary;

    foreach ($fields as $name => $content) {
        $data .= "--" . $delimiter . $eol
            . 'Content-Disposition: form-data; name="' . $name . "\"" . $eol . $eol
            . $content . $eol;
    }

    foreach ($files as $uploaded_file) {
        if ($uploaded_file instanceof File) {
            $data .= "--" . $delimiter . $eol
                . 'Content-Disposition: form-data; name="' . $uploaded_file->name . '"; filename="' . $uploaded_file->filename . '"' . $eol
                . 'Content-Transfer-Encoding: binary' . $eol;
            $data .= $eol;
            $data .= $uploaded_file->content . $eol;
        }
    }

    $data .= "--" . $delimiter . "--" . $eol;

    return $data;
}

$uri = "https://api.apidash.dev/io/img";
$request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('POST', $uri);
$boundary = "b9826c20-773c-1f0c-814d-a1b3d90cd6b3";
$fields = [
 "token" => "xyz",
];
$files = [
 new File("imfile", "/Documents/up/1.png"),
];
$body = build_data_files($boundary, $fields, $files);

$headers = [
				'Content-Type' => 'multipart/form-data; boundary=b9826c20-773c-1f0c-814d-a1b3d90cd6b3', 
];
foreach ($headers as $name => $value) {
    $request = $request->withHeader($name, $value);
}
$request = $request->withBody(Psr17FactoryDiscovery::findStreamFactory()->createStream($body));

$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
              CodegenLanguage.phpHttpPlug, requestModelPost7, "https", boundary: "b9826c20-773c-1f0c-814d-a1b3d90cd6b3"),
          expectedCode);
    });
    test('POST8', () {
      const expectedCode = r'''
<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;
function build_data($boundary, $fields)
{
    $data = '';
    $eol = "\r\n";
    $delimiter = $boundary;

    foreach ($fields as $name => $content) {
        $data .= "--" . $delimiter . $eol
            . 'Content-Disposition: form-data; name="' . $name . "\"" . $eol . $eol
            . $content . $eol;
    }

    $data .= "--" . $delimiter . "--" . $eol;

    return $data;
}

$uri = "https://api.apidash.dev/io/form";
$queryParams = [
 "size" => "2",
 "len" => "3"
];
$uri .= '?' . http_build_query($queryParams);
$request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('POST', $uri);
$boundary = "b9826c20-773c-1f0c-814d-a1b3d90cd6b3";
$fields = [
 "text" => "API",
 "sep" => "|",
 "times" => "3",
];
$body = build_data($boundary, $fields);

$headers = [
				'Content-Type' => 'multipart/form-data; boundary=b9826c20-773c-1f0c-814d-a1b3d90cd6b3', 
];
foreach ($headers as $name => $value) {
    $request = $request->withHeader($name, $value);
}
$request = $request->withBody(Psr17FactoryDiscovery::findStreamFactory()->createStream($body));

$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
              CodegenLanguage.phpHttpPlug, requestModelPost8, "https", boundary: "b9826c20-773c-1f0c-814d-a1b3d90cd6b3"),
          expectedCode);
    });
    test('POST9', () {
      const expectedCode = r'''
<?php
require_once 'vendor/autoload.php';

use Http\Discovery\Psr17FactoryDiscovery;
use Http\Discovery\Psr18ClientDiscovery;
class File
{
    public string $name;
    public string $filename;
    public string $content;

    function __construct($name, $filename)
    {
        $this->name = $name;
        $this->filename = $filename;
        $available_content = file_get_contents($this->filename);
        $this->content = $available_content ? $available_content : "";
    }
}

function build_data_files($boundary, $fields, $files)
{
    $data = '';
    $eol = "\r\n";
    $delimiter = $boundary;

    foreach ($fields as $name => $content) {
        $data .= "--" . $delimiter . $eol
            . 'Content-Disposition: form-data; name="' . $name . "\"" . $eol . $eol
            . $content . $eol;
    }

    foreach ($files as $uploaded_file) {
        if ($uploaded_file instanceof File) {
            $data .= "--" . $delimiter . $eol
                . 'Content-Disposition: form-data; name="' . $uploaded_file->name . '"; filename="' . $uploaded_file->filename . '"' . $eol
                . 'Content-Transfer-Encoding: binary' . $eol;
            $data .= $eol;
            $data .= $uploaded_file->content . $eol;
        }
    }

    $data .= "--" . $delimiter . "--" . $eol;

    return $data;
}

$uri = "https://api.apidash.dev/io/img";
$queryParams = [
 "size" => "2",
 "len" => "3"
];
$uri .= '?' . http_build_query($queryParams);
$request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('POST', $uri);
$boundary = "b9826c20-773c-1f0c-814d-a1b3d90cd6b3";
$fields = [
 "token" => "xyz",
];
$files = [
 new File("imfile", "/Documents/up/1.png"),
];
$body = build_data_files($boundary, $fields, $files);

$headers = [
				'Content-Type' => 'multipart/form-data; boundary=b9826c20-773c-1f0c-814d-a1b3d90cd6b3', 
				'User-Agent' => 'Test Agent', 
				'Keep-Alive' => 'true', 
];
foreach ($headers as $name => $value) {
    $request = $request->withHeader($name, $value);
}
$request = $request->withBody(Psr17FactoryDiscovery::findStreamFactory()->createStream($body));

$client = Psr18ClientDiscovery::find();
$response = $client->sendRequest($request);

echo $response->getStatusCode() . " " . $response->getReasonPhrase() . "\n";
echo $response->getBody();

''';
      expect(
          codeGen.getCode(
              CodegenLanguage.phpHttpPlug, requestModelPost9, "https", boundary: "b9826c20-773c-1f0c-814d-a1b3d90cd6b3"),
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
$headers = [
				'Content-Type' => 'application/json', 
];
foreach ($headers as $name => $value) {
    $request = $request->withHeader($name, $value);
}
$request = $request->withBody(Psr17FactoryDiscovery::findStreamFactory()->createStream($body));

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
$headers = [
				'Content-Type' => 'application/json', 
];
foreach ($headers as $name => $value) {
    $request = $request->withHeader($name, $value);
}
$request = $request->withBody(Psr17FactoryDiscovery::findStreamFactory()->createStream($body));

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
$headers = [
				'Content-Type' => 'application/json', 
];
foreach ($headers as $name => $value) {
    $request = $request->withHeader($name, $value);
}
$request = $request->withBody(Psr17FactoryDiscovery::findStreamFactory()->createStream($body));

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
