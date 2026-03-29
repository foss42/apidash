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
  });
}
