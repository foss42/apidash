

// // i removed ollama_dart and use google gemini api so i can test the dashbot

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:apidash/dashbot/features/debug.dart';
// import 'package:apidash/dashbot/features/explain.dart';
// import 'package:apidash/models/request_model.dart';

// class DashBotService {
//   final String _apiKey = "Here add you api ";
//   final String _baseUrl =
//       "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";

//   late final ExplainFeature _explainFeature;
//   late final DebugFeature _debugFeature;

//   DashBotService() {
//     _explainFeature = ExplainFeature(this);
//     _debugFeature = DebugFeature(this);
//   }

//   Future<String> generateResponse(String prompt) async {
//     final url = Uri.parse("$_baseUrl?key=$_apiKey");
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         "contents": [
//           {
//             "parts": [
//               {"text": prompt}
//             ]
//           }
//         ]
//       }),
//     );

//     if (response.statusCode == 200) {
//       final responseData = jsonDecode(response.body);
//       return responseData["candidates"]?[0]["content"]?["parts"]?[0]["text"] ??
//           "No response received.";
//     } else {
//       return "Error: ${response.statusCode} - ${response.body}";
//     }
//   }

//   Future<String> handleRequest(
//       String input, RequestModel? requestModel, dynamic responseModel) async {
//     if (input == "Explain API") {
//       return _explainFeature.explainLatestApi(
//           requestModel: requestModel, responseModel: responseModel);
//     } else if (input == "Debug API") {
//       return _debugFeature.debugApi(
//           requestModel: requestModel, responseModel: responseModel);
//     }

//     return generateResponse(input);
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:apidash/dashbot/features/debug.dart';
import 'package:apidash/dashbot/features/explain.dart';
import 'package:apidash/dashbot/features/generateApiDoc.dart'; // Added missing import
import 'package:apidash/dashbot/features/visualizationFeature.dart'; // Added missing import
import 'package:apidash/models/request_model.dart';

class DashBotService {
  final Map<String, String> _apiEndpoints = {
    "LLaMA": "https://ai-endpoint-seven.vercel.app/llama",
    "Snowflake": "https://ai-endpoint-seven.vercel.app/snowflake",
    "Google": "https://ai-endpoint-seven.vercel.app/google",
  };
// these apis will just call as llm these i have create in diffrent repo :-https://github.com/saisreesatyassss/ai_endpoint/tree/main

  late final ExplainFeature _explainFeature;
  late final DebugFeature _debugFeature;
  late final DocumentationFeature
      _documentationFeature; 
  late final VisualizationFeature
      _visualizationFeature; 

  DashBotService() {
    _explainFeature = ExplainFeature(this);
    _debugFeature = DebugFeature(this);
    _documentationFeature = DocumentationFeature(this);
    _visualizationFeature = VisualizationFeature(this);
  }

  Future<String> generateResponse(String prompt, String selectedAI) async {
    // print("Selected AI before lookup: '$selectedAI'");

    final String? apiUrl = _apiEndpoints[selectedAI.trim()];

    if (apiUrl == null) {
      // print("Invalid AI model selected, defaulting to Google");
      return "Error: Invalid AI Model Selected";
    }

    final Uri url = Uri.parse(apiUrl);
    // print("API URL being used: $apiUrl");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"text": prompt}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData["response"] ?? "No response received.";
    } else {
      // print("Error from API: ${response.statusCode} - ${response.body}");
      return "Error: ${response.statusCode} - ${response.body}";
    }
  }
Future<String> handleRequest(String input, RequestModel? requestModel,
    dynamic responseModel, String selectedAI,  BuildContext context, // Add context as a parameter
) async {
  // print("Handling request with AI model: $selectedAI");

  if (input == "Explain API") {
    return _explainFeature.explainLatestApi(
        requestModel: requestModel,
        responseModel: responseModel,
        selectedAI: selectedAI);
  } else if (input == "Debug API") {
    return _debugFeature.debugApi(
        requestModel: requestModel,
        responseModel: responseModel,
        selectedAI: selectedAI);
  } else if (input == "Generate API Documentation") {
    return _documentationFeature.generateApiDoc(
        requestModel: requestModel,
        responseModel: responseModel,
        selectedAI: selectedAI);
  } else if (input == "Generate API Plots") {
    return _visualizationFeature.generateApiPlots(
        requestModel: requestModel,
        responseModel: responseModel,
        selectedAI: selectedAI,      context: context
);
  }

  return generateResponse(input, selectedAI);
}

}
