import 'package:apidash/agentic_testing/rules/rule_engine.dart';
import 'package:apidash/agentic_testing/rules/rule_input.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RuleEngine', () {
    const engine = RuleEngine();

    test('GET health-check creates only valid_request', () {
      const input = RuleInput(
        method: 'GET',
        url: 'https://api.example.com/health-check',
        headers: {},
        body: null,
        endpointLikelyProtected: false,
      );

      final cases = engine.generate(input);

      expect(cases.length, 1);
      expect(cases.first.name, 'Valid Request');
    });

    test('Protected POST JSON creates auth/body/json rules', () {
      const input = RuleInput(
        method: 'POST',
        url: 'https://api.example.com/users/register',
        headers: {
          'Authorization': 'Bearer token',
          'Content-Type': 'application/json',
        },
        body: '{"email":"a@b.com","password":"secret"}',
        endpointLikelyProtected: true,
      );

      final cases = engine.generate(input);
      final names = cases.map((e) => e.name).toList();

      expect(names, contains('Valid Request'));
      expect(names, contains('Missing Auth'));
      expect(names, contains('Empty Body'));
      expect(names, contains('Malformed JSON'));
      expect(cases.length, 4);
    });

    test('Generation is deterministic for same input', () {
      const input = RuleInput(
        method: 'POST',
        url: 'https://api.example.com/users/register',
        headers: {
          'Authorization': 'Bearer token',
          'Content-Type': 'application/json',
        },
        body: '{"x":1}',
        endpointLikelyProtected: true,
      );

      final first = engine.generate(input);
      final second = engine.generate(input);

      expect(second.length, first.length);
      for (var i = 0; i < first.length; i++) {
        expect(second[i].id, first[i].id);
        expect(second[i].name, first[i].name);
      }
    });
  });
}