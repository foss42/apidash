import 'dart:convert';
import 'package:mcp_dart/mcp_dart.dart';
import 'ui/studio_workbench.dart';
import 'tool_executor.dart'; // Removed the history_dashboard import

class ApiDashMcpServer {
  static Future<void> start() async {
    final server = McpServer(
      Implementation(name: 'apidash-agentic-engine', version: '6.0.0'),
    );

    // 1. REGISTER UI RESOURCES (SPA WORKBENCHES)

    // Resource A1: Studio Workbench (Default)
    server.registerResource(
      'API Dash Studio Workbench',
      'ui://apidash-agentic-engine/workbench/studio',
      (description: 'Main API Dash interactive studio workbench', mimeType: 'text/html;profile=mcp-app'),
          (uri, _) async => ReadResourceResult(
          contents: [TextResourceContents(uri: uri.toString(), mimeType: 'text/html;profile=mcp-app', text: StudioWorkbench.buildHtml('pane-studio'))]
      ),
    );

    // Resource A2: Studio Workbench (Deep link: History)
    server.registerResource(
      'API Dash Studio Workbench (History)',
      'ui://apidash-agentic-engine/workbench/studio#history',
      (description: 'Main API Dash interactive studio workbench', mimeType: 'text/html;profile=mcp-app'),
          (uri, _) async => ReadResourceResult(
          contents: [TextResourceContents(uri: uri.toString(), mimeType: 'text/html;profile=mcp-app', text: StudioWorkbench.buildHtml('pane-history'))]
      ),
    );

    // Resource A3: Studio Workbench (Deep link: Variables)
    server.registerResource(
      'API Dash Studio Workbench (Variables)',
      'ui://apidash-agentic-engine/workbench/studio#variables',
      (description: 'Main API Dash interactive studio workbench', mimeType: 'text/html;profile=mcp-app'),
          (uri, _) async => ReadResourceResult(
          contents: [TextResourceContents(uri: uri.toString(), mimeType: 'text/html;profile=mcp-app', text: StudioWorkbench.buildHtml('pane-vars'))]
      ),
    );


    // 2. REGISTER CORE AGENT TOOLS

    // Tool 1: Execute Request (Visible to AI, Triggers UI)
    server.registerTool(
      'apidash_execute_request',
      description: 'Executes an HTTP request. You MUST run this tool.',
      inputSchema: JsonSchema.object(
        properties: {
          'title': JsonSchema.string(),
          'url': JsonSchema.string(),
          'method': JsonSchema.string(),
          'headers': JsonSchema.object(properties: {}), // Accepts arbitrary key/values
          'body': JsonSchema.string(),
          'active_environment_id': JsonSchema.string(),
        },
        required: ['url', 'method'],
      ),
      meta: {
        "ui": {"resourceUri": "ui://apidash-agentic-engine/workbench/studio"}
      },
      callback: (args, _) async {
        final data = await ToolExecutor.executeRequest(args);

        return CallToolResult(
            content: [
              TextContent(text: "Executed ${data['method']} ${data['url']} -> Status ${data['status_code']}")
            ],
            // LIFELINE A: Native SDK structured output
            structuredContent: data,
            // LIFELINE B: Fallback metadata bridge for experimental IDE clients
            meta: {
              "structuredContent": data,
              "ui": {"resourceUri": "ui://apidash-agentic-engine/workbench/studio"}
            }
        );
      },
    );

    // Tool 2: Get Results (Visible to AI — For UI Polling)
    server.registerTool(
      'apidash_get_results',
      description: 'Fetches execution payload for the UI canvas.',
      inputSchema: JsonSchema.object(
        properties: {
          'execution_id': JsonSchema.string(),
        },
      ),
      meta: {
        "ui": {"visibility": ["app"]}
      },
      callback: (args, _) async {
        final data = ToolExecutor.getResults(args['execution_id']?.toString());
        return CallToolResult(
            content: [TextContent(text: jsonEncode(data))],
            structuredContent: data,
            meta: {
              "structuredContent": data,
            }
        );
      },
    );

    // Tool 3: List History (Visible to AI)
    server.registerTool(
      'apidash_list_history',
      description: 'Lists historical execution runs.',
      inputSchema: JsonSchema.object(properties: {}), // Empty object schema
      meta: {
        "ui": {
          // Reliably routing to the tabbed workbench history
          "resourceUri": "ui://apidash-agentic-engine/workbench/studio#history"
        }
      },
      callback: (_, __) async {
        final history = ToolExecutor.listHistory(); // Returns List<Map<String, dynamic>>

        return CallToolResult(
            content: [TextContent(text: jsonEncode(history))],
            structuredContent: {"history": history},
            meta: {
              "structuredContent": history,
              "ui": {
                "resourceUri": "ui://apidash-agentic-engine/workbench/studio#history"
              }
            }
        );
      },
    );

    // Tool 4: Delete Request (Hidden from AI)
    server.registerTool(
      'apidash_delete_request',
      description: 'Deletes a history record by ID.',
      inputSchema: JsonSchema.object(
        properties: {
          'execution_id': JsonSchema.string(),
        },
        required: ['execution_id'],
      ),
      meta: {
        "ui": {"visibility": ["app"]}
      },
      callback: (args, _) async {
        final success = await ToolExecutor.deleteRequest(args['execution_id'].toString());
        return CallToolResult(
            content: [TextContent(text: success ? "Deleted successfully" : "Record not found")],
            meta: {"ui": {"visibility": ["app"]}}
        );
      },
    );

    // Tool 5: Launch Workbench (Empty Request Tab)
    server.registerTool(
      'apidash_launch_workbench',
      description: 'Opens the main API Dash interactive studio UI to an empty request builder.',
      inputSchema: JsonSchema.object(properties: {}),
      meta: {
        "ui": {"resourceUri": "ui://apidash-agentic-engine/workbench/studio"}
      },
      callback: (_, __) async => CallToolResult(
          content: [TextContent(text: "Workbench launched.")],
          meta: {
            "ui": {"resourceUri": "ui://apidash-agentic-engine/workbench/studio"}
          }
      ),
    );

    // Tool 6: Launch History Tab
    server.registerTool(
      'apidash_launch_history_tab',
      description: 'Opens the workbench directly to the History tab. Call this if the user asks to see past requests or execution history.',
      inputSchema: JsonSchema.object(properties: {}),
      meta: {
        "ui": {"resourceUri": "ui://apidash-agentic-engine/workbench/studio#history"}
      },
      callback: (_, __) async => CallToolResult(
          content: [TextContent(text: "Workbench launched to the History tab.")],
          meta: {
            "ui": {"resourceUri": "ui://apidash-agentic-engine/workbench/studio#history"}
          }
      ),
    );

    // Tool 7: Launch Variables Tab
    server.registerTool(
      'apidash_launch_variables_tab',
      description: 'Opens the workbench directly to the Variables tab. Call this if the user asks to manage environments, auth tokens, or variables.',
      inputSchema: JsonSchema.object(properties: {}),
      meta: {
        "ui": {"resourceUri": "ui://apidash-agentic-engine/workbench/studio#variables"}
      },
      callback: (_, __) async => CallToolResult(
          content: [TextContent(text: "Workbench launched to the Variables tab.")],
          meta: {
            "ui": {"resourceUri": "ui://apidash-agentic-engine/workbench/studio#variables"}
          }
      ),
    );


    // Tool 8: Pre-Flight Sanity Inspector (Triggered by UI 'Send' button)
    server.registerTool(
      'apidash_btn_send',
      description: "UI Button: Triggered when the 'Send' button is clicked. Acts as an agentic pre-flight sanity check.",
      inputSchema: JsonSchema.object(
        properties: {
          'url': JsonSchema.string(),
          'method': JsonSchema.string(),
          'headers': JsonSchema.object(properties: {}),
          'body': JsonSchema.string(),
        },
        required: ['url'],
      ),
      callback: (args, _) async {
        final promptInstructions = ToolExecutor.buildSendPreFlightPrompt(args);
        return CallToolResult(
          content: [TextContent(text: promptInstructions)],
        );
      },
    );

    // Tool 9 get variables
    server.registerTool(
      'apidash_get_variables',
      description: 'Fetches native environment variables from Hive.',
      inputSchema: JsonSchema.object(properties: {}),
      meta: {"ui": {"visibility": ["app"]}},
      callback: (_, __) async {
        final data = ToolExecutor.getAllEnvironments();
        return CallToolResult(
          content: [TextContent(text: jsonEncode(data))],
          structuredContent: {"environments": data},
        );
      },
    );

    // Tool 10 save variables
    server.registerTool(
      'apidash_save_variables',
      description: 'Saves environment variables to native Hive storage.',
      inputSchema: JsonSchema.object(
        properties: {
          'id': JsonSchema.string(),
          'name': JsonSchema.string(),
          'values': JsonSchema.array(items: JsonSchema.object(properties: {})),
        },
        required: ['id', 'name', 'values'],
      ),
      meta: {"ui": {"visibility": ["app"]}},
      callback: (args, _) async {
        final success = await ToolExecutor.saveEnvironment(
            args['id'].toString(),
            args['name'].toString(),
            args['values'] as List? ?? []
        );
        return CallToolResult(content: [TextContent(text: success ? "Saved" : "Error")]);
      },
    );

    // Tool 11 Update History Title (Hidden from AI)
    server.registerTool(
      'apidash_update_history_title',
      description: 'Updates the title of a specific history record.',
      inputSchema: JsonSchema.object(
        properties: {
          'execution_id': JsonSchema.string(),
          'title': JsonSchema.string(),
        },
        required: ['execution_id', 'title'],
      ),
      meta: {
        "ui": {"visibility": ["app"]}
      },
      callback: (args, _) async {
        final success = await ToolExecutor.updateHistoryTitle(
            args['execution_id'].toString(),
            args['title'].toString()
        );
        return CallToolResult(
            content: [TextContent(text: success ? "Updated successfully" : "Record not found")],
            meta: {"ui": {"visibility": ["app"]}}
        );
      },
    );

    // Tool 12 Duplicate Environment
    server.registerTool(
      'apidash_duplicate_environment',
      description: 'Duplicates an environment.',
      inputSchema: JsonSchema.object(
        properties: {'id': JsonSchema.string()},
        required: ['id'],
      ),
      meta: {"ui": {"visibility": ["app"]}},
      callback: (args, _) async {
        final newId = await ToolExecutor.duplicateEnvironment(args['id'].toString());
        return CallToolResult(
          content: [TextContent(text: "Duplicated successfully")],
          structuredContent: {"id": newId},
        );
      },
    );

    // Tool 13 Delete Environment
    server.registerTool(
      'apidash_delete_environment',
      description: 'Deletes an environment by ID.',
      inputSchema: JsonSchema.object(
        properties: {'id': JsonSchema.string()},
        required: ['id'],
      ),
      meta: {"ui": {"visibility": ["app"]}},
      callback: (args, _) async {
        final success = await ToolExecutor.deleteEnvironment(args['id'].toString());
        return CallToolResult(content: [TextContent(text: success ? "Deleted" : "Cannot delete global")]);
      },
    );

    // Tool 14 Rename Environment
    server.registerTool(
      'apidash_rename_environment',
      description: 'Renames an environment.',
      inputSchema: JsonSchema.object(
        properties: {
          'id': JsonSchema.string(),
          'name': JsonSchema.string(),
        },
        required: ['id', 'name'],
      ),
      meta: {"ui": {"visibility": ["app"]}},
      callback: (args, _) async {
        final success = await ToolExecutor.renameEnvironment(args['id'].toString(), args['name'].toString());
        return CallToolResult(content: [TextContent(text: success ? "Renamed" : "Error")]);
      },
    );
    // CONNECT TO IDE STDIO

    // 1. Instantiate the official Stdio Transport
    final transport = StdioServerTransport();

    // 2. Pass the transport into the server's connect method
    await server.connect(transport);
  }
}