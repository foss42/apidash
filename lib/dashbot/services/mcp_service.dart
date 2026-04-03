import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// StateNotifier was moved to legacy in Riverpod v3
import 'package:flutter_riverpod/legacy.dart' as legacy;
import 'package:mcp_dart/mcp_dart.dart';
import 'package:path_provider/path_provider.dart';
import '../../providers/providers.dart';
import '../../dashbot/repository/chat_remote_repository.dart';
import 'package:apidash_core/apidash_core.dart';

enum TransportType { stdio, sse }

class McpServerConnection {
  final String id;
  final String name;
  final TransportType transportType;
  final String commandOrUrl;
  final List<String> args;
  final bool isEnabled;
  final McpClient? client;
  final Transport? transport;

  const McpServerConnection({
    required this.id,
    required this.name,
    required this.transportType,
    required this.commandOrUrl,
    this.args = const [],
    this.isEnabled = true,
    this.client,
    this.transport,
  });

  McpServerConnection copyWith({
    bool? isEnabled,
    McpClient? client,
    Transport? transport,
    bool clearClient = false,
  }) {
    return McpServerConnection(
      id: id,
      name: name,
      transportType: transportType,
      commandOrUrl: commandOrUrl,
      args: args,
      isEnabled: isEnabled ?? this.isEnabled,
      client: clearClient ? null : (client ?? this.client),
      transport: clearClient ? null : (transport ?? this.transport),
    );
  }
}

class McpConnectionsNotifier
    extends legacy.StateNotifier<Map<String, McpServerConnection>> {
  final Ref _ref;
  McpConnectionsNotifier(this._ref) : super({});

  bool hasServer(String id) => state.containsKey(id);

  Future<void> addStdioServer(
    String id,
    String name,
    String command,
    List<String> args,
  ) async {
    final conn = McpServerConnection(
      id: id,
      name: name,
      transportType: TransportType.stdio,
      commandOrUrl: command,
      args: args,
    );
    state = {...state, id: conn};
    await _connect(id);
  }

  Future<void> addSseServer(String id, String name, String url) async {
    final conn = McpServerConnection(
      id: id,
      name: name,
      transportType: TransportType.sse,
      commandOrUrl: url,
    );
    state = {...state, id: conn};
    await _connect(id);
  }

  Future<void> removeServer(String id) async {
    final conn = state[id];
    if (conn != null) {
      await conn.client?.close();
      final newState = Map<String, McpServerConnection>.from(state)
        ..remove(id);
      state = newState;
    }
  }

  Future<void> toggleServer(String id, bool enabled) async {
    if (!state.containsKey(id)) return;

    state = {...state, id: state[id]!.copyWith(isEnabled: enabled)};

    if (enabled && state[id]!.client == null) {
      await _connect(id);
    } else if (!enabled && state[id]!.client != null) {
      await state[id]!.client?.close();
      state = {...state, id: state[id]!.copyWith(clearClient: true)};
    }
  }

  Future<void> _connect(String id) async {
    final conn = state[id];
    if (conn == null || !conn.isEnabled) return;

    Transport transport;
    if (conn.transportType == TransportType.stdio) {
      transport = StdioClientTransport(
        StdioServerParameters(command: conn.commandOrUrl, args: conn.args),
      );
    } else {
      transport = StreamableHttpClientTransport(Uri.parse(conn.commandOrUrl));
    }

    final client = McpClient(
      const Implementation(name: 'apidash-mcp-client', version: '1.0.0'),
      options: McpClientOptions(
        capabilities: ClientCapabilities(
          roots: const ClientCapabilitiesRoots(listChanged: true),
          sampling: const ClientCapabilitiesSampling(),
        ),
      ),
    );

    // Root handler — provides the workspace folder to servers
    client.setRequestHandler(
      'roots/list',
      (request, extra) async {
        final settings = _ref.read(settingsProvider);
        final path = settings.workspaceFolderPath;
        if (path == null) return ListRootsResult(roots: []);
        
        return ListRootsResult(
          roots: [
            Root(
              uri: Uri.file(path).toString(),
              name: 'Workspace Root',
            ),
          ],
        );
      },
      (params, json, extra) => JsonRpcRequest(id: json?['id'], method: 'roots/list', params: json ?? {}),
    );

    // Sampling handler — forwards requests to the configured LLM
    client.onSamplingRequest = (request) async {
      final repo = _ref.read(chatRepositoryProvider);
      final settings = _ref.read(settingsProvider);
      final aiModelJson = settings.defaultAIModel;
      
      if (aiModelJson == null) {
        throw Exception('No AI model configured for sampling');
      }

      final aiModel = AIRequestModel.fromJson(aiModelJson);
      
      // Combine prompt and messages
      final fullPrompt = StringBuffer();
      if (request.systemPrompt != null) {
        fullPrompt.writeln(request.systemPrompt);
      }
      
      // Basic conversion of MCP messages to LLM prompt for now
      for (final msg in request.messages) {
        final content = msg.content;
        String text = '';
        if (content is SamplingTextContent) {
          text = content.text;
        } else {
          text = content.toString();
        }
        fullPrompt.writeln('${msg.role.name}: $text');
      }

      final enriched = aiModel.copyWith(
        userPrompt: fullPrompt.toString(),
        stream: false,
      );

      final response = await repo.sendChat(request: enriched);
      
      return CreateMessageResult(
        model: aiModel.model ?? 'unknown',
        role: SamplingMessageRole.assistant,
        content: SamplingTextContent(
          text: response ?? 'No response from AI',
        ),
      );
    };

    // Elicitation stub handler
    client.onElicitRequest = (request) async {
      // For now, we still cancel but we could potentially trigger UI logic here
      return ElicitResult.fromJson({'action': 'cancel'});
    };

    try {
      await client.connect(transport);
    } catch (e) {
      // Connection failed — don't crash the notifier
      return;
    }

    state = {
      ...state,
      id: conn.copyWith(client: client, transport: transport),
    };
  }
}

final mcpConnectionsProvider = legacy
    .StateNotifierProvider<McpConnectionsNotifier, Map<String, McpServerConnection>>(
  (ref) => McpConnectionsNotifier(ref),
);


