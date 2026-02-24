import 'dart:convert';
import 'package:apidash/templates/templates.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';

class StacGenBot extends AIAgent {
  @override
  String get agentName => 'STAC_GEN';

  @override
  String getSystemPrompt() => kPromptStacGen;

  // 🛡️ Helper: Ensures consistent cleaning across the agent.
  // Handles all language tags (json, dart, etc.) and whitespace.
  String _clean(String input) {
    return input.replaceAll(RegExp(r'```[a-zA-Z]*\n?|```'), '').trim();
  }

  @override
  Future<bool> validator(String aiResponse) async {
    final cleanResponse = _clean(aiResponse);
    try {
      jsonDecode(cleanResponse);
      return true;
    } catch (e) {
      debugPrint("STAC_GEN JSON PARSE ERROR: $e");
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> outputFormatter(String validatedResponse) async {
    String cleanSTAC = _clean(validatedResponse);

    // 🛡️ STAC Mapping: Standardizes font weights for the UI renderer.
    cleanSTAC = cleanSTAC.replaceAll('bold', 'w700');

    return {
      'STAC': cleanSTAC,
    };
  }
}
