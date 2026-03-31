// Copyright 2024 The APIDash Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:genai/interface/model_providers/anthropic.dart';

/// Unit tests for [AnthropicModel.streamOutputFormatter].
///
/// Covers:
///   - Correct text extraction from `content_block_delta` / `text_delta`
///   - Null return for every irrelevant Anthropic SSE event type
///   - SSE `event:` fast-path (eventType parameter) short-circuit
///   - All malformed / degenerate payload shapes
///   - Multi-chunk sequential streaming simulation
///   - Full encode → decode → format round-trip (mirrors streamGenAIRequest)
void main() {
  // Use the singleton so we mirror production usage exactly.
  final formatter = AnthropicModel.instance;

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Builds a raw SSE `data:` line from a payload map.
  String buildSseLine(Map<String, dynamic> payload) =>
      'data: ${jsonEncode(payload)}';

  /// Decodes the JSON from a raw SSE `data:` line — mirrors what
  /// streamGenAIRequest does before calling streamOutputFormatter.
  Map<String, dynamic> decodeSseLine(String line) =>
      jsonDecode(line.substring(6).trim()) as Map<String, dynamic>;

  // ---------------------------------------------------------------------------
  // 1. Valid content_block_delta events
  // ---------------------------------------------------------------------------
  group('valid content_block_delta events', () {
    test('returns text from a well-formed text_delta payload', () {
      final payload = {
        'type': 'content_block_delta',
        'index': 0,
        'delta': {'type': 'text_delta', 'text': 'Hello, world!'},
      };
      expect(formatter.streamOutputFormatter(payload), 'Hello, world!');
    });

    test('returns text when eventType matches content_block_delta', () {
      final payload = {
        'type': 'content_block_delta',
        'index': 0,
        'delta': {'type': 'text_delta', 'text': 'Streamed token'},
      };
      expect(
        formatter.streamOutputFormatter(
          payload,
          eventType: 'content_block_delta',
        ),
        'Streamed token',
      );
    });

    test('handles whitespace-only text chunk (space between words)', () {
      final payload = {
        'type': 'content_block_delta',
        'index': 0,
        'delta': {'type': 'text_delta', 'text': ' '},
      };
      // A single space is a valid text token — do not suppress it.
      expect(formatter.streamOutputFormatter(payload), ' ');
    });

    test('handles multi-word text chunk', () {
      final payload = {
        'type': 'content_block_delta',
        'index': 0,
        'delta': {'type': 'text_delta', 'text': 'The quick brown fox'},
      };
      expect(formatter.streamOutputFormatter(payload), 'The quick brown fox');
    });

    test('handles unicode / emoji text chunk', () {
      final payload = {
        'type': 'content_block_delta',
        'index': 0,
        'delta': {'type': 'text_delta', 'text': '🚀 Flutter'},
      };
      expect(formatter.streamOutputFormatter(payload), '🚀 Flutter');
    });

    test('returns text regardless of index value', () {
      for (final index in [0, 1, 99]) {
        final payload = {
          'type': 'content_block_delta',
          'index': index,
          'delta': {'type': 'text_delta', 'text': 'chunk'},
        };
        expect(
          formatter.streamOutputFormatter(payload),
          'chunk',
          reason: 'should work for index=$index',
        );
      }
    });
  });

  // ---------------------------------------------------------------------------
  // 2. Ignored SSE events — eventType fast-path
  // ---------------------------------------------------------------------------
  group('ignored events via SSE event: fast-path', () {
    // These are all the non-content event types that Anthropic emits.
    const ignoredEventTypes = [
      'ping',
      'message_start',
      'message_delta',
      'message_stop',
      'content_block_start',
      'content_block_stop',
    ];

    for (final eventType in ignoredEventTypes) {
      test('returns null for SSE event: "$eventType" (fast-path)', () {
        // The data payload is irrelevant here; the fast-path must short-circuit
        // before any payload inspection.
        final payload = {'type': eventType};
        expect(
          formatter.streamOutputFormatter(payload, eventType: eventType),
          isNull,
          reason:
              'eventType="$eventType" should be rejected before payload check',
        );
      });
    }

    test('fast-path rejects ping even when payload claims content_block_delta '
        '(defensive: mismatched event:/data: pair)', () {
      // In a well-formed SSE stream this should never happen, but we guard
      // against it regardless.
      final payload = {
        'type': 'content_block_delta',
        'index': 0,
        'delta': {'type': 'text_delta', 'text': 'Should not emit'},
      };
      expect(
        formatter.streamOutputFormatter(payload, eventType: 'ping'),
        isNull,
      );
    });
  });

  // ---------------------------------------------------------------------------
  // 3. Ignored SSE events — payload type field (no eventType supplied)
  // ---------------------------------------------------------------------------
  group('ignored events via payload type field (eventType omitted)', () {
    test('returns null for message_start payload', () {
      final payload = {
        'type': 'message_start',
        'message': {
          'id': 'msg_01XFDUDYJgAACzvnptvVoYEL',
          'type': 'message',
          'role': 'assistant',
          'content': [],
        },
      };
      expect(formatter.streamOutputFormatter(payload), isNull);
    });

    test('returns null for ping payload', () {
      expect(formatter.streamOutputFormatter({'type': 'ping'}), isNull);
    });

    test('returns null for content_block_start payload', () {
      final payload = {
        'type': 'content_block_start',
        'index': 0,
        'content_block': {'type': 'text', 'text': ''},
      };
      expect(formatter.streamOutputFormatter(payload), isNull);
    });

    test('returns null for content_block_stop payload', () {
      final payload = {'type': 'content_block_stop', 'index': 0};
      expect(formatter.streamOutputFormatter(payload), isNull);
    });

    test('returns null for message_delta payload', () {
      final payload = {
        'type': 'message_delta',
        'delta': {'stop_reason': 'end_turn', 'stop_sequence': null},
        'usage': {'output_tokens': 12},
      };
      expect(formatter.streamOutputFormatter(payload), isNull);
    });

    test('returns null for message_stop payload', () {
      final payload = {'type': 'message_stop'};
      expect(formatter.streamOutputFormatter(payload), isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // 4. Malformed and degenerate payloads
  // ---------------------------------------------------------------------------
  group('malformed / edge-case payloads', () {
    test('returns null for completely empty map', () {
      expect(formatter.streamOutputFormatter({}), isNull);
    });

    test('returns null when type field is absent', () {
      final payload = {
        'index': 0,
        'delta': {'type': 'text_delta', 'text': 'orphan'},
      };
      expect(formatter.streamOutputFormatter(payload), isNull);
    });

    test('returns null when delta key is absent', () {
      final payload = {'type': 'content_block_delta', 'index': 0};
      expect(formatter.streamOutputFormatter(payload), isNull);
    });

    test('returns null when delta is null', () {
      final payload = {
        'type': 'content_block_delta',
        'index': 0,
        'delta': null,
      };
      expect(formatter.streamOutputFormatter(payload), isNull);
    });

    test('returns null when delta is a String instead of a Map', () {
      final payload = {
        'type': 'content_block_delta',
        'index': 0,
        'delta': 'unexpected_string',
      };
      expect(formatter.streamOutputFormatter(payload), isNull);
    });

    test('returns null when delta is a List instead of a Map', () {
      final payload = {
        'type': 'content_block_delta',
        'index': 0,
        'delta': ['not', 'a', 'map'],
      };
      expect(formatter.streamOutputFormatter(payload), isNull);
    });

    test('returns null for non-text delta type: input_json_delta', () {
      // Anthropic uses input_json_delta for tool use streaming.
      final payload = {
        'type': 'content_block_delta',
        'index': 1,
        'delta': {'type': 'input_json_delta', 'partial_json': '{"key":'},
      };
      expect(formatter.streamOutputFormatter(payload), isNull);
    });

    test(
      'returns null for non-text delta type: image_delta (hypothetical)',
      () {
        final payload = {
          'type': 'content_block_delta',
          'index': 0,
          'delta': {'type': 'image_delta', 'data': 'base64=='},
        };
        expect(formatter.streamOutputFormatter(payload), isNull);
      },
    );

    test('returns null when delta type field is absent', () {
      final payload = {
        'type': 'content_block_delta',
        'index': 0,
        'delta': {'text': 'no type field'},
      };
      expect(formatter.streamOutputFormatter(payload), isNull);
    });

    test('returns null when text field is an empty string', () {
      // An empty string carries no information; callers should not emit it.
      final payload = {
        'type': 'content_block_delta',
        'index': 0,
        'delta': {'type': 'text_delta', 'text': ''},
      };
      expect(formatter.streamOutputFormatter(payload), isNull);
    });

    test('returns null when text field is absent from delta', () {
      final payload = {
        'type': 'content_block_delta',
        'index': 0,
        'delta': {'type': 'text_delta'},
      };
      expect(formatter.streamOutputFormatter(payload), isNull);
    });

    test('returns null when text field is an integer', () {
      final payload = {
        'type': 'content_block_delta',
        'index': 0,
        'delta': {'type': 'text_delta', 'text': 42},
      };
      expect(formatter.streamOutputFormatter(payload), isNull);
    });

    test('returns null when text field is null', () {
      final payload = {
        'type': 'content_block_delta',
        'index': 0,
        'delta': {'type': 'text_delta', 'text': null},
      };
      expect(formatter.streamOutputFormatter(payload), isNull);
    });

    test('returns null when type field is an unknown string', () {
      final payload = {'type': 'future_unknown_event_type', 'data': 'whatever'};
      expect(formatter.streamOutputFormatter(payload), isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // 5. Multi-chunk sequential streaming simulation
  // ---------------------------------------------------------------------------
  group('multiple sequential streamed chunks', () {
    test('extracts text from every chunk in a realistic stream sequence', () {
      final chunks = [
        // Anthropic preamble — must be filtered.
        {'type': 'message_start', 'message': {}},
        {'type': 'content_block_start', 'index': 0, 'content_block': {}},
        {'type': 'ping'},
        // Actual text deltas.
        {
          'type': 'content_block_delta',
          'index': 0,
          'delta': {'type': 'text_delta', 'text': 'Hello'},
        },
        {
          'type': 'content_block_delta',
          'index': 0,
          'delta': {'type': 'text_delta', 'text': ', '},
        },
        {
          'type': 'content_block_delta',
          'index': 0,
          'delta': {'type': 'text_delta', 'text': 'world!'},
        },
        // Anthropic epilogue — must be filtered.
        {'type': 'content_block_stop', 'index': 0},
        {
          'type': 'message_delta',
          'delta': {'stop_reason': 'end_turn'},
        },
        {'type': 'message_stop'},
      ];

      final results = chunks
          .map(formatter.streamOutputFormatter)
          .where((r) => r != null)
          .toList();

      expect(results, ['Hello', ', ', 'world!']);
    });

    test('concatenated text from filtered stream equals expected output', () {
      final chunks = [
        {'type': 'ping'},
        {
          'type': 'content_block_delta',
          'index': 0,
          'delta': {'type': 'text_delta', 'text': 'Dart '},
        },
        {'type': 'content_block_stop', 'index': 0},
        {
          'type': 'content_block_delta',
          'index': 0,
          'delta': {'type': 'text_delta', 'text': 'is '},
        },
        {'type': 'message_stop'},
        {
          'type': 'content_block_delta',
          'index': 0,
          'delta': {'type': 'text_delta', 'text': 'great!'},
        },
      ];

      final combined = chunks
          .map(formatter.streamOutputFormatter)
          .where((r) => r != null)
          .join();

      expect(combined, 'Dart is great!');
    });

    test('works correctly with eventType parameter across a stream', () {
      final events = <(String, Map<String, dynamic>)>[
        ('message_start', {'type': 'message_start'}),
        (
          'content_block_start',
          {
            'type': 'content_block_start',
            'index': 0,
            'content_block': {'type': 'text', 'text': ''},
          },
        ),
        ('ping', {'type': 'ping'}),
        (
          'content_block_delta',
          {
            'type': 'content_block_delta',
            'index': 0,
            'delta': {'type': 'text_delta', 'text': 'Hi'},
          },
        ),
        (
          'content_block_delta',
          {
            'type': 'content_block_delta',
            'index': 0,
            'delta': {'type': 'text_delta', 'text': ' there'},
          },
        ),
        ('content_block_stop', {'type': 'content_block_stop', 'index': 0}),
        (
          'message_delta',
          {
            'type': 'message_delta',
            'delta': {'stop_reason': 'end_turn'},
          },
        ),
        ('message_stop', {'type': 'message_stop'}),
      ];

      final results = events
          .map((e) => formatter.streamOutputFormatter(e.$2, eventType: e.$1))
          .where((r) => r != null)
          .toList();

      expect(results, ['Hi', ' there']);
    });
  });

  // ---------------------------------------------------------------------------
  // 6. SSE eventType fast-path vs payload type field consistency
  // ---------------------------------------------------------------------------
  group('eventType fast-path vs payload type field', () {
    test(
      'null eventType falls through to payload type check — text returned',
      () {
        final payload = {
          'type': 'content_block_delta',
          'index': 0,
          'delta': {'type': 'text_delta', 'text': 'Fallback works'},
        };
        expect(
          formatter.streamOutputFormatter(payload, eventType: null),
          'Fallback works',
        );
      },
    );

    test(
      'null eventType falls through to payload type check — null returned',
      () {
        final payload = {'type': 'ping'};
        expect(
          formatter.streamOutputFormatter(payload, eventType: null),
          isNull,
        );
      },
    );

    test('eventType=content_block_delta + correct payload returns text', () {
      final payload = {
        'type': 'content_block_delta',
        'index': 0,
        'delta': {'type': 'text_delta', 'text': 'Both checks pass'},
      };
      expect(
        formatter.streamOutputFormatter(
          payload,
          eventType: 'content_block_delta',
        ),
        'Both checks pass',
      );
    });
  });

  // ---------------------------------------------------------------------------
  // 7. Round-trip: JSON encode → SSE line → decode → format
  //    Mirrors exactly what streamGenAIRequest does before calling the formatter.
  // ---------------------------------------------------------------------------
  group(
    'round-trip via jsonEncode → jsonDecode (mirrors streamGenAIRequest)',
    () {
      test('text_delta survives the full encode/decode/format pipeline', () {
        final original = {
          'type': 'content_block_delta',
          'index': 0,
          'delta': {'type': 'text_delta', 'text': 'Round-trip text'},
        };
        final decoded = decodeSseLine(buildSseLine(original));
        expect(formatter.streamOutputFormatter(decoded), 'Round-trip text');
      });

      test('ping survives the pipeline and returns null', () {
        final original = {'type': 'ping'};
        final decoded = decodeSseLine(buildSseLine(original));
        expect(
          formatter.streamOutputFormatter(decoded, eventType: 'ping'),
          isNull,
        );
      });

      test('message_start survives the pipeline and returns null', () {
        final original = {
          'type': 'message_start',
          'message': {
            'id': 'msg_abc123',
            'type': 'message',
            'role': 'assistant',
            'content': [],
            'model': 'claude-opus-4-5',
            'stop_reason': null,
            'stop_sequence': null,
            'usage': {'input_tokens': 25, 'output_tokens': 1},
          },
        };
        final decoded = decodeSseLine(buildSseLine(original));
        expect(
          formatter.streamOutputFormatter(decoded, eventType: 'message_start'),
          isNull,
        );
      });

      test('all realistic Anthropic SSE events in sequence', () {
        // Simulates a minimal realistic Anthropic stream for "Hi".
        final rawEvents = <(String eventType, Map<String, dynamic> data)>[
          (
            'message_start',
            {
              'type': 'message_start',
              'message': {
                'id': 'msg_1',
                'type': 'message',
                'role': 'assistant',
              },
            },
          ),
          (
            'content_block_start',
            {
              'type': 'content_block_start',
              'index': 0,
              'content_block': {'type': 'text', 'text': ''},
            },
          ),
          ('ping', {'type': 'ping'}),
          (
            'content_block_delta',
            {
              'type': 'content_block_delta',
              'index': 0,
              'delta': {'type': 'text_delta', 'text': 'H'},
            },
          ),
          (
            'content_block_delta',
            {
              'type': 'content_block_delta',
              'index': 0,
              'delta': {'type': 'text_delta', 'text': 'i'},
            },
          ),
          ('content_block_stop', {'type': 'content_block_stop', 'index': 0}),
          (
            'message_delta',
            {
              'type': 'message_delta',
              'delta': {'stop_reason': 'end_turn', 'stop_sequence': null},
            },
          ),
          ('message_stop', {'type': 'message_stop'}),
        ];

        final results = rawEvents
            .map((event) {
              final decoded = decodeSseLine(buildSseLine(event.$2));
              return formatter.streamOutputFormatter(
                decoded,
                eventType: event.$1,
              );
            })
            .where((r) => r != null)
            .toList();

        expect(results, ['H', 'i']);
        expect(results.join(), 'Hi');
      });
    },
  );
}
