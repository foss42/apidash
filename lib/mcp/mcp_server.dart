import 'dart:convert';
import 'package:mcp_dart/mcp_dart.dart';
import 'resources/html_templates.dart';
import 'tool_executor.dart';

class ApiDashMcpServer {
  static Future<void> start() async {
    final server = McpServer(
      Implementation(name: 'apidash-agentic-engine', version: '6.0.0'),
    );

// 1. REGISTER UI RESOURCES (SPA WORKBENCHES)

// Resource A: Studio Workbench
    server.registerResource(
      'API Dash Studio Workbench',                            // Arg 1: name
      'ui://apidash-agentic-engine/workbench/studio',         // Arg 2: uri
      (                                                       // Arg 3: metadata
      description: 'Main API Dash interactive studio workbench',
      mimeType: 'text/html;profile=mcp-app',
      ),
          (uri, _) async => ReadResourceResult(                   // Arg 4: readCallback
        contents: [
          TextResourceContents(
            uri: uri.toString(),
            mimeType: 'text/html;profile=mcp-app',
            text: getApiDashWorkbenchHtml(),
          )
        ],
      ),
    );

// Resource B: Request History
    server.registerResource(
      'API Dash Request History',
      'ui://apidash-agentic-engine/dashboard/history',
      (
      description: 'Execution history dashboard',
      mimeType: 'text/html;profile=mcp-app',
      ),
          (uri, _) async => ReadResourceResult(
        contents: [
          TextResourceContents(
            uri: uri.toString(),
            mimeType: 'text/html;profile=mcp-app',
            text: getHistoryAppHtml(),
          )
        ],
      ),
    );


    // 2. REGISTER CORE AGENT TOOLS


// Tool 1: Execute Request (Visible to AI, Triggers UI)
    server.registerTool(
      'apidash_execute_request',
      description: 'Executes an HTTP request. You MUST run this tool.',
      inputSchema: JsonSchema.object(
        properties: {
          'url': JsonSchema.string(),
          'method': JsonSchema.string(),
          'headers': JsonSchema.object(properties: {}), // Accepts arbitrary key/values
          'body': JsonSchema.string(),
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

// Tool 2: Get Results (Hidden from AI — For UI Polling)
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
              "ui": {"visibility": ["app"]}
            }
        );
      },
    );

// Tool 3: List History (Hidden from AI)
    server.registerTool(
      'apidash_list_history',
      description: 'Lists historical execution runs.',
      inputSchema: JsonSchema.object(properties: {}), // Empty object schema
      meta: {
        "ui": {
          "visibility": ["app"],
          "resourceUri": "ui://apidash-agentic-engine/dashboard/history"
        }
      },
      // Inside server.registerTool('apidash_list_history', ...)

      callback: (_, __) async {
        final history = ToolExecutor.listHistory(); // Returns List<Map<String, dynamic>>

        return CallToolResult(
            content: [TextContent(text: jsonEncode(history))],

            structuredContent: {"history": history},

            meta: {
              "structuredContent": history,
              "ui": {
                "visibility": ["app"],
                "resourceUri": "ui://apidash-agentic-engine/dashboard/history"
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

// Tool 5: Launch Workbench (Manual Trigger)
    server.registerTool(
      'apidash_launch_workbench',
      description: 'Opens the main API Dash interactive studio UI.',
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

// Tool 6: Pre-Flight Sanity Inspector (Triggered by UI 'Send' button)
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

// CONNECT TO IDE STDIO

// 1. Instantiate the official Stdio Transport
    final transport = StdioServerTransport();

// 2. Pass the transport into the server's connect method
    await server.connect(transport);

  }
}