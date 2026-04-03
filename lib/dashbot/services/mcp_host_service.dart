import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:mcp_dart/mcp_dart.dart';
import 'package:path_provider/path_provider.dart';
import 'mcp_service.dart';
import '../../providers/providers.dart';

class McpCapability<T> {
  final T capability;
  final String serverId;
  final String serverName;
  bool isPermitted;

  McpCapability({
    required this.capability,
    required this.serverId,
    required this.serverName,
    this.isPermitted = true,
  });
}

class McpHostState {
  final List<McpCapability<Tool>> allTools;
  final List<McpCapability<Resource>> allResources;
  final List<McpCapability<Prompt>> allPrompts;

  McpHostState({
    this.allTools = const [],
    this.allResources = const [],
    this.allPrompts = const [],
  });

  McpHostState copyWith({
    List<McpCapability<Tool>>? allTools,
    List<McpCapability<Resource>>? allResources,
    List<McpCapability<Prompt>>? allPrompts,
  }) {
    return McpHostState(
      allTools: allTools ?? this.allTools,
      allResources: allResources ?? this.allResources,
      allPrompts: allPrompts ?? this.allPrompts,
    );
  }
}

class McpHostService extends ChangeNotifier {
  final Ref _ref;
  McpHostState _state = McpHostState();

  McpHostState get state => _state;

  McpHostService(this._ref) {
    _ref.listen<Map<String, McpServerConnection>>(mcpConnectionsProvider, (prev, next) {
      _refreshCapabilities(next);
    });
  }

  Future<void> _refreshCapabilities(Map<String, McpServerConnection> connections) async {
    final tools = <McpCapability<Tool>>[];
    final resources = <McpCapability<Resource>>[];
    final prompts = <McpCapability<Prompt>>[];

    for (final conn in connections.values) {
      if (!conn.isEnabled || conn.client == null) continue;
      
      try {
        final resTools = await conn.client!.listTools();
        tools.addAll(resTools.tools.map((t) => McpCapability(
          capability: t,
          serverId: conn.id,
          serverName: conn.name,
        )));
      } catch (_) {}

      try {
        final resResources = await conn.client!.listResources();
        resources.addAll(resResources.resources.map((r) => McpCapability(
          capability: r,
          serverId: conn.id,
          serverName: conn.name,
        )));
      } catch (_) {}

      try {
        final resPrompts = await conn.client!.listPrompts();
        prompts.addAll(resPrompts.prompts.map((p) => McpCapability(
          capability: p,
          serverId: conn.id,
          serverName: conn.name,
        )));
      } catch (_) {}
    }

    // Preserve permissions from previous state if possible
    for (final t in tools) {
      final existing = _state.allTools.where((e) => e.capability.name == t.capability.name && e.serverId == t.serverId).firstOrNull;
      if (existing != null) t.isPermitted = existing.isPermitted;
    }

    _state = _state.copyWith(
      allTools: tools,
      allResources: resources,
      allPrompts: prompts,
    );
    notifyListeners();
  }

  // Capability dispatch routing
  Future<CallToolResult> callTool(String name, Map<String, dynamic> arguments) async {
    final tool = _state.allTools.where((t) => t.capability.name == name).firstOrNull;
    if (tool == null) {
      throw Exception('Tool "$name" not found across connected servers');
    }
    if (!tool.isPermitted) {
      throw Exception('Execution of tool "$name" is not permitted by user');
    }

    final connections = _ref.read(mcpConnectionsProvider);
    final conn = connections[tool.serverId];
    if (conn?.client == null) {
      throw Exception('Server for tool "$name" is currently disconnected');
    }

    return await conn!.client!.callTool(CallToolRequest(name: name, arguments: arguments));
  }

  Future<ReadResourceResult> readResource(String uri) async {
    // Some URIs might not be listed in allResources, but we try the server that matches or just try all.
    final resource = _state.allResources.where((r) => r.capability.uri == uri).firstOrNull;
    
    final connections = _ref.read(mcpConnectionsProvider);
    
    if (resource != null) {
      final conn = connections[resource.serverId];
      if (conn?.client != null) {
        return await conn!.client!.readResource(ReadResourceRequest(uri: uri));
      }
    }
    
    // Fallback try all
    for (final conn in connections.values) {
      if (!conn.isEnabled || conn.client == null) continue;
      try {
        return await conn.client!.readResource(ReadResourceRequest(uri: uri));
      } catch (_) {}
    }
    throw Exception('Resource "$uri" could not be read from any connected server');
  }

  Future<GetPromptResult> getPrompt(String name, Map<String, String> arguments) async {
    final prompt = _state.allPrompts.where((p) => p.capability.name == name).firstOrNull;
    if (prompt == null) {
      throw Exception('Prompt "$name" not found across connected servers');
    }

    final connections = _ref.read(mcpConnectionsProvider);
    final conn = connections[prompt.serverId];
    if (conn?.client == null) {
      throw Exception('Server for prompt "$name" is currently disconnected');
    }

    return await conn!.client!.getPrompt(GetPromptRequest(name: name, arguments: arguments));
  }
  
  Future<CompleteResult> complete(CompleteRequest request) async {
    final cs = _ref.read(mcpConnectionsProvider);
    final values = <String>[];
    int total = 0;
    bool hasMore = false;

    for (final conn in cs.values) {
      if (!conn.isEnabled || conn.client == null) continue;
      try {
        final res = await conn.client!.complete(request);
        values.addAll(res.completion.values);
        hasMore = hasMore || (res.completion.hasMore ?? false);
        total += res.completion.total ?? 0;
      } catch (_) {}
    }

    return CompleteResult(
      completion: CompletionResultData(values: values, total: total, hasMore: hasMore),
    );
  }
  Future<List<Tool>> discoverTools() async {
    return _state.allTools.map((t) => t.capability).toList();
  }

  Future<List<Resource>> discoverResources() async {
    return _state.allResources.map((t) => t.capability).toList();
  }

  Future<List<Prompt>> discoverPrompts() async {
    return _state.allPrompts.map((t) => t.capability).toList();
  }

  Future<void> connect() async {
    final notifier = _ref.read(mcpConnectionsProvider.notifier);
    if (notifier.hasServer('default')) return;

    final settings = _ref.read(settingsProvider);
    String? path = settings.workspaceFolderPath;
    if (path == null) {
      final docDir = await getApplicationDocumentsDirectory();
      path = docDir.path;
    }
    final command = Platform.isWindows ? 'cmd' : 'dart';
    final args = Platform.isWindows
        ? ['/c', 'dart', 'run', 'bin/mcp_server.dart', path]
        : ['run', 'bin/mcp_server.dart', path];

    await notifier.addStdioServer('default', 'DashBot Local Server', command, args);
  }
}

final mcpHostServiceProvider = ChangeNotifierProvider<McpHostService>((ref) {
  final host = McpHostService(ref);
  // Initial prime
  host._refreshCapabilities(ref.read(mcpConnectionsProvider));
  return host;
});
