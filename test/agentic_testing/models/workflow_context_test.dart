import 'package:apidash/agentic_testing/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WorkflowContext', () {
    test('constructs with default empty state', () {
      const context = WorkflowContext();
      expect(context.state, isEmpty);
    });

    test('setValue returns new context with key inserted', () {
      const context = WorkflowContext();
      final updated = context.setValue('token', 'abc123');

      expect(updated.state['token'], 'abc123');
      expect(context.state.containsKey('token'), isFalse);
    });

    test('merge combines values', () {
      const context = WorkflowContext(
        state: {'token': 'abc'},
      );

      final updated = context.merge({
        'userId': 42,
        'token': 'xyz',
      });

      expect(updated.state['userId'], 42);
      expect(updated.state['token'], 'xyz');
    });

    test('getTyped returns typed value or null', () {
      const context = WorkflowContext(
        state: {'count': 3, 'name': 'demo'},
      );

      expect(context.getTyped<int>('count'), 3);
      expect(context.getTyped<String>('name'), 'demo');
      expect(context.getTyped<double>('count'), isNull);
      expect(context.getTyped<String>('missing'), isNull);
    });

    test('toJson and fromJson roundtrip', () {
      const context = WorkflowContext(
        state: {
          'token': 'abc',
          'step': 2,
        },
      );

      final json = context.toJson();
      final decoded = WorkflowContext.fromJson(json);

      expect(decoded, context);
    });
  });
}