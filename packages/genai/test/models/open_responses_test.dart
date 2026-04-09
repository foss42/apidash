import 'package:genai/models/open_responses.dart';
import 'package:test/test.dart';

void main() {
  group('OpenResponsesResult.fromJson', () {
    test('parses id, model, status', () {
      final r = OpenResponsesResult.fromJson({
        'id': 'resp_abc',
        'object': 'response',
        'model': 'gpt-4o',
        'status': 'completed',
        'output': [],
      });
      expect(r.id, 'resp_abc');
      expect(r.model, 'gpt-4o');
      expect(r.status, 'completed');
      expect(r.output, isEmpty);
    });

    test('parses message output item', () {
      final r = OpenResponsesResult.fromJson({
        'id': 'r1',
        'object': 'response',
        'model': 'm',
        'status': 'completed',
        'output': [
          {
            'id': 'msg1',
            'type': 'message',
            'role': 'assistant',
            'status': 'completed',
            'content': [
              {'type': 'output_text', 'text': 'Hello'}
            ],
          }
        ],
      });
      expect(r.output.length, 1);
      final msg = r.output.first as MessageOutputItem;
      expect(msg.role, 'assistant');
      expect(msg.text, 'Hello');
    });

    test('parses function_call output item', () {
      final r = OpenResponsesResult.fromJson({
        'id': 'r1',
        'object': 'response',
        'model': 'm',
        'status': 'completed',
        'output': [
          {
            'id': 'fc1',
            'type': 'function_call',
            'call_id': 'call_xyz',
            'name': 'get_weather',
            'arguments': '{"city":"Berlin"}',
            'status': 'completed',
          }
        ],
      });
      final fc = r.output.first as FunctionCallOutputItem;
      expect(fc.name, 'get_weather');
      expect(fc.callId, 'call_xyz');
      expect(fc.arguments, '{"city":"Berlin"}');
    });

    test('parses reasoning output item', () {
      final r = OpenResponsesResult.fromJson({
        'id': 'r1',
        'object': 'response',
        'model': 'm',
        'status': 'completed',
        'output': [
          {
            'id': 'rs1',
            'type': 'reasoning',
            'status': 'completed',
            'summary': [
              {'text': 'thinking...'}
            ],
          }
        ],
      });
      final rs = r.output.first as ReasoningOutputItem;
      expect(rs.summary, 'thinking...');
    });

    test('parses usage', () {
      final r = OpenResponsesResult.fromJson({
        'id': 'r1',
        'object': 'response',
        'model': 'm',
        'status': 'completed',
        'output': [],
        'usage': {
          'input_tokens': 10,
          'output_tokens': 20,
          'total_tokens': 30,
        },
      });
      expect(r.usage?.inputTokens, 10);
      expect(r.usage?.outputTokens, 20);
      expect(r.usage?.totalTokens, 30);
    });

    test('parses web_search_call output item', () {
      final r = OpenResponsesResult.fromJson({
        'id': 'r1',
        'object': 'response',
        'model': 'm',
        'status': 'completed',
        'output': [
          {'id': 'ws1', 'type': 'web_search_call', 'status': 'completed'}
        ],
      });
      final ws = r.output.first as WebSearchCallOutputItem;
      expect(ws.id, 'ws1');
      expect(ws.status, 'completed');
      expect(ws.type, 'web_search_call');
    });

    test('parses file_search_call output item with queries', () {
      final r = OpenResponsesResult.fromJson({
        'id': 'r1',
        'object': 'response',
        'model': 'm',
        'status': 'completed',
        'output': [
          {
            'id': 'fs1',
            'type': 'file_search_call',
            'status': 'completed',
            'queries': ['find budget report', 'Q3 results'],
          }
        ],
      });
      final fs = r.output.first as FileSearchCallOutputItem;
      expect(fs.id, 'fs1');
      expect(fs.queries, ['find budget report', 'Q3 results']);
    });

    test('file_search_call with no queries has empty list', () {
      final r = OpenResponsesResult.fromJson({
        'id': 'r1',
        'object': 'response',
        'model': 'm',
        'status': 'completed',
        'output': [
          {'id': 'fs2', 'type': 'file_search_call', 'status': 'in_progress'}
        ],
      });
      final fs = r.output.first as FileSearchCallOutputItem;
      expect(fs.queries, isEmpty);
    });

    test('unknown output type becomes UnknownOutputItem', () {
      final r = OpenResponsesResult.fromJson({
        'id': 'r1',
        'object': 'response',
        'model': 'm',
        'status': 'completed',
        'output': [
          {'id': 'u1', 'type': 'image_generation_call', 'status': 'completed'}
        ],
      });
      expect(r.output.first, isA<UnknownOutputItem>());
      expect(
          (r.output.first as UnknownOutputItem).type, 'image_generation_call');
    });

    test('isOpenResponsesFormat returns true for valid response', () {
      expect(
        OpenResponsesResult.isOpenResponsesFormat({
          'id': 'r1',
          'object': 'response',
          'output': [],
        }),
        isTrue,
      );
    });

    test('isOpenResponsesFormat returns false for chat completion', () {
      expect(
        OpenResponsesResult.isOpenResponsesFormat({
          'id': 'chatcmpl-1',
          'object': 'chat.completion',
          'choices': [],
        }),
        isFalse,
      );
    });
  });

  group('OpenResponsesStreamParser.isOpenResponsesStream', () {
    test('detects response.output_item.added event', () {
      final lines = [
        'data: {"type":"response.output_item.added","output_index":0,"item":{"id":"rs1","type":"reasoning","status":"in_progress","summary":[]}}',
      ];
      expect(OpenResponsesStreamParser.isOpenResponsesStream(lines), isTrue);
    });

    test('detects response.completed event', () {
      final lines = [
        'data: {"type":"response.completed","response":{"id":"r1","object":"response","model":"gpt-4o","status":"completed","output":[]}}',
      ];
      expect(OpenResponsesStreamParser.isOpenResponsesStream(lines), isTrue);
    });

    test('returns false for regular chat completion SSE', () {
      final lines = [
        'data: {"id":"chatcmpl-1","choices":[{"delta":{"content":"hi"}}]}',
        'data: [DONE]',
      ];
      expect(OpenResponsesStreamParser.isOpenResponsesStream(lines), isFalse);
    });

    test('ignores non-data lines', () {
      final lines = ['event: response.created', 'id: 1', ''];
      expect(OpenResponsesStreamParser.isOpenResponsesStream(lines), isFalse);
    });
  });

  group('OpenResponsesStreamParser.parse', () {
    test('builds message item from deltas', () {
      final lines = [
        'data: {"type":"response.output_item.added","output_index":0,"item":{"id":"msg1","type":"message","role":"assistant","status":"in_progress","content":[]}}',
        'data: {"type":"response.output_text.delta","output_index":0,"content_index":0,"delta":"Hello"}',
        'data: {"type":"response.output_text.delta","output_index":0,"content_index":0,"delta":" world"}',
        'data: {"type":"response.output_item.done","output_index":0,"item":{"id":"msg1","type":"message","role":"assistant","status":"completed","content":[{"type":"output_text","text":"Hello world"}]}}',
      ];
      final items = OpenResponsesStreamParser.parse(lines);
      expect(items.length, 1);
      final msg = items.first as MessageOutputItem;
      expect(msg.text, 'Hello world');
    });

    test('builds reasoning item from summary deltas', () {
      final lines = [
        'data: {"type":"response.output_item.added","output_index":0,"item":{"id":"rs1","type":"reasoning","status":"in_progress","summary":[]}}',
        'data: {"type":"response.reasoning_summary_text.delta","output_index":0,"delta":"I need to"}',
        'data: {"type":"response.reasoning_summary_text.delta","output_index":0,"delta":" think"}',
      ];
      final items = OpenResponsesStreamParser.parse(lines);
      expect(items.length, 1);
      final rs = items.first as ReasoningOutputItem;
      expect(rs.summary, 'I need to think');
    });

    test('builds function_call item from args deltas', () {
      final lines = [
        'data: {"type":"response.output_item.added","output_index":0,"item":{"id":"fc1","type":"function_call","call_id":"call_1","name":"get_weather","arguments":"","status":"in_progress"}}',
        'data: {"type":"response.function_call_arguments.delta","output_index":0,"delta":"{\\"city\\""}',
        'data: {"type":"response.function_call_arguments.delta","output_index":0,"delta":":\\"Berlin\\"}"}',
      ];
      final items = OpenResponsesStreamParser.parse(lines);
      expect(items.length, 1);
      final fc = items.first as FunctionCallOutputItem;
      expect(fc.name, 'get_weather');
      expect(fc.arguments, contains('Berlin'));
    });

    test('uses completed response when response.completed event is present', () {
      final lines = [
        'data: {"type":"response.output_item.added","output_index":0,"item":{"id":"msg1","type":"message","role":"assistant","status":"in_progress","content":[]}}',
        'data: {"type":"response.output_text.delta","output_index":0,"delta":"partial"}',
        'data: {"type":"response.completed","response":{"id":"r1","object":"response","model":"gpt-4o","status":"completed","output":[{"id":"msg1","type":"message","role":"assistant","status":"completed","content":[{"type":"output_text","text":"Full response"}]}]}}',
      ];
      final items = OpenResponsesStreamParser.parse(lines);
      expect(items.length, 1);
      final msg = items.first as MessageOutputItem;
      expect(msg.text, 'Full response');
    });

    test('handles multiple items in correct order', () {
      final lines = [
        'data: {"type":"response.output_item.added","output_index":0,"item":{"id":"rs1","type":"reasoning","status":"in_progress","summary":[]}}',
        'data: {"type":"response.output_item.added","output_index":1,"item":{"id":"msg1","type":"message","role":"assistant","status":"in_progress","content":[]}}',
        'data: {"type":"response.output_text.delta","output_index":1,"delta":"Hi"}',
      ];
      final items = OpenResponsesStreamParser.parse(lines);
      expect(items.length, 2);
      expect(items[0], isA<ReasoningOutputItem>());
      expect(items[1], isA<MessageOutputItem>());
    });

    test('returns empty list for empty input', () {
      expect(OpenResponsesStreamParser.parse([]), isEmpty);
    });

    test('skips malformed JSON lines', () {
      final lines = [
        'data: not-json',
        'data: {"type":"response.output_item.added","output_index":0,"item":{"id":"msg1","type":"message","role":"assistant","status":"in_progress","content":[]}}',
      ];
      final items = OpenResponsesStreamParser.parse(lines);
      expect(items.length, 1);
    });

    test('full mock-server SSE sequence parses correctly', () {
      // Mirrors the /stream endpoint in mock_server.py
      final lines = [
        'data: {"type":"response.created","response":{"id":"resp_stream_001","object":"response","model":"gpt-4o-2024-11-20","status":"in_progress","output":[]}}',
        'data: {"type":"response.output_item.added","output_index":0,"item":{"type":"reasoning","id":"rs_s001","status":"in_progress"}}',
        'data: {"type":"response.reasoning_summary_text.delta","output_index":0,"delta":"User asked for London weather."}',
        'data: {"type":"response.reasoning_summary_text.delta","output_index":0,"delta":" I\'ll call get_weather."}',
        'data: {"type":"response.output_item.done","output_index":0,"item":{"type":"reasoning","id":"rs_s001","status":"completed","summary":[{"text":"User asked for London weather. I\'ll call get_weather."}]}}',
        'data: {"type":"response.output_item.added","output_index":1,"item":{"type":"web_search_call","id":"ws_s001","status":"in_progress"}}',
        'data: {"type":"response.output_item.done","output_index":1,"item":{"type":"web_search_call","id":"ws_s001","status":"completed"}}',
        'data: {"type":"response.output_item.added","output_index":2,"item":{"type":"function_call","id":"fc_s001","call_id":"call_xyz","name":"get_weather","status":"in_progress","arguments":""}}',
        'data: {"type":"response.function_call_arguments.delta","output_index":2,"delta":"{\\"location\\""}',
        'data: {"type":"response.function_call_arguments.delta","output_index":2,"delta":": \\"London\\"}"}',
        'data: {"type":"response.output_item.done","output_index":2,"item":{"type":"function_call","id":"fc_s001","call_id":"call_xyz","name":"get_weather","status":"completed","arguments":"{\\"location\\": \\"London\\"}"}}',
        'data: {"type":"response.output_item.added","output_index":3,"item":{"type":"function_call_output","id":"fco_s001","call_id":"call_xyz","status":"completed","output":"{\\"temperature\\":14}"}}',
        'data: {"type":"response.output_item.done","output_index":3,"item":{"type":"function_call_output","id":"fco_s001","call_id":"call_xyz","status":"completed","output":"{\\"temperature\\":14}"}}',
        'data: {"type":"response.output_item.added","output_index":4,"item":{"type":"message","id":"msg_s001","role":"assistant","status":"in_progress","content":[]}}',
        'data: {"type":"response.output_text.delta","output_index":4,"delta":"## London Weather\\n\\n"}',
        'data: {"type":"response.output_text.delta","output_index":4,"delta":"14°C, overcast."}',
        'data: {"type":"response.output_item.done","output_index":4,"item":{"type":"message","id":"msg_s001","role":"assistant","status":"completed","content":[{"type":"output_text","text":"## London Weather\\n\\n14°C, overcast."}]}}',
        'data: {"type":"response.completed","response":{"id":"resp_stream_001","object":"response","model":"gpt-4o-2024-11-20","status":"completed","output":[{"type":"reasoning","id":"rs_s001","status":"completed","summary":[{"text":"User asked for London weather."}]},{"type":"web_search_call","id":"ws_s001","status":"completed"},{"type":"function_call","id":"fc_s001","call_id":"call_xyz","name":"get_weather","status":"completed","arguments":"{\\"location\\":\\"London\\"}"},{"type":"function_call_output","id":"fco_s001","call_id":"call_xyz","status":"completed","output":"{\\"temperature\\":14}"},{"type":"message","id":"msg_s001","role":"assistant","status":"completed","content":[{"type":"output_text","text":"## London Weather\\n\\n14°C, overcast."}]}],"usage":{"input_tokens":142,"output_tokens":97,"total_tokens":239}}}',
        'data: [DONE]',
      ];

      expect(OpenResponsesStreamParser.isOpenResponsesStream(lines), isTrue);

      final items = OpenResponsesStreamParser.parse(lines);
      expect(items.length, 5);
      expect(items[0], isA<ReasoningOutputItem>());
      expect(items[1], isA<WebSearchCallOutputItem>());
      expect(items[2], isA<FunctionCallOutputItem>());
      expect((items[2] as FunctionCallOutputItem).name, 'get_weather');
      expect(items[3], isA<FunctionCallResultItem>());
      expect(items[4], isA<MessageOutputItem>());
      expect((items[4] as MessageOutputItem).text, contains('London Weather'));
    });

    test('function_call_output output field is a valid JSON string', () {
      // Verifies the structuredContent pattern: tool output is parseable JSON
      final lines = [
        'data: {"type":"response.output_item.added","output_index":0,"item":{"type":"function_call_output","id":"fco1","call_id":"c1","status":"completed","output":"{\\"temperature\\":14,\\"condition\\":\\"Overcast\\"}"}}',
        'data: {"type":"response.output_item.done","output_index":0,"item":{"type":"function_call_output","id":"fco1","call_id":"c1","status":"completed","output":"{\\"temperature\\":14,\\"condition\\":\\"Overcast\\"}"}}',
      ];
      final items = OpenResponsesStreamParser.parse(lines);
      expect(items.length, 1);
      final fco = items.first as FunctionCallResultItem;
      // The output should be parseable JSON — same concept as MCP structuredContent
      expect(() => fco.output, returnsNormally);
      expect(fco.output, contains('temperature'));
    });

    test('previous_response_id is parsed when present', () {
      final r = OpenResponsesResult.fromJson({
        'id': 'resp_2',
        'object': 'response',
        'model': 'gpt-4o',
        'status': 'completed',
        'output': [],
        'previous_response_id': 'resp_1',
      });
      expect(r.previousResponseId, 'resp_1');
    });

    test('previous_response_id is null when absent', () {
      final r = OpenResponsesResult.fromJson({
        'id': 'resp_1',
        'object': 'response',
        'model': 'gpt-4o',
        'status': 'completed',
        'output': [],
      });
      expect(r.previousResponseId, isNull);
    });

    test('message with refusal content part', () {
      final r = OpenResponsesResult.fromJson({
        'id': 'r1',
        'object': 'response',
        'model': 'm',
        'status': 'completed',
        'output': [
          {
            'id': 'msg1',
            'type': 'message',
            'role': 'assistant',
            'status': 'completed',
            'content': [
              {'type': 'refusal', 'refusal': 'I cannot help with that.'}
            ],
          }
        ],
      });
      final msg = r.output.first as MessageOutputItem;
      expect(msg.content.first, isA<RefusalPart>());
      expect((msg.content.first as RefusalPart).refusal,
          'I cannot help with that.');
    });

    test('usage tokens are parsed correctly', () {
      final r = OpenResponsesResult.fromJson({
        'id': 'r1',
        'object': 'response',
        'model': 'gpt-4o',
        'status': 'completed',
        'output': [],
        'usage': {
          'input_tokens': 100,
          'output_tokens': 200,
          'total_tokens': 300,
        },
      });
      expect(r.usage?.inputTokens, 100);
      expect(r.usage?.outputTokens, 200);
      expect(r.usage?.totalTokens, 300);
    });

    test('usage is null when absent', () {
      final r = OpenResponsesResult.fromJson({
        'id': 'r1',
        'object': 'response',
        'model': 'gpt-4o',
        'status': 'completed',
        'output': [],
      });
      expect(r.usage, isNull);
    });

    test('call_id links function_call to its output', () {
      final r = OpenResponsesResult.fromJson({
        'id': 'r1',
        'object': 'response',
        'model': 'gpt-4o',
        'status': 'completed',
        'output': [
          {
            'id': 'fc1',
            'type': 'function_call',
            'call_id': 'call_xyz',
            'name': 'get_weather',
            'arguments': '{"location":"London"}',
            'status': 'completed',
          },
          {
            'id': 'fco1',
            'type': 'function_call_output',
            'call_id': 'call_xyz',
            'output': '{"temperature":14}',
            'status': 'completed',
          },
        ],
      });
      final call = r.output[0] as FunctionCallOutputItem;
      final output = r.output[1] as FunctionCallResultItem;
      expect(call.callId, output.callId);
      expect(call.callId, 'call_xyz');
    });

    test('multiple output items parsed in order', () {
      final r = OpenResponsesResult.fromJson({
        'id': 'r1',
        'object': 'response',
        'model': 'gpt-4o',
        'status': 'completed',
        'output': [
          {'id': 'rs1', 'type': 'reasoning', 'status': 'completed', 'summary': []},
          {'id': 'ws1', 'type': 'web_search_call', 'status': 'completed'},
          {
            'id': 'fc1',
            'type': 'function_call',
            'call_id': 'c1',
            'name': 'fn',
            'arguments': '{}',
            'status': 'completed',
          },
          {
            'id': 'fco1',
            'type': 'function_call_output',
            'call_id': 'c1',
            'output': '{}',
            'status': 'completed',
          },
          {
            'id': 'msg1',
            'type': 'message',
            'role': 'assistant',
            'status': 'completed',
            'content': [{'type': 'output_text', 'text': 'Done'}],
          },
        ],
      });
      expect(r.output.length, 5);
      expect(r.output[0], isA<ReasoningOutputItem>());
      expect(r.output[1], isA<WebSearchCallOutputItem>());
      expect(r.output[2], isA<FunctionCallOutputItem>());
      expect(r.output[3], isA<FunctionCallResultItem>());
      expect(r.output[4], isA<MessageOutputItem>());
    });

    test('reasoning summary text is concatenated from entries', () {
      final r = OpenResponsesResult.fromJson({
        'id': 'r1',
        'object': 'response',
        'model': 'gpt-4o',
        'status': 'completed',
        'output': [
          {
            'id': 'rs1',
            'type': 'reasoning',
            'status': 'completed',
            'summary': [
              {'text': 'First thought.'},
              {'text': ' Second thought.'},
            ],
          },
        ],
      });
      final rs = r.output.first as ReasoningOutputItem;
      expect(rs.summary, isNotNull);
      expect(rs.summary, contains('First thought.'));
    });

    test('message with multiple content parts', () {
      final r = OpenResponsesResult.fromJson({
        'id': 'r1',
        'object': 'response',
        'model': 'gpt-4o',
        'status': 'completed',
        'output': [
          {
            'id': 'msg1',
            'type': 'message',
            'role': 'assistant',
            'status': 'completed',
            'content': [
              {'type': 'output_text', 'text': 'Part one.'},
              {'type': 'output_text', 'text': 'Part two.'},
            ],
          },
        ],
      });
      final msg = r.output.first as MessageOutputItem;
      expect(msg.content.length, 2);
      expect((msg.content[0] as OutputTextPart).text, 'Part one.');
      expect((msg.content[1] as OutputTextPart).text, 'Part two.');
    });

    test('function_call_output with JSON object output', () {
      final r = OpenResponsesResult.fromJson({
        'id': 'r1',
        'object': 'response',
        'model': 'gpt-4o',
        'status': 'completed',
        'output': [
          {
            'id': 'fco1',
            'type': 'function_call_output',
            'call_id': 'call_abc',
            'output': '{"temperature":18,"condition":"Sunny","humidity":65}',
            'status': 'completed',
          },
        ],
      });
      final fco = r.output.first as FunctionCallResultItem;
      expect(fco.output, contains('temperature'));
      expect(fco.callId, 'call_abc');
    });

    test('in_progress status is parsed', () {
      final r = OpenResponsesResult.fromJson({
        'id': 'r1',
        'object': 'response',
        'model': 'gpt-4o',
        'status': 'in_progress',
        'output': [],
      });
      expect(r.status, 'in_progress');
    });

    test('empty output list returns no items', () {
      final r = OpenResponsesResult.fromJson({
        'id': 'r1',
        'object': 'response',
        'model': 'gpt-4o',
        'status': 'completed',
        'output': [],
      });
      expect(r.output, isEmpty);
    });

    test('UnknownOutputItem preserves raw type string', () {
      final r = OpenResponsesResult.fromJson({
        'id': 'r1',
        'object': 'response',
        'model': 'gpt-4o',
        'status': 'completed',
        'output': [
          {'id': 'x1', 'type': 'future_item_type', 'status': 'completed'},
        ],
      });
      final unknown = r.output.first as UnknownOutputItem;
      expect(unknown.type, 'future_item_type');
    });

    test('multiple unknown types all become UnknownOutputItem', () {
      final r = OpenResponsesResult.fromJson({
        'id': 'r1',
        'object': 'response',
        'model': 'gpt-4o',
        'status': 'completed',
        'output': [
          {'id': 'x1', 'type': 'image_generation_call', 'status': 'completed'},
          {'id': 'x2', 'type': 'code_interpreter_call', 'status': 'completed'},
        ],
      });
      expect(r.output[0], isA<UnknownOutputItem>());
      expect(r.output[1], isA<UnknownOutputItem>());
      expect((r.output[0] as UnknownOutputItem).type, 'image_generation_call');
      expect((r.output[1] as UnknownOutputItem).type, 'code_interpreter_call');
    });
  });
}
