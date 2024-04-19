import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
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
              CodegenLanguage.rubyNetHttp, requestModelGet1, "https"),
          expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.apidash.dev/country/data?code=US")
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Get.new(url)
response = https.request(request)

puts "Response Code: #{response.code}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyNetHttp, requestModelGet2, "https"),
          expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.apidash.dev/country/data?code=IND")
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Get.new(url)
response = https.request(request)

puts "Response Code: #{response.code}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyNetHttp, requestModelGet3, "https"),
          expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.apidash.dev/humanize/social?num=8700000&digits=3&system=SS&add_space=true&trailing_zeros=true")
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Get.new(url)
response = https.request(request)

puts "Response Code: #{response.code}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyNetHttp, requestModelGet4, "https"),
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
              CodegenLanguage.rubyNetHttp, requestModelGet5, "https"),
          expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.github.com/repos/foss42/apidash?raw=true")
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
              CodegenLanguage.rubyNetHttp, requestModelGet6, "https"),
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
              CodegenLanguage.rubyNetHttp, requestModelGet7, "https"),
          expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.github.com/repos/foss42/apidash?raw=true")
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
              CodegenLanguage.rubyNetHttp, requestModelGet8, "https"),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.apidash.dev/humanize/social?num=8700000&add_space=true")
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Get.new(url)
response = https.request(request)

puts "Response Code: #{response.code}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyNetHttp, requestModelGet9, "https"),
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
            "https",
          ),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.apidash.dev/humanize/social?num=8700000&digits=3")
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
              CodegenLanguage.rubyNetHttp, requestModelGet11, "https"),
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
              CodegenLanguage.rubyNetHttp, requestModelGet12, "https"),
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
puts "Response Body: #{response.to_hash}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyNetHttp, requestModelHead1, "https"),
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
puts "Response Body: #{response.to_hash}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyNetHttp, requestModelHead2, "http"),
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
              CodegenLanguage.rubyNetHttp, requestModelPost1, "https"),
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
              CodegenLanguage.rubyNetHttp, requestModelPost2, "https"),
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
              CodegenLanguage.rubyNetHttp, requestModelPost3, "https"),
          expectedCode);
    });
    test('POST 4', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.apidash.dev/io/form")
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Post.new(url)
form_data = [["text", "API"],["sep", "|"],["times", "3"]]
request.set_form form_data, 'multipart/form-data'
response = https.request(request)

puts "Response Code: #{response.code}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelPost4,
            "https",
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
form_data = [["text", "API"],["sep", "|"],["times", "3"]]
request.set_form form_data, 'multipart/form-data'
response = https.request(request)

puts "Response Code: #{response.code}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelPost5,
            "https",
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
form_data = [["token", "xyz"],["imfile", File.open("/Documents/up/1.png")]]
request.set_form form_data, 'multipart/form-data'
response = https.request(request)

puts "Response Code: #{response.code}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelPost6,
            "https",
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
form_data = [["token", "xyz"],["imfile", File.open("/Documents/up/1.png")]]
request.set_form form_data, 'multipart/form-data'
response = https.request(request)

puts "Response Code: #{response.code}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelPost7,
            "https",
          ),
          expectedCode);
    });
    test('POST 8', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.apidash.dev/io/form?size=2&len=3")
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Post.new(url)
form_data = [["text", "API"],["sep", "|"],["times", "3"]]
request.set_form form_data, 'multipart/form-data'
response = https.request(request)

puts "Response Code: #{response.code}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelPost8,
            "https",
          ),
          expectedCode);
    });
    test('POST 9', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://api.apidash.dev/io/img?size=2&len=3")
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Post.new(url)
request["User-Agent"] = "Test Agent"
request["Keep-Alive"] = "true"
form_data = [["token", "xyz"],["imfile", File.open("/Documents/up/1.png")]]
request.set_form form_data, 'multipart/form-data'
response = https.request(request)

puts "Response Code: #{response.code}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyNetHttp,
            requestModelPost9,
            "https",
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
              CodegenLanguage.rubyNetHttp, requestModelPut1, "https"),
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
              CodegenLanguage.rubyNetHttp, requestModelPatch1, "https"),
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
response = https.request(request)

puts "Response Code: #{response.code}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyNetHttp, requestModelDelete1, "https"),
          expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r"""require "uri"
require "net/http"

url = URI("https://reqres.in/api/users/2")
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Delete.new(url)
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
              CodegenLanguage.rubyNetHttp, requestModelDelete2, "https"),
          expectedCode);
    });
  });
}
