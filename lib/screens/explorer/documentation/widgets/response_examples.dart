import 'package:flutter/material.dart';
import 'package:apidash/models/api_explorer_models.dart';
import 'response_example.dart';

class ResponseExamples extends StatelessWidget {
  final Map<String, ApiResponse> responses;

  const ResponseExamples({super.key, required this.responses});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: responses.entries.map((entry) => ResponseExample(
        statusCode: entry.key,
        response: entry.value,
      )).toList(),
    );
  }
}