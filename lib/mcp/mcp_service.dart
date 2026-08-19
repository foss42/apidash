import 'dart:convert';
import 'dart:isolate';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'mcp_engine.dart';
import 'dart:io';

class McpService {
  SendPort? _serverSendPort;
  final ReceivePort _uiReceivePort = ReceivePort();

  int _requestId = 1;
  final Map<int, Completer<Map<String, dynamic>>> _pendingRequests = {};
  bool _isRunning = false;
  final Completer<void> _initCompleter = Completer<void>();

  Future<void> start() async {
    if (_isRunning) return;
    _isRunning = true;

    _uiReceivePort.listen((message) {
      if (message is SendPort) {
        _serverSendPort = message;
        _initCompleter.complete();
        debugPrint("✅ Local MCP Bridge Connected!");
      } else if (message is String) {
        try {
          final response = jsonDecode(message);
          final id = response['id'];
          if (id != null && _pendingRequests.containsKey(id)) {
            _pendingRequests[id]!.complete(response['result']);
            _pendingRequests.remove(id);
          }
        } catch (e) {
          debugPrint('MCP UI Parse Error: $e');
        }
      }
    });

    // We boot the engine directly in our current memory space
    // bypassing the strict Isolate barrier so better_networking can access Hive.
    runMcpEngine(_uiReceivePort.sendPort);

    await _initCompleter.future;
  }

  Future<Map<String, dynamic>> executeTool(String name, Map<String, dynamic> arguments) async {
    if (_serverSendPort == null) await start();

    final id = _requestId++;
    final completer = Completer<Map<String, dynamic>>();
    _pendingRequests[id] = completer;

    final request = jsonEncode({
      "jsonrpc": "2.0",
      "id": id,
      "method": "tools/call",
      "params": {
        "name": name,
        "arguments": arguments
      }
    });

    _serverSendPort!.send(request);
    return completer.future;
  }

// mcp_service.dart
  Future<void> startHeadless() async {
    final ReceivePort uiReceivePort = ReceivePort();
    SendPort? engineSendPort;
    final streamCompleter = Completer<void>();
    final List<StreamSubscription> subscriptions = [];

    // Centralized cleanup method
    Future<void> shutdown() async {
      uiReceivePort.close();
      for (final sub in subscriptions) {
        await sub.cancel();
      }
      // Force exit to ensure no background threads hang
      exit(0);
    }

    // Catch termination signals from the Node wrapper
    if (!Platform.isWindows) {
      subscriptions.add(ProcessSignal.sigterm.watch().listen((_) => shutdown()));
    }
    subscriptions.add(ProcessSignal.sigint.watch().listen((_) => shutdown()));

    // 1. Listen to responses from the engine
    subscriptions.add(uiReceivePort.listen((message) {
      if (message is SendPort) {
        engineSendPort = message;
      } else if (message is String) {
        // Print the raw JSON-RPC string directly
        stdout.write(message + "\n");
      }
    }));

    // 2. Fire up the engine
    runMcpEngine(uiReceivePort.sendPort);

    // 3. Listen to incoming instructions from Node's pipe
    subscriptions.add(stdin
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(
          (String jsonRpcLine) {
        if (engineSendPort != null && jsonRpcLine.trim().isNotEmpty) {
          engineSendPort!.send(jsonRpcLine);
        }
      },
      onDone: () => streamCompleter.complete(),
      onError: (e) => streamCompleter.complete(),
    ));

    await streamCompleter.future;
    await shutdown();
  }
}

final mcpService = McpService();