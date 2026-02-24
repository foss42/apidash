import 'dart:convert';
import 'package:apidash/templates/templates.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';

class StacModifierBot extends AIAgent {
  @override
  String get agentName => 'STAC_MODIFIER';

  @override
  String getSystemPrompt() => kPromptStacModifier;

  // 🛡️ Helper: Unifies cleaning logic for a clean, non-redundant codebase.
  String _clean(String input) {
    return input.replaceAll(RegExp(r'```[a-zA-Z]*\n?|```'), '').trim();
  }

  @override
  Future<bool> validator(String aiResponse) async {
    final cleanResponse = _clean(aiResponse);

    // 🛡️ JSON Integrity: Essential for the UI to successfully re-render.
    try {
      jsonDecode(cleanResponse);
      return true;
    } catch (e) {
      debugPrint("STAC_MODIFIER JSON PARSE ERROR: $e");
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> outputFormatter(String validatedResponse) async {
    String cleanSTAC = _clean(validatedResponse);

    // 🛡️ STAC Mapping: Ensuring consistent font-weight standards.
    cleanSTAC = cleanSTAC.replaceAll('bold', 'w700');

    return {
      'STAC': cleanSTAC,
    };
  }
}
