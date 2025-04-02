import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const apiKey = 'sk-xxx';

  final url = Uri.parse('https://api.openai.com/v1/chat/completions');

  final headers = {
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json',
  };

  final body = jsonEncode({
    "model": "gpt-3.5-turbo",
    "messages": [
      {"role": "user", "content": "Hello! What is Flutter?"}
    ],
    "temperature": 0.7
  });

  print('[DEBUG] Sending request...');
  try {
    final response = await http.post(url, headers: headers, body: body);

    print('[DEBUG] Status code: ${response.statusCode}');
    print('[DEBUG] Response body:');
    print(response.body);
  } catch (e) {
    print('[ERROR] Failed to connect: $e');
  }
}
