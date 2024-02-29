import 'package:test/test.dart';
import '../request_models.dart';
import 'package:apidash/codegen/Ruby/faraday.dart';

void main() {
  final rubyFaradayCodeGen = RubyFaradayCodeGen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = '''
require 'faraday'
require 'json'

url = "https://api.foss42.com"

conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get do |req|
  req.headers['Content-Type'] = 'application/json'
end

puts response.body
''';
      expect(rubyFaradayCodeGen.getCode(requestModelGet1,"https"), expectedCode);
    });

test('GET 2', () {
      const expectedCode = '''
require 'faraday'
require 'json'
url = "https://api.foss42.com/country/data"
url += "?code=US"

conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get do |req|
  req.headers['Content-Type'] = 'application/json'
end

puts response.body
''';
      expect(rubyFaradayCodeGen.getCode(requestModelGet2,"https"), expectedCode);
    });
    
    test('GET 3', () {
      const expectedCode = '''
require 'faraday'
require 'json'
url = "https://api.foss42.com/country/data"
url += "?code=IND"

conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get do |req|
  req.headers['Content-Type'] = 'application/json'
end

puts response.body
''';
      expect(rubyFaradayCodeGen.getCode(requestModelGet3,"https"), expectedCode);
    });

    test('GET 4', () {
      const expectedCode = '''
require 'faraday'
require 'json'
url = "https://api.foss42.com/humanize/social"
url += "?num=8700000"
url += "?digits=3"
url += "?system=SS"
url += "?add_space=true"
url += "?trailing_zeros=true"

conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get do |req|
  req.headers['Content-Type'] = 'application/json'
end

puts response.body
''';
      expect(rubyFaradayCodeGen.getCode(requestModelGet4,"https"), expectedCode);
    });

    test('GET 5', () {
      const expectedCode = '''
require 'faraday'
require 'json'
url = "https://api.github.com/repos/foss42/apidash"

conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get do |req|
  req.headers['Content-Type'] = 'application/json'
end

puts response.body
''';
      expect(rubyFaradayCodeGen.getCode(requestModelGet5,"https"), expectedCode);
    });

    test('GET 6', () {
      const expectedCode = '''
require 'faraday'
require 'json'
url = "https://api.github.com/repos/foss42/apidash"
url += "?raw=true"

conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get do |req|
  req.headers['Content-Type'] = 'application/json'
end

puts response.body
''';
      expect(rubyFaradayCodeGen.getCode(requestModelGet6,"https"), expectedCode);
    });

    test('GET 7', () {
      const expectedCode = '''
require 'faraday'
require 'json'
url = "https://api.foss42.com"

conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get do |req|
  req.headers['Content-Type'] = 'application/json'
end

puts response.body
''';
      expect(rubyFaradayCodeGen.getCode(requestModelGet7,"https"), expectedCode);
    });

    test('GET 8', () {
      const expectedCode = '''
require 'faraday'
require 'json'
url = "https://api.github.com/repos/foss42/apidash"
url += "?raw=true"

conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get do |req|
  req.headers['Content-Type'] = 'application/json'
end

puts response.body
''';
      expect(rubyFaradayCodeGen.getCode(requestModelGet8,"https"), expectedCode);
    });

    test('GET 9', () {
      const expectedCode = '''
require 'faraday'
require 'json'
url = "https://api.foss42.com/humanize/social"
url += "?num=8700000"
url += "?add_space=true"

conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get do |req|
  req.headers['Content-Type'] = 'application/json'
end

puts response.body
''';
      expect(rubyFaradayCodeGen.getCode(requestModelGet9,"https"), expectedCode);
    });
    
  });
}
