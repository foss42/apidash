import 'html_templates.dart';

class ResourceHandler {
  static Map<String, dynamic> listResources() {
    return {
      "resources": [
        {
          "uri": "ui://apidash-agentic-engine/dashboard/results",
          "name": "API Dash Results Analyzer",
          "mimeType": "text/html;profile=mcp-app",
        },
        {
          "uri": "ui://apidash-agentic-engine/dashboard/history",
          "name": "API Dash Request History",
          "mimeType": "text/html;profile=mcp-app",
        }
      ],
    };
  }

  static Map<String, dynamic> readResource(String uri) {
    if (uri == 'ui://apidash-agentic-engine/dashboard/results') {
      return {
        "contents": [
          {"uri": uri, "mimeType": "text/html;profile=mcp-app", "text": getApiDashAppHtml()},
        ],
      };
    }

    if (uri == 'ui://apidash-agentic-engine/dashboard/history') {
      return {
        "contents": [
          {"uri": uri, "mimeType": "text/html;profile=mcp-app", "text": getHistoryAppHtml()},
        ],
      };
    }
    throw Exception("Resource not found: $uri");
  }
}