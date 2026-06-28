import 'html_templates.dart';

class ResourceHandler {
  static Map<String, dynamic> listResources() {
    return {
      "resources": [
        {
          "uri": "ui://apidash-agentic-engine/dashboard/history",
          "name": "API Dash Request History",
          "mimeType": "text/html;profile=mcp-app",
        },
        {
          "uri": "ui://apidash-agentic-engine/workbench/studio",
          "name": "API Dash Studio Workbench",
          "mimeType": "text/html;profile=mcp-app",
        }
      ],
    };
  }

  static Map<String, dynamic> readResource(String uri) {
    if (uri == 'ui://apidash-agentic-engine/dashboard/history') {
      return {
        "contents": [
          {"uri": uri, "mimeType": "text/html;profile=mcp-app", "text": getHistoryAppHtml()},
        ],
      };
    }

    if (uri == 'ui://apidash-agentic-engine/workbench/studio') {
      return {
        "contents": [{"uri": uri, "mimeType": "text/html;profile=mcp-app", "text": getApiDashWorkbenchHtml()}],
      };
    }
    throw Exception("Resource not found: $uri");
  }
}