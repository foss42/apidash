String buildSuggestRequestPrompt({
  String? url,
  String? method,
  Map<String, String>? headersMap,
  String? bodyContentType,
  Map<String, String>? paramsMap,
  String? body,
}) {
  return '''
You are an API assistant.
A developer is testing an API endpoint in an API client.
Based on the provided URL and current request configuration, suggest a correct HTTP request configuration.

<request_context>
URL: \$url
Method: \${method ?? ''}
Headers: \${headersMap ?? {}}
Params: \${paramsMap ?? {}}
Content-Type: \${bodyContentType ?? ''}
Body: \${body ?? ''}
</request_context>

Return structured actions only.
Allowed action types:
update_method
add_header
add_query_param
update_body

Return output strictly in JSON format.
Example response:
{
  "actions": [
    {
      "action": "update_method",
      "value": "POST"
    },
    {
      "action": "add_header",
      "path": "Content-Type",
      "value": "application/json"
    },
    {
      "action": "add_query_param",
      "path": "userId",
      "value": "123"
    }
  ]
}
''';
}
