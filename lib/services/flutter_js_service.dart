// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';
import '../models/models.dart';
import '../utils/utils.dart';

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
      if (args is List) {
        print('[JS LOG]: ${args.map((e) => e.toString()).join(' ')}');
      } else {
        print('[JS LOG]: $args');
      }
    } catch (e) {
      print('[JS LOG ERROR]: $args, Error: $e');
    }
  });

  jsRuntime.onMessage('consoleWarn', (args) {
    try {
      if (args is List) {
        print('[JS WARN]: ${args.map((e) => e.toString()).join(' ')}');
      } else {
        print('[JS WARN]: $args');
      }
    } catch (e) {
      print('[JS WARN ERROR]: $args, Error: $e');
    }
  });

  jsRuntime.onMessage('consoleError', (args) {
    try {
      if (args is List) {
        print('[JS ERROR]: ${args.map((e) => e.toString()).join(' ')}');
      } else {
        print('[JS ERROR]: $args');
      }
    } catch (e) {
      print('[JS ERROR ERROR]: $args, Error: $e');
    }
  });

  jsRuntime.onMessage('fatalError', (args) {
    try {
      // 'fatalError' message is constructed as a JSON object in setupScript
      if (args is Map<String, dynamic>) {
        print('[JS FATAL ERROR]: ${args['message']}');
        if (args['error'] != null) print('  Error: ${args['error']}');
        if (args['stack'] != null) print('  Stack: ${args['stack']}');
      } else {
        print('[JS FATAL ERROR decoding error]: $args, Expected a Map.');
      }
    } catch (e) {
      print('[JS FATAL ERROR decoding error]: $args, Error: $e');
    }
  });
}

Future<
    ({
      HttpRequestModel updatedRequest,
      Map<String, dynamic> updatedEnvironment
    })> executePreRequestScript({
  required RequestModel currentRequestModel,
  required Map<String, dynamic> activeEnvironment,
}) async {
  if ((currentRequestModel.preRequestScript ?? "").trim().isEmpty) {
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
    $kJSSetupScript

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

Future<
    ({
      HttpResponseModel updatedResponse,
      Map<String, dynamic> updatedEnvironment
    })> executePostResponseScript({
  required RequestModel currentRequestModel,
  required Map<String, dynamic> activeEnvironment,
}) async {
  if ((currentRequestModel.postRequestScript ?? "").trim().isEmpty) {
    // No script, return original data
    // return (
    //   updatedRequest: currentRequestModel.httpRequestModel,
    //   updatedEnvironment: activeEnvironment
    // );
  }

  final httpRequest = currentRequestModel.httpRequestModel;
  final httpResponse = currentRequestModel.httpResponseModel;
  final userScript = currentRequestModel.postRequestScript;

  // Prepare Data
  final requestJson = jsonEncode(httpRequest?.toJson());
  final responseJson = jsonEncode(httpResponse?.toJson());
  final environmentJson = jsonEncode(activeEnvironment);

  // Inject data as JS variables
  // Escape strings properly if embedding directly
  final dataInjection = """
  var injectedRequestJson = ${jsEscapeString(requestJson)};
  var injectedEnvironmentJson = ${jsEscapeString(environmentJson)};
  var injectedResponseJson = ${jsEscapeString(responseJson)};
  """;

  // Concatenate & Add Return
  final fullScript = """
  (function() {
    // --- Data Injection (now constants within the IIFE scope) ---
    $dataInjection

    // --- Setup Script (will declare variables within the IIFE scope) ---
    $kJSSetupScript

    // --- User Script (will execute within the IIFE scope)---
    $userScript

    // --- Return Result (accesses variables from the IIFE scope) ---
    return JSON.stringify({ response: response, environment: environment });
  })(); // Immediately invoke the function
  """;

  // TODO: Do something better to avoid null check here.
  // HttpRequestModel resultingRequest = httpRequest!;
  HttpResponseModel resultingResponse = httpResponse!;
  Map<String, dynamic> resultingEnvironment = Map.from(activeEnvironment);

  try {
    // Execute
    final JsEvalResult result = jsRuntime.evaluate(fullScript);

    // Process Results
    if (result.isError) {
      print("Post-Response script execution error: ${result.stringResult}");
      // TODO: Handle error - maybe show in UI, keep original request/env
    } else if (result.stringResult.isNotEmpty) {
      final resultMap = jsonDecode(result.stringResult);
      if (resultMap is Map<String, dynamic>) {
        // Deserialize Request
        if (resultMap.containsKey('response') && resultMap['response'] is Map) {
          try {
            resultingResponse = HttpResponseModel.fromJson(
                Map<String, Object?>.from(resultMap['response']));
          } catch (e) {
            print("Error deserializing modified response from script: $e");
            //TODO: Handle error - maybe keep original response?
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
    print("Dart-level error during post-response script execution: $e");
  }

  return (
    updatedResponse: resultingResponse,
    updatedEnvironment: resultingEnvironment
  );
}

// Helper to properly escape strings for JS embedding
String jsEscapeString(String s) {
  return jsonEncode(
      s); // jsonEncode handles escaping correctly for JS string literals
}
