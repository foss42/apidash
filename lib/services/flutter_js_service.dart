// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:apidash/consts.dart';
import 'package:apidash/models/request_model.dart';
import 'package:apidash_core/models/http_request_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';

late JavascriptRuntime jsRuntime;

void initializeJsRuntime() {
  jsRuntime = getJavascriptRuntime();
  setupJsBridge();
}

void disposeJsRuntime() {
  jsRuntime.dispose();
}

void evaluate(String code) {
  try {
    JsEvalResult jsResult = jsRuntime.evaluate(code);
    log(jsResult.stringResult);
  } on PlatformException catch (e) {
    log('ERROR: ${e.details}');
  }
}

// TODO: These log statements can be printed in a custom api dash terminal.
void setupJsBridge() {
  jsRuntime.onMessage('consoleLog', (args) {
    try {
      final decodedArgs = jsonDecode(args as String);
      if (decodedArgs is List) {
        print('[JS LOG]: ${decodedArgs.map((e) => e.toString()).join(' ')}');
      } else {
        print('[JS LOG]: $decodedArgs');
      }
    } catch (e) {
      print('[JS LOG ERROR decoding]: $args, Error: $e');
    }
  });

  jsRuntime.onMessage('consoleWarn', (args) {
    try {
      final decodedArgs = jsonDecode(args as String);
      if (decodedArgs is List) {
        print('[JS WARN]: ${decodedArgs.map((e) => e.toString()).join(' ')}');
      } else {
        print('[JS WARN]: $decodedArgs');
      }
    } catch (e) {
      print('[JS WARN ERROR decoding]: $args, Error: $e');
    }
  });

  jsRuntime.onMessage('consoleError', (args) {
    try {
      final decodedArgs = jsonDecode(args as String);
      if (decodedArgs is List) {
        print('[JS ERROR]: ${decodedArgs.map((e) => e.toString()).join(' ')}');
      } else {
        print('[JS ERROR]: $decodedArgs');
      }
    } catch (e) {
      print('[JS ERROR ERROR decoding]: $args, Error: $e');
    }
  });

  jsRuntime.onMessage('fatalError', (args) {
    try {
      final errorDetails = jsonDecode(args as String);
      print('[JS FATAL ERROR]: ${errorDetails['message']}');
      if (errorDetails['error']) print('  Error: ${errorDetails['error']}');
      if (errorDetails['stack']) print('  Stack: ${errorDetails['stack']}');
    } catch (e) {
      print('[JS FATAL ERROR decoding error]: $args, Error: $e');
    }
  });

  //TODO: Add handlers for 'testResult'
}

Future<
    ({
      HttpRequestModel updatedRequest,
      Map<String, dynamic> updatedEnvironment
    })> executePreRequestScript({
  required RequestModel currentRequestModel,
  required Map<String, dynamic> activeEnvironment,
}) async {
  if (currentRequestModel.preRequestScript.trim().isEmpty) {
    // No script, return original data
    // return (
    //   updatedRequest: currentRequestModel.httpRequestModel,
    //   updatedEnvironment: activeEnvironment
    // );
  }

  final httpRequest = currentRequestModel.httpRequestModel;
  final userScript = currentRequestModel.preRequestScript;

  // Prepare Data
  final requestJson = jsonEncode(httpRequest?.toJson());
  final environmentJson = jsonEncode(activeEnvironment);

  // Inject data as JS variables
  // Escape strings properly if embedding directly
  final dataInjection = """
  var injectedRequestJson = ${jsEscapeString(requestJson)};
  var injectedEnvironmentJson = ${jsEscapeString(environmentJson)};
  var injectedResponseJson = null; // Not needed for pre-request
  """;

  // Concatenate & Add Return
  final fullScript = """
  (function() {
    // --- Data Injection (now constants within the IIFE scope) ---
    $dataInjection

    // --- Setup Script (will declare variables within the IIFE scope) ---
    $setupScript

    // --- User Script (will execute within the IIFE scope)---
    $userScript

    // --- Return Result (accesses variables from the IIFE scope) ---
    // Ensure 'request' and 'environment' are accessible here
    return JSON.stringify({ request: request, environment: environment });
  })(); // Immediately invoke the function
  """;


  // TODO: Do something better to avoid null check here.
  HttpRequestModel resultingRequest = httpRequest!;
  Map<String, dynamic> resultingEnvironment = Map.from(activeEnvironment);

  try {
    // Execute
    final JsEvalResult result = jsRuntime.evaluate(fullScript);

    // Process Results
    if (result.isError) {
      print("Pre-request script execution error: ${result.stringResult}");
      // Handle error - maybe show in UI, keep original request/env
    } else if (result.stringResult.isNotEmpty) {
      final resultMap = jsonDecode(result.stringResult);
      if (resultMap is Map<String, dynamic>) {
        // Deserialize Request
        if (resultMap.containsKey('request') && resultMap['request'] is Map) {
          try {
            resultingRequest = HttpRequestModel.fromJson(
                Map<String, Object?>.from(resultMap['request']));
          } catch (e) {
            print("Error deserializing modified request from script: $e");
            //TODO: Handle error - maybe keep original request?
          }
        }
        // Get Environment Modifications
        if (resultMap.containsKey('environment') &&
            resultMap['environment'] is Map) {
          resultingEnvironment =
              Map<String, dynamic>.from(resultMap['environment']);
        }
      }
    }
  } catch (e) {
    print("Dart-level error during pre-request script execution: $e");
  }

  return (
    updatedRequest: resultingRequest,
    updatedEnvironment: resultingEnvironment
  );
}

// Helper to properly escape strings for JS embedding
String jsEscapeString(String s) {
  return jsonEncode(
      s); // jsonEncode handles escaping correctly for JS string literals
}
