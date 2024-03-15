import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:test/test.dart';
import '../request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""require 'faraday'

conn = Faraday.new(url: "https://api.apidash.dev") do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get do |req|
  req.url "" 
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyFaraday, requestModelGet1, "https"),
          expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""require 'faraday'
require 'uri'

queryParams = {
  "code" => "US"
}
queryParamsStr = '?' + URI.encode_www_form(queryParams)

conn = Faraday.new(url: "https://api.apidash.dev") do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get do |req|
  req.url "/country/data"  + queryParamsStr
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyFaraday, requestModelGet2, "https"),
          expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""require 'faraday'
require 'uri'

queryParams = {
  "code" => "IND"
}
queryParamsStr = '?' + URI.encode_www_form(queryParams)

conn = Faraday.new(url: "https://api.apidash.dev") do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get do |req|
  req.url "/country/data"  + queryParamsStr
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyFaraday, requestModelGet3, "https"),
          expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r"""require 'faraday'
require 'uri'

queryParams = {
  "num" => "8700000",
  "digits" => "3",
  "system" => "SS",
  "add_space" => "true",
  "trailing_zeros" => "true"
}
queryParamsStr = '?' + URI.encode_www_form(queryParams)

conn = Faraday.new(url: "https://api.apidash.dev") do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get do |req|
  req.url "/humanize/social"  + queryParamsStr
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyFaraday, requestModelGet4, "https"),
          expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r"""require 'faraday'
headers = {
  "User-Agent" => "Test Agent"
}

conn = Faraday.new(url: "https://api.github.com") do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get do |req|
  req.url "/repos/foss42/apidash" 
  req.headers = headers
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyFaraday, requestModelGet5, "https"),
          expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r"""require 'faraday'
require 'uri'

queryParams = {
  "raw" => "true"
}
queryParamsStr = '?' + URI.encode_www_form(queryParams)
headers = {
  "User-Agent" => "Test Agent"
}

conn = Faraday.new(url: "https://api.github.com") do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get do |req|
  req.url "/repos/foss42/apidash"  + queryParamsStr
  req.headers = headers
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyFaraday, requestModelGet6, "https"),
          expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""require 'faraday'

conn = Faraday.new(url: "https://api.apidash.dev") do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get do |req|
  req.url "" 
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyFaraday, requestModelGet7, "https"),
          expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r"""require 'faraday'
require 'uri'

queryParams = {
  "raw" => "true"
}
queryParamsStr = '?' + URI.encode_www_form(queryParams)
headers = {
  "User-Agent" => "Test Agent"
}

conn = Faraday.new(url: "https://api.github.com") do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get do |req|
  req.url "/repos/foss42/apidash"  + queryParamsStr
  req.headers = headers
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyFaraday, requestModelGet8, "https"),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""require 'faraday'
require 'uri'

queryParams = {
  "num" => "8700000",
  "add_space" => "true"
}
queryParamsStr = '?' + URI.encode_www_form(queryParams)

conn = Faraday.new(url: "https://api.apidash.dev") do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get do |req|
  req.url "/humanize/social"  + queryParamsStr
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyFaraday, requestModelGet9, "https"),
          expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""require 'faraday'
headers = {
  "User-Agent" => "Test Agent"
}

conn = Faraday.new(url: "https://api.apidash.dev") do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get do |req|
  req.url "/humanize/social" 
  req.headers = headers
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rubyFaraday,
            requestModelGet10,
            "https",
          ),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""require 'faraday'
require 'uri'

queryParams = {
  "num" => "8700000",
  "digits" => "3"
}
queryParamsStr = '?' + URI.encode_www_form(queryParams)
headers = {
  "User-Agent" => "Test Agent"
}

conn = Faraday.new(url: "https://api.apidash.dev") do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get do |req|
  req.url "/humanize/social"  + queryParamsStr
  req.headers = headers
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyFaraday, requestModelGet11, "https"),
          expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""require 'faraday'

conn = Faraday.new(url: "https://api.apidash.dev") do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get do |req|
  req.url "/humanize/social" 
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyFaraday, requestModelGet12, "https"),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""require 'faraday'

conn = Faraday.new(url: "https://api.apidash.dev") do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.head do |req|
  req.url "" 
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyFaraday, requestModelHead1, "https"),
          expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""require 'faraday'

conn = Faraday.new(url: "http://api.apidash.dev") do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.head do |req|
  req.url "" 
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyFaraday, requestModelHead2, "http"),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r"""require 'faraday'

body = '{
"text": "I LOVE Flutter"
}'
headers = {
  "content-type" => "text/plain"
}

conn = Faraday.new(url: "https://api.apidash.dev") do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.post do |req|
  req.url "/case/lower" 


  req.body = body
  req.headers = headers
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyFaraday, requestModelPost1, "https"),
          expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r"""require 'faraday'

body = '{
"text": "I LOVE Flutter",
"flag": null,
"male": true,
"female": false,
"no": 1.2,
"arr": ["null", "true", "false", null]
}'
headers = {
  "content-type" => "application/json"
}

conn = Faraday.new(url: "https://api.apidash.dev") do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.post do |req|
  req.url "/case/lower" 


  req.body = body
  req.headers = headers
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyFaraday, requestModelPost2, "https"),
          expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r"""require 'faraday'

body = '{
"text": "I LOVE Flutter"
}'
headers = {
  "User-Agent" => "Test Agent",
  "content-type" => "application/json"
}

conn = Faraday.new(url: "https://api.apidash.dev") do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.post do |req|
  req.url "/case/lower" 


  req.body = body
  req.headers = headers
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyFaraday, requestModelPost3, "https",boundary: "test"),
          expectedCode);
    });

    test('POST 4', () {
      const expectedCode = r"""require 'faraday'
require 'base64'
headers = {
  "content-type" => "multipart/form-data; boundary=test"
}
def build_form_data(fields,boundary)
  data = ''

  fields.each do |field|
    data += "--#{boundary}\r\n"
    data += "Content-Disposition: form-data; name=\"#{field['name']}\""

    if field['type'] == 'file'
      file_content = File.read(field['value'])
      encoded_file = Base64.strict_encode64(file_content)

      data += "; filename=\"#{File.basename(field['value'])}\"\r\n"
      data += "Content-Type: application/octet-stream\r\n\r\n"
      data += "#{encoded_file}\r\n"
    else
      data += "\r\n\r\n#{field['value']}\r\n"
    end
  end

  data += "--#{boundary}--\r\n"
  data
end
fields_list = [{"name" =>"text","value" =>"API","type" =>"text"},{"name" =>"sep","value" =>"|","type" =>"text"},{"name" =>"times","value" =>"3","type" =>"text"}]
boundary = "test"
body = build_form_data(fields_list,boundary)

conn = Faraday.new(url: "https://api.apidash.dev") do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.post do |req|
  req.url "/io/form" 


  req.body = body
  req.headers = headers
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyFaraday, requestModelPost4, "https",boundary: "test"),
          expectedCode);
    });

    test('POST 5', () {
      const expectedCode = r"""require 'faraday'
require 'base64'
headers = {
  "User-Agent" => "Test Agent",
  "content-type" => "multipart/form-data; boundary=test"
}
def build_form_data(fields,boundary)
  data = ''

  fields.each do |field|
    data += "--#{boundary}\r\n"
    data += "Content-Disposition: form-data; name=\"#{field['name']}\""

    if field['type'] == 'file'
      file_content = File.read(field['value'])
      encoded_file = Base64.strict_encode64(file_content)

      data += "; filename=\"#{File.basename(field['value'])}\"\r\n"
      data += "Content-Type: application/octet-stream\r\n\r\n"
      data += "#{encoded_file}\r\n"
    else
      data += "\r\n\r\n#{field['value']}\r\n"
    end
  end

  data += "--#{boundary}--\r\n"
  data
end
fields_list = [{"name" =>"text","value" =>"API","type" =>"text"},{"name" =>"sep","value" =>"|","type" =>"text"},{"name" =>"times","value" =>"3","type" =>"text"}]
boundary = "test"
body = build_form_data(fields_list,boundary)

conn = Faraday.new(url: "https://api.apidash.dev") do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.post do |req|
  req.url "/io/form" 


  req.body = body
  req.headers = headers
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyFaraday, requestModelPost5, "https",boundary: "test"),
          expectedCode);
    });

    test('POST 6', () {
      const expectedCode = r"""require 'faraday'
require 'base64'
headers = {
  "content-type" => "multipart/form-data; boundary=test"
}
def build_form_data(fields,boundary)
  data = ''

  fields.each do |field|
    data += "--#{boundary}\r\n"
    data += "Content-Disposition: form-data; name=\"#{field['name']}\""

    if field['type'] == 'file'
      file_content = File.read(field['value'])
      encoded_file = Base64.strict_encode64(file_content)

      data += "; filename=\"#{File.basename(field['value'])}\"\r\n"
      data += "Content-Type: application/octet-stream\r\n\r\n"
      data += "#{encoded_file}\r\n"
    else
      data += "\r\n\r\n#{field['value']}\r\n"
    end
  end

  data += "--#{boundary}--\r\n"
  data
end
fields_list = [{"name" =>"token","value" =>"xyz","type" =>"text"},{"name" =>"imfile","value" =>"/Documents/up/1.png","type" =>"file"}]
boundary = "test"
body = build_form_data(fields_list,boundary)

conn = Faraday.new(url: "https://api.apidash.dev") do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.post do |req|
  req.url "/io/img" 


  req.body = body
  req.headers = headers
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyFaraday, requestModelPost6, "https",boundary: "test"),
          expectedCode);
    });

    test('POST 7', () {
      const expectedCode = r"""require 'faraday'
require 'base64'
headers = {
  "content-type" => "multipart/form-data; boundary=test"
}
def build_form_data(fields,boundary)
  data = ''

  fields.each do |field|
    data += "--#{boundary}\r\n"
    data += "Content-Disposition: form-data; name=\"#{field['name']}\""

    if field['type'] == 'file'
      file_content = File.read(field['value'])
      encoded_file = Base64.strict_encode64(file_content)

      data += "; filename=\"#{File.basename(field['value'])}\"\r\n"
      data += "Content-Type: application/octet-stream\r\n\r\n"
      data += "#{encoded_file}\r\n"
    else
      data += "\r\n\r\n#{field['value']}\r\n"
    end
  end

  data += "--#{boundary}--\r\n"
  data
end
fields_list = [{"name" =>"token","value" =>"xyz","type" =>"text"},{"name" =>"imfile","value" =>"/Documents/up/1.png","type" =>"file"}]
boundary = "test"
body = build_form_data(fields_list,boundary)

conn = Faraday.new(url: "https://api.apidash.dev") do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.post do |req|
  req.url "/io/img" 


  req.body = body
  req.headers = headers
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyFaraday, requestModelPost7, "https",boundary: "test"),
          expectedCode);
    });

    test('POST 8', () {
      const expectedCode = r"""require 'faraday'
require 'base64'
require 'uri'

queryParams = {
  "size" => "2",
  "len" => "3"
}
queryParamsStr = '?' + URI.encode_www_form(queryParams)
headers = {
  "content-type" => "multipart/form-data; boundary=test"
}
def build_form_data(fields,boundary)
  data = ''

  fields.each do |field|
    data += "--#{boundary}\r\n"
    data += "Content-Disposition: form-data; name=\"#{field['name']}\""

    if field['type'] == 'file'
      file_content = File.read(field['value'])
      encoded_file = Base64.strict_encode64(file_content)

      data += "; filename=\"#{File.basename(field['value'])}\"\r\n"
      data += "Content-Type: application/octet-stream\r\n\r\n"
      data += "#{encoded_file}\r\n"
    else
      data += "\r\n\r\n#{field['value']}\r\n"
    end
  end

  data += "--#{boundary}--\r\n"
  data
end
fields_list = [{"name" =>"text","value" =>"API","type" =>"text"},{"name" =>"sep","value" =>"|","type" =>"text"},{"name" =>"times","value" =>"3","type" =>"text"}]
boundary = "test"
body = build_form_data(fields_list,boundary)

conn = Faraday.new(url: "https://api.apidash.dev") do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.post do |req|
  req.url "/io/form"  + queryParamsStr


  req.body = body
  req.headers = headers
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyFaraday, requestModelPost8, "https",boundary: "test"),
          expectedCode);
    });

    test('POST 9', () {
      const expectedCode = r"""require 'faraday'
require 'base64'
require 'uri'

queryParams = {
  "size" => "2",
  "len" => "3"
}
queryParamsStr = '?' + URI.encode_www_form(queryParams)
headers = {
  "User-Agent" => "Test Agent",
  "Keep-Alive" => "true",
  "content-type" => "multipart/form-data; boundary=test"
}
def build_form_data(fields,boundary)
  data = ''

  fields.each do |field|
    data += "--#{boundary}\r\n"
    data += "Content-Disposition: form-data; name=\"#{field['name']}\""

    if field['type'] == 'file'
      file_content = File.read(field['value'])
      encoded_file = Base64.strict_encode64(file_content)

      data += "; filename=\"#{File.basename(field['value'])}\"\r\n"
      data += "Content-Type: application/octet-stream\r\n\r\n"
      data += "#{encoded_file}\r\n"
    else
      data += "\r\n\r\n#{field['value']}\r\n"
    end
  end

  data += "--#{boundary}--\r\n"
  data
end
fields_list = [{"name" =>"token","value" =>"xyz","type" =>"text"},{"name" =>"imfile","value" =>"/Documents/up/1.png","type" =>"file"}]
boundary = "test"
body = build_form_data(fields_list,boundary)

conn = Faraday.new(url: "https://api.apidash.dev") do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.post do |req|
  req.url "/io/img"  + queryParamsStr


  req.body = body
  req.headers = headers
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyFaraday, requestModelPost9, "https",boundary: "test"),
          expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r"""require 'faraday'

body = '{
"name": "morpheus",
"job": "zion resident"
}'
headers = {
  "content-type" => "application/json"
}

conn = Faraday.new(url: "https://reqres.in") do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.put do |req|
  req.url "/api/users/2" 


  req.body = body
  req.headers = headers
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyFaraday, requestModelPut1, "https"),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r"""require 'faraday'

body = '{
"name": "marfeus",
"job": "accountant"
}'
headers = {
  "content-type" => "application/json"
}

conn = Faraday.new(url: "https://reqres.in") do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.patch do |req|
  req.url "/api/users/2" 


  req.body = body
  req.headers = headers
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyFaraday, requestModelPatch1, "https"),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""require 'faraday'

conn = Faraday.new(url: "https://reqres.in") do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.delete do |req|
  req.url "/api/users/2" 
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyFaraday, requestModelDelete1, "https"),
          expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r"""require 'faraday'

body = '{
"name": "marfeus",
"job": "accountant"
}'
headers = {
  "content-type" => "application/json"
}

conn = Faraday.new(url: "https://reqres.in") do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.delete do |req|
  req.url "/api/users/2" 


  req.body = body
  req.headers = headers
end

puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rubyFaraday, requestModelDelete2, "https"),
          expectedCode);
    });
  });
}
