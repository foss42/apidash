import 'package:apidash/codegen/Ruby/faraday.dart';
import '../request_models.dart';
import 'package:test/test.dart';

void main() {
  final rubyFaradayCodeGen = RubyFaradayCodeGen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""
require 'faraday'
require 'json'
url = "https://api.foss42.com"

conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.put do |req|
  req.headers['Content-Type'] = 'application/json'

end

puts response.body
""";
      expect(rubyFaradayCodeGen.getCode(requestModelGet1, "https"), expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""
require 'faraday'
require 'json'
url = "https://api.foss42.com/country/data"

conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.put do |req|
  req.headers['Content-Type'] = 'application/json'

end

puts response.body
""";
      expect(rubyFaradayCodeGen.getCode(requestModelGet2, "https"), expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""
require 'faraday'
require 'json'
url = "https://api.foss42.com/country/data?code=US"
conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.put do |req|
  req.headers['Content-Type'] = 'application/json'

end

puts response.body
""";
      expect(rubyFaradayCodeGen.getCode(requestModelGet3, "https"), expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r"""
require 'faraday'
require 'json'
url = "https://api.foss42.com/humanize/social"

conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.put do |req|
  req.headers['Content-Type'] = 'application/json'

end

puts response.body
""";
      expect(rubyFaradayCodeGen.getCode(requestModelGet4, "https"), expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r"""
require 'faraday'
require 'json'
url = "https://api.github.com/repos/foss42/apidash"

conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.put do |req|
  req.headers['Content-Type'] = 'application/json'

end

puts response.body
""";
      expect(rubyFaradayCodeGen.getCode(requestModelGet5, "https"), expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r"""
require 'faraday'
require 'json'
url = "https://api.github.com/repos/foss42/apidash"

conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.put do |req|
  req.headers['Content-Type'] = 'application/json'

end

puts response.body
""";
      expect(rubyFaradayCodeGen.getCode(requestModelGet6, "https"), expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""
require 'faraday'
require 'json'
url = "https://api.foss42.com"

conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.put do |req|
  req.headers['Content-Type'] = 'application/json'

end

puts response.body
""";
      expect(rubyFaradayCodeGen.getCode(requestModelGet7, "https"), expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r"""
require 'faraday'
require 'json'
url = "https://api.github.com/repos/foss42/apidash"

conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.put do |req|
  req.headers['Content-Type'] = 'application/json'

end

puts response.body
""";
      expect(rubyFaradayCodeGen.getCode(requestModelGet8, "https"), expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""
require 'faraday'
require 'json'
url = "https://api.foss42.com/humanize/social"

conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.put do |req|
  req.headers['Content-Type'] = 'application/json'

end

puts response.body
""";
      expect(rubyFaradayCodeGen.getCode(requestModelGet9, "https"), expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""
require 'faraday'
require 'json'
url = "https://api.foss42.com/humanize/social"

conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.put do |req|
  req.headers['Content-Type'] = 'application/json'

end

puts response.body
""";
      expect(rubyFaradayCodeGen.getCode(requestModelGet10, "https"), expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""
require 'faraday'
require 'json'
url = "https://api.foss42.com/humanize/social"

conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.put do |req|
  req.headers['Content-Type'] = 'application/json'

end

puts response.body
""";
      expect(rubyFaradayCodeGen.getCode(requestModelGet11, "https"), expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""
require 'faraday'
require 'json'
url = "https://api.foss42.com/humanize/social"

conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.put do |req|
  req.headers['Content-Type'] = 'application/json'

end

puts response.body
""";
      expect(rubyFaradayCodeGen.getCode(requestModelGet12, "https"), expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""
require 'faraday'
require 'json'
url = "https://api.foss42.com"

conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.head do |req|
  req.headers['Content-Type'] = 'application/json'

end

puts response.body
""";
      expect(rubyFaradayCodeGen.getCode(requestModelHead1, "https"), expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""
require 'faraday'
require 'json'
url = "http://api.foss42.com"

conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.head do |req|
  req.headers['Content-Type'] = 'application/json'

end

puts response.body
""";
      expect(rubyFaradayCodeGen.getCode(requestModelHead2, "http"), expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r"""
require 'faraday'
require 'json'
url = "https://api.foss42.com/case/lower"

conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.post do |req|
  req.headers['Content-Type'] = 'application/json'

end

puts response.body
""";
      expect(rubyFaradayCodeGen.getCode(requestModelPost1, "https"), expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r"""
require 'faraday'
require 'json'
url = "https://api.foss42.com/case/lower"

conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.post do |req|
  req.headers['Content-Type'] = 'application/json'

end

puts response.body
""";
      expect(rubyFaradayCodeGen.getCode(requestModelPost2, "https"), expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r"""
require 'faraday'
require 'json'
url = "https://api.foss42.com/case/lower"

conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.post do |req|
  req.headers['Content-Type'] = 'application/json'

end

puts response.body
""";
      expect(rubyFaradayCodeGen.getCode(requestModelPost3, "https"), expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r"""
require 'faraday'
require 'json'
url = "https://reqres.in/api/users/2"

conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.put do |req|
  req.headers['Content-Type'] = 'application/json'

end

puts response.body
""";
      expect(rubyFaradayCodeGen.getCode(requestModelPut1, "https"), expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r"""
require 'faraday'
require 'json'
url = "https://reqres.in/api/users/2"

conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.patch do |req|
  req.headers['Content-Type'] = 'application/json'

end

puts response.body
""";
      expect(rubyFaradayCodeGen.getCode(requestModelPatch1, "https"), expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""
require 'faraday'
require 'json'
url = "https://reqres.in/api/users/2"

conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.delete do |req|
  req.headers['Content-Type'] = 'application/json'

end

puts response.body
""";
      expect(rubyFaradayCodeGen.getCode(requestModelDelete1, "https"), expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r"""
require 'faraday'
require 'json'
url = "https://reqres.in/api/users/2"

conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.delete do |req|
  req.headers['Content-Type'] = 'application/json'

end

puts response.body
""";
      expect(rubyFaradayCodeGen.getCode(requestModelDelete2, "https"), expectedCode);
    });
  });
}