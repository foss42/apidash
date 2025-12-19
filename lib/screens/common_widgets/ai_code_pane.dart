import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/dashbot/prompts/dashbot_prompts.dart';
import 'package:apidash/models/request_model.dart';
import 'package:apidash/consts.dart';

class AICodePane extends ConsumerWidget {
  const AICodePane({
    super.key,
    required this.selectedRequestModel,
  });

  final RequestModel selectedRequestModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final codegenLanguage = ref.watch(codegenLanguageStateProvider);

    // Get default AI model from settings
    final defaultAIModel = settings.defaultAIModel;
    if (defaultAIModel == null) {
      return const ErrorMessage(
        message: kMsgAIModelNotConfigured,
      );
    }

    final aiRequestModel = selectedRequestModel.aiRequestModel;
    if (aiRequestModel == null) {
      return const ErrorMessage(
        message: kMsgAIRequestModelNotConfigured,
      );
    }

    return FutureBuilder<String?>(
      future: _generateCode(
        ref,
        aiRequestModel,
        codegenLanguage,
        defaultAIModel,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(kMsgGeneratingCodeWithAI),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return ErrorMessage(
            message: '$kMsgErrorGeneratingCode${snapshot.error}',
          );
        }

        final code = snapshot.data;
        if (code == null || code.isEmpty) {
          return const ErrorMessage(
            message: kMsgFailedToGenerateCode,
          );
        }

        return ViewCodePane(
          code: code,
          codegenLanguage: codegenLanguage,
          onChangedCodegenLanguage: (CodegenLanguage? value) {
            ref.read(codegenLanguageStateProvider.notifier).state = value!;
          },
        );
      },
    );
  }

  Future<String?> _generateCode(
    WidgetRef ref,
    AIRequestModel aiRequestModel,
    CodegenLanguage codegenLanguage,
    Map<String, Object?> defaultAIModelJson,
  ) async {
    try {
      // Build the prompt for code generation
      final prompts = DashbotPrompts();
      final prompt = prompts.generateCodePrompt(
        url: aiRequestModel.url,
        method: 'POST', // AI requests are typically POST
        headersMap: _extractHeaders(aiRequestModel),
        body: _extractBody(aiRequestModel),
        bodyContentType: 'application/json',
        paramsMap: null,
        authType: aiRequestModel.apiKey != null ? 'API Key' : null,
        language: codegenLanguage.label,
      );

      // Create AI request with the prompt
      final codeGenAIRequest =
          AIRequestModel.fromJson(defaultAIModelJson).copyWith(
        systemPrompt: '',
        userPrompt: prompt,
      );

      // Execute the AI request
      final response = await executeGenAIRequest(codeGenAIRequest);

      if (response == null) {
        return null;
      }

      // Parse the JSON response to extract the code
      return _extractCodeFromResponse(response);
    } catch (e) {
      debugPrint('$kMsgErrorInAICodeGen$e');
      rethrow;
    }
  }

  Map<String, String>? _extractHeaders(AIRequestModel aiRequestModel) {
    final headers = <String, String>{};
    if (aiRequestModel.apiKey != null) {
      headers['Authorization'] = 'Bearer ${aiRequestModel.apiKey}';
    }
    headers['Content-Type'] = 'application/json';
    return headers.isNotEmpty ? headers : null;
  }

  String? _extractBody(AIRequestModel aiRequestModel) {
    // Create a simplified representation of the AI request body
    final bodyMap = {
      'model': aiRequestModel.model,
      'messages': [
        {'role': 'system', 'content': aiRequestModel.systemPrompt},
        {'role': 'user', 'content': aiRequestModel.userPrompt},
      ],
      if (aiRequestModel.stream != null) 'stream': aiRequestModel.stream,
      ...aiRequestModel.getModelConfigMap(),
    };
    return bodyMap.toString();
  }

  String? _extractCodeFromResponse(String response) {
    try {
      // The response should be in JSON format based on the prompt
      // Try to parse it and extract the code
      final jsonStart = response.indexOf('{');
      final jsonEnd = response.lastIndexOf('}');

      if (jsonStart == -1 || jsonEnd == -1) {
        // If not JSON, return the response as-is
        return response;
      }

      final jsonStr = response.substring(jsonStart, jsonEnd + 1);
      final parsed = jsonDecode(jsonStr) as Map<String, dynamic>;

      if (parsed['actions'] is List) {
        final actions = parsed['actions'] as List;
        if (actions.isNotEmpty) {
          final firstAction = actions[0];
          if (firstAction is Map && firstAction['value'] != null) {
            return firstAction['value'] as String;
          }
        }
      }

      // Fallback: return the full response
      return response;
    } catch (e) {
      debugPrint('$kMsgErrorParsingAIResponse$e');
      // Return the response as-is if parsing fails
      return response;
    }
  }
}
