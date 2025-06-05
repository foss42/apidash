import 'dart:convert';
// import 'package:apidash_core/apidash_core.dart' as http;
import 'package:http/http.dart' as http;
import 'package:apidash_genai/llm_request.dart';
import 'package:apidash_genai/providers/common.dart';

Future<String?> executeGenAIRequest(
  LLMModel model,
  LLMRequestDetails requestDetails,
) async {
  final headers = requestDetails.headers;
  // print(jsonEncode(requestDetails.body));
  //TODO: enable streaming outputs
  final response = await http.post(
    Uri.parse(requestDetails.endpoint),
    headers: {'Content-Type': 'application/json', ...headers},
    body: jsonEncode(requestDetails.body),
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    // print(data);
    return model.outputFormatter(data);
  } else {
    print(requestDetails.endpoint);
    print(response.body);
    throw Exception('LLM_EXCEPTION: ${response.statusCode}\n${response.body}');
  }
}
