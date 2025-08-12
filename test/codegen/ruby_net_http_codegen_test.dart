import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';
import '../models/request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.apidash.dev")
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Get.new(url)
response = https.request(request)

puts "Response Code: #{response.code}"

puts "Response Body: #{response.body}"

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelGet1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.apidash.dev/country/data")

params = {
 "code" => ["US"],
}
url.query = URI.encode_www_form(params)
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Get.new(url)
response = https.request(request)

puts "Response Code: #{response.code}"

puts "Response Body: #{response.body}"

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelGet2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.apidash.dev/country/data")

params = {
 "code" => ["IND", "US"],
}
url.query = URI.encode_www_form(params)
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Get.new(url)
response = https.request(request)

puts "Response Code: #{response.code}"

puts "Response Body: #{response.body}"

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelGet3,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.apidash.dev/humanize/social")

params = {
 "num" => ["8700000"],
 "digits" => ["3"],
 "system" => ["SS"],
 "add_space" => ["true"],
 "trailing_zeros" => ["true"],
}
url.query = URI.encode_www_form(params)
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Get.new(url)
response = https.request(request)

puts "Response Code: #{response.code}"

puts "Response Body: #{response.body}"

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelGet4,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.github.com/repos/foss42/apidash")
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Get.new(url)
request["User-Agent"] = "Test Agent"

response = https.request(request)

puts "Response Code: #{response.code}"

puts "Response Body: #{response.body}"

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelGet5,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.github.com/repos/foss42/apidash")

params = {
 "raw" => ["true"],
}
url.query = URI.encode_www_form(params)
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Get.new(url)
request["User-Agent"] = "Test Agent"

response = https.request(request)

puts "Response Code: #{response.code}"

puts "Response Body: #{response.body}"

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelGet6,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.apidash.dev")
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Get.new(url)
response = https.request(request)

puts "Response Code: #{response.code}"

puts "Response Body: #{response.body}"

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelGet7,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.github.com/repos/foss42/apidash")

params = {
 "raw" => ["true"],
}
url.query = URI.encode_www_form(params)
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Get.new(url)
request["User-Agent"] = "Test Agent"

response = https.request(request)

puts "Response Code: #{response.code}"

puts "Response Body: #{response.body}"

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelGet8,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.apidash.dev/humanize/social")

params = {
 "num" => ["8700000"],
 "add_space" => ["true"],
}
url.query = URI.encode_www_form(params)
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Get.new(url)
response = https.request(request)

puts "Response Code: #{response.code}"

puts "Response Body: #{response.body}"

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelGet9,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.apidash.dev/humanize/social")
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Get.new(url)
request["User-Agent"] = "Test Agent"

response = https.request(request)

puts "Response Code: #{response.code}"

puts "Response Body: #{response.body}"

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelGet10,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.apidash.dev/humanize/social")

params = {
 "num" => ["8700000"],
 "digits" => ["3"],
}
url.query = URI.encode_www_form(params)
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Get.new(url)
request["User-Agent"] = "Test Agent"

response = https.request(request)

puts "Response Code: #{response.code}"

puts "Response Body: #{response.body}"

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelGet11,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.apidash.dev/humanize/social")
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Get.new(url)
response = https.request(request)

puts "Response Code: #{response.code}"

puts "Response Body: #{response.body}"

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelGet12,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.apidash.dev")
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Head.new(url)
response = https.request(request)

puts "Response Code: #{response.code}"

puts "Response Headers: #{response.to_hash}"

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelHead1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("http://api.apidash.dev")
https = Net::HTTP.new(url.host, url.port)

request = Net::HTTP::Head.new(url)
response = https.request(request)

puts "Response Code: #{response.code}"

puts "Response Headers: #{response.to_hash}"

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelHead2,
            SupportedUriSchemes.http,
          ),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.apidash.dev/case/lower")
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Post.new(url)
request["Content-Type"] = "text/plain"

request.body = <<HEREDOC
{
"text": "I LOVE Flutter"
}
HEREDOC

response = https.request(request)

puts "Response Code: #{response.code}"

puts "Response Body: #{response.body}"

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelPost1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.apidash.dev/case/lower")
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Post.new(url)
request["Content-Type"] = "application/json"

request.body = <<HEREDOC
{
"text": "I LOVE Flutter",
"flag": null,
"male": true,
"female": false,
"no": 1.2,
"arr": ["null", "true", "false", null]
}
HEREDOC

response = https.request(request)

puts "Response Code: #{response.code}"

puts "Response Body: #{response.body}"

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelPost2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.apidash.dev/case/lower")
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Post.new(url)
request["User-Agent"] = "Test Agent"

request["Content-Type"] = "application/json"

request.body = <<HEREDOC
{
"text": "I LOVE Flutter"
}
HEREDOC

response = https.request(request)

puts "Response Code: #{response.code}"

puts "Response Body: #{response.body}"

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelPost3,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST 4', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.apidash.dev/io/form")
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Post.new(url)
form_data = [["text", "API"], ["sep", "|"], ["times", "3"]]
request.set_form form_data, 'multipart/form-data'

response = https.request(request)

puts "Response Code: #{response.code}"

puts "Response Body: #{response.body}"

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelPost4,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('POST 5', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.apidash.dev/io/form")
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Post.new(url)
request["User-Agent"] = "Test Agent"

form_data = [["text", "API"], ["sep", "|"], ["times", "3"]]
request.set_form form_data, 'multipart/form-data'

response = https.request(request)

puts "Response Code: #{response.code}"

puts "Response Body: #{response.body}"

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelPost5,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST 6', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.apidash.dev/io/img")
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Post.new(url)
form_data = [["token", "xyz"], ["imfile", File.open("/Documents/up/1.png")]]
request.set_form form_data, 'multipart/form-data'

response = https.request(request)

puts "Response Code: #{response.code}"

puts "Response Body: #{response.body}"

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelPost6,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST 7', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.apidash.dev/io/img")
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Post.new(url)
form_data = [["token", "xyz"], ["imfile", File.open("/Documents/up/1.png")]]
request.set_form form_data, 'multipart/form-data'

response = https.request(request)

puts "Response Code: #{response.code}"

puts "Response Body: #{response.body}"

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelPost7,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST 8', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.apidash.dev/io/form")

params = {
 "size" => ["2"],
 "len" => ["3"],
}
url.query = URI.encode_www_form(params)
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Post.new(url)
form_data = [["text", "API"], ["sep", "|"], ["times", "3"]]
request.set_form form_data, 'multipart/form-data'

response = https.request(request)

puts "Response Code: #{response.code}"

puts "Response Body: #{response.body}"

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelPost8,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST 9', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.apidash.dev/io/img")

params = {
 "size" => ["2"],
 "len" => ["3"],
}
url.query = URI.encode_www_form(params)
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Post.new(url)
request["User-Agent"] = "Test Agent"

request["Keep-Alive"] = "true"

form_data = [["token", "xyz"], ["imfile", File.open("/Documents/up/1.png")]]
request.set_form form_data, 'multipart/form-data'

response = https.request(request)

puts "Response Code: #{response.code}"

puts "Response Body: #{response.body}"

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelPost9,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://reqres.in/api/users/2")
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Put.new(url)
request["x-api-key"] = "reqres-free-v1"

request["Content-Type"] = "application/json"

request.body = <<HEREDOC
{
"name": "morpheus",
"job": "zion resident"
}
HEREDOC

response = https.request(request)

puts "Response Code: #{response.code}"

puts "Response Body: #{response.body}"

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelPut1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://reqres.in/api/users/2")
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Patch.new(url)
request["x-api-key"] = "reqres-free-v1"

request["Content-Type"] = "application/json"

request.body = <<HEREDOC
{
"name": "marfeus",
"job": "accountant"
}
HEREDOC

response = https.request(request)

puts "Response Code: #{response.code}"

puts "Response Body: #{response.body}"

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelPatch1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://reqres.in/api/users/2")
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Delete.new(url)
request["x-api-key"] = "reqres-free-v1"

response = https.request(request)

puts "Response Code: #{response.code}"

puts "Response Body: #{response.body}"

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelDelete1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://reqres.in/api/users/2")
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Delete.new(url)
request["x-api-key"] = "reqres-free-v1"

request["Content-Type"] = "application/json"

request.body = <<HEREDOC
{
"name": "marfeus",
"job": "accountant"
}
HEREDOC

response = https.request(request)

puts "Response Code: #{response.code}"

puts "Response Body: #{response.body}"

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelDelete2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });
}
