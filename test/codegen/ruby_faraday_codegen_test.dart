import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';
import '../models/request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""require 'uri'
require 'faraday'

REQUEST_URL = URI("https://api.apidash.dev")

conn = Faraday.new do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get(REQUEST_URL) do |req|
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyFaraday,
            requestModelGet1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""require 'uri'
require 'faraday'

REQUEST_URL = URI("https://api.apidash.dev/country/data")

conn = Faraday.new do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get(REQUEST_URL) do |req|
  req.params = {
    "code" => "US",
  }
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyFaraday,
            requestModelGet2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""require 'uri'
require 'faraday'

REQUEST_URL = URI("https://api.apidash.dev/country/data")

conn = Faraday.new do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get(REQUEST_URL) do |req|
  req.params = {
    "code" => "IND",
  }
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyFaraday,
            requestModelGet3,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r"""require 'uri'
require 'faraday'

REQUEST_URL = URI("https://api.apidash.dev/humanize/social")

conn = Faraday.new do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get(REQUEST_URL) do |req|
  req.params = {
    "num" => "8700000",
    "digits" => "3",
    "system" => "SS",
    "add_space" => "true",
    "trailing_zeros" => "true",
  }
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyFaraday,
            requestModelGet4,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r"""require 'uri'
require 'faraday'

REQUEST_URL = URI("https://api.github.com/repos/foss42/apidash")

conn = Faraday.new do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get(REQUEST_URL) do |req|
  req.headers = {
    "User-Agent" => "Test Agent",
  }
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyFaraday,
            requestModelGet5,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r"""require 'uri'
require 'faraday'

REQUEST_URL = URI("https://api.github.com/repos/foss42/apidash")

conn = Faraday.new do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get(REQUEST_URL) do |req|
  req.headers = {
    "User-Agent" => "Test Agent",
  }
  req.params = {
    "raw" => "true",
  }
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyFaraday,
            requestModelGet6,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""require 'uri'
require 'faraday'

REQUEST_URL = URI("https://api.apidash.dev")

conn = Faraday.new do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get(REQUEST_URL) do |req|
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyFaraday,
            requestModelGet7,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r"""require 'uri'
require 'faraday'

REQUEST_URL = URI("https://api.github.com/repos/foss42/apidash")

conn = Faraday.new do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get(REQUEST_URL) do |req|
  req.headers = {
    "User-Agent" => "Test Agent",
  }
  req.params = {
    "raw" => "true",
  }
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyFaraday,
            requestModelGet8,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""require 'uri'
require 'faraday'

REQUEST_URL = URI("https://api.apidash.dev/humanize/social")

conn = Faraday.new do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get(REQUEST_URL) do |req|
  req.params = {
    "num" => "8700000",
    "add_space" => "true",
  }
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyFaraday,
            requestModelGet9,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""require 'uri'
require 'faraday'

REQUEST_URL = URI("https://api.apidash.dev/humanize/social")

conn = Faraday.new do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get(REQUEST_URL) do |req|
  req.headers = {
    "User-Agent" => "Test Agent",
  }
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyFaraday,
            requestModelGet10,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""require 'uri'
require 'faraday'

REQUEST_URL = URI("https://api.apidash.dev/humanize/social")

conn = Faraday.new do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get(REQUEST_URL) do |req|
  req.headers = {
    "User-Agent" => "Test Agent",
  }
  req.params = {
    "num" => "8700000",
    "digits" => "3",
  }
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyFaraday,
            requestModelGet11,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""require 'uri'
require 'faraday'

REQUEST_URL = URI("https://api.apidash.dev/humanize/social")

conn = Faraday.new do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get(REQUEST_URL) do |req|
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyFaraday,
            requestModelGet12,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""require 'uri'
require 'faraday'

REQUEST_URL = URI("https://api.apidash.dev")

conn = Faraday.new do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.head(REQUEST_URL) do |req|
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyFaraday,
            requestModelHead1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""require 'uri'
require 'faraday'

REQUEST_URL = URI("http://api.apidash.dev")

conn = Faraday.new do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.head(REQUEST_URL) do |req|
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyFaraday,
            requestModelHead2,
            SupportedUriSchemes.http,
          ),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r"""require 'uri'
require 'faraday'

REQUEST_URL = URI("https://api.apidash.dev/case/lower")

PAYLOAD = <<HEREDOC
{
"text": "I LOVE Flutter"
}
HEREDOC

conn = Faraday.new do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.post(REQUEST_URL, PAYLOAD) do |req|
  req.headers = {
    "Content-Type" => "text/plain",
  }
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyFaraday,
            requestModelPost1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r"""require 'uri'
require 'faraday'

REQUEST_URL = URI("https://api.apidash.dev/case/lower")

PAYLOAD = <<HEREDOC
{
"text": "I LOVE Flutter",
"flag": null,
"male": true,
"female": false,
"no": 1.2,
"arr": ["null", "true", "false", null]
}
HEREDOC

conn = Faraday.new do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.post(REQUEST_URL, PAYLOAD) do |req|
  req.headers = {
    "Content-Type" => "application/json",
  }
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyFaraday,
            requestModelPost2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r"""require 'uri'
require 'faraday'

REQUEST_URL = URI("https://api.apidash.dev/case/lower")

PAYLOAD = <<HEREDOC
{
"text": "I LOVE Flutter"
}
HEREDOC

conn = Faraday.new do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.post(REQUEST_URL, PAYLOAD) do |req|
  req.headers = {
    "User-Agent" => "Test Agent",
    "Content-Type" => "application/json",
  }
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyFaraday,
            requestModelPost3,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('POST 4', () {
      const expectedCode = r"""require 'uri'
require 'faraday'

REQUEST_URL = URI("https://api.apidash.dev/io/form")

PAYLOAD = URI.encode_www_form({
  "text" => "API",
  "sep" => "|",
  "times" => "3",
})

conn = Faraday.new do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.post(REQUEST_URL, PAYLOAD) do |req|
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyFaraday,
            requestModelPost4,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST 5', () {
      const expectedCode = r"""require 'uri'
require 'faraday'

REQUEST_URL = URI("https://api.apidash.dev/io/form")

PAYLOAD = URI.encode_www_form({
  "text" => "API",
  "sep" => "|",
  "times" => "3",
})

conn = Faraday.new do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.post(REQUEST_URL, PAYLOAD) do |req|
  req.headers = {
    "User-Agent" => "Test Agent",
  }
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyFaraday,
            requestModelPost5,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST 6', () {
      const expectedCode = r"""require 'uri'
require 'faraday'
require 'faraday/multipart'

REQUEST_URL = URI("https://api.apidash.dev/io/img")

PAYLOAD = {
  "token" => Faraday::Multipart::ParamPart.new("xyz", "text/plain"),
  "imfile" => Faraday::Multipart::FilePart.new("/Documents/up/1.png", "application/octet-stream"),
}

conn = Faraday.new do |faraday|
  faraday.adapter Faraday.default_adapter
  faraday.request :multipart
end

response = conn.post(REQUEST_URL, PAYLOAD) do |req|
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyFaraday,
            requestModelPost6,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST 7', () {
      const expectedCode = r"""require 'uri'
require 'faraday'
require 'faraday/multipart'

REQUEST_URL = URI("https://api.apidash.dev/io/img")

PAYLOAD = {
  "token" => Faraday::Multipart::ParamPart.new("xyz", "text/plain"),
  "imfile" => Faraday::Multipart::FilePart.new("/Documents/up/1.png", "application/octet-stream"),
}

conn = Faraday.new do |faraday|
  faraday.adapter Faraday.default_adapter
  faraday.request :multipart
end

response = conn.post(REQUEST_URL, PAYLOAD) do |req|
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyFaraday,
            requestModelPost7,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST 8', () {
      const expectedCode = r"""require 'uri'
require 'faraday'

REQUEST_URL = URI("https://api.apidash.dev/io/form")

PAYLOAD = URI.encode_www_form({
  "text" => "API",
  "sep" => "|",
  "times" => "3",
})

conn = Faraday.new do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.post(REQUEST_URL, PAYLOAD) do |req|
  req.params = {
    "size" => "2",
    "len" => "3",
  }
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyFaraday,
            requestModelPost8,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST 9', () {
      const expectedCode = r"""require 'uri'
require 'faraday'
require 'faraday/multipart'

REQUEST_URL = URI("https://api.apidash.dev/io/img")

PAYLOAD = {
  "token" => Faraday::Multipart::ParamPart.new("xyz", "text/plain"),
  "imfile" => Faraday::Multipart::FilePart.new("/Documents/up/1.png", "application/octet-stream"),
}

conn = Faraday.new do |faraday|
  faraday.adapter Faraday.default_adapter
  faraday.request :multipart
end

response = conn.post(REQUEST_URL, PAYLOAD) do |req|
  req.headers = {
    "User-Agent" => "Test Agent",
    "Keep-Alive" => "true",
  }
  req.params = {
    "size" => "2",
    "len" => "3",
  }
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyFaraday,
            requestModelPost9,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r"""require 'uri'
require 'faraday'

REQUEST_URL = URI("https://reqres.in/api/users/2")

PAYLOAD = <<HEREDOC
{
"name": "morpheus",
"job": "zion resident"
}
HEREDOC

conn = Faraday.new do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.put(REQUEST_URL, PAYLOAD) do |req|
  req.headers = {
    "Content-Type" => "application/json",
  }
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyFaraday,
            requestModelPut1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r"""require 'uri'
require 'faraday'

REQUEST_URL = URI("https://reqres.in/api/users/2")

PAYLOAD = <<HEREDOC
{
"name": "marfeus",
"job": "accountant"
}
HEREDOC

conn = Faraday.new do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.patch(REQUEST_URL, PAYLOAD) do |req|
  req.headers = {
    "Content-Type" => "application/json",
  }
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyFaraday,
            requestModelPatch1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""require 'uri'
require 'faraday'

REQUEST_URL = URI("https://reqres.in/api/users/2")

conn = Faraday.new do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.delete(REQUEST_URL) do |req|
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyFaraday,
            requestModelDelete1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r"""require 'uri'
require 'faraday'

REQUEST_URL = URI("https://reqres.in/api/users/2")

PAYLOAD = <<HEREDOC
{
"name": "marfeus",
"job": "accountant"
}
HEREDOC

conn = Faraday.new do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.delete(REQUEST_URL) do |req|
  req.headers = {
    "Content-Type" => "application/json",
  }
  req.body = PAYLOAD
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyFaraday,
            requestModelDelete2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });
}
