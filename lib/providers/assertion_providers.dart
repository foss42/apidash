// DashAssert – Assertion Providers
// Part of the AI-Powered Response Assertion Engine for API Dash
// Relates to GSoC 2026 Idea #4: Agentic API Testing

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/assertion_model.dart';
import '../services/assertion_engine.dart';
import '../services/ai_assertion_suggester.dart';

// ---------------------------------------------------------------------------
// Service providers (singletons)
// ---------------------------------------------------------------------------

/// Provides the [AssertionEngine] singleton.
final assertionEngineProvider = Provider<AssertionEngine>(
  (ref) => const AssertionEngine(),
);

/// Provides the [AiAssertionSuggester] singleton.
final aiSuggesterProvider = Provider<AiAssertionSuggester>(
  (ref) => const AiAssertionSuggester(),
);

// ---------------------------------------------------------------------------
// UI state providers
// ---------------------------------------------------------------------------

/// Tracks whether the AI suggestion is currently loading.
final aiSuggestionLoadingProvider = StateProvider<bool>((ref) => false);

// ---------------------------------------------------------------------------
// Assertion suites state (keyed by requestId)
// ---------------------------------------------------------------------------

/// Provides all [AssertionSuite]s across all requests, keyed by requestId.
final assertionSuitesProvider =
    StateNotifierProvider<AssertionSuitesNotifier, Map<String, AssertionSuite>>(
      (ref) => AssertionSuitesNotifier(),
    );

/// Notifier that manages assertion suites for all requests.
class AssertionSuitesNotifier
    extends StateNotifier<Map<String, AssertionSuite>> {
  AssertionSuitesNotifier() : super({});

  // ---------------------------------------------------------------------------
  // Suite lifecycle
  // ---------------------------------------------------------------------------

  /// Create an empty suite for [requestId] if one does not already exist.
  void createSuiteForRequest(String requestId) {
    if (state.containsKey(requestId)) return;
    final suite = AssertionSuite(id: 'suite_$requestId', requestId: requestId);
    state = {...state, requestId: suite};
  }

  /// Get the suite for [requestId], creating it if necessary.
  AssertionSuite getSuiteForRequest(String requestId) {
    if (!state.containsKey(requestId)) {
      createSuiteForRequest(requestId);
    }
    return state[requestId]!;
  }

  /// Clear all rules from the suite for [requestId].
  void clearSuite(String requestId) {
    if (!state.containsKey(requestId)) return;
    state = {
      ...state,
      requestId: state[requestId]!.copyWith(rules: [], lastRunAt: null),
    };
  }

  /// Remove the suite entirely for [requestId].
  void removeSuite(String requestId) {
    if (!state.containsKey(requestId)) return;
    final newState = Map<String, AssertionSuite>.from(state);
    newState.remove(requestId);
    state = newState;
  }

  // ---------------------------------------------------------------------------
  // Rule management
  // ---------------------------------------------------------------------------

  /// Add [rule] to the suite for [requestId].
  void addRule(String requestId, AssertionRule rule) {
    final suite = getSuiteForRequest(requestId);
    final updatedRules = [...suite.rules, rule];
    state = {...state, requestId: suite.copyWith(rules: updatedRules)};
  }

  /// Add multiple [rules] at once (e.g. from AI suggestions).
  void addRules(String requestId, List<AssertionRule> rules) {
    final suite = getSuiteForRequest(requestId);
    final updatedRules = [...suite.rules, ...rules];
    state = {...state, requestId: suite.copyWith(rules: updatedRules)};
  }

  /// Remove the rule with [ruleId] from the suite for [requestId].
  void removeRule(String requestId, String ruleId) {
    if (!state.containsKey(requestId)) return;
    final suite = state[requestId]!;
    final updatedRules = suite.rules.where((r) => r.id != ruleId).toList();
    state = {...state, requestId: suite.copyWith(rules: updatedRules)};
  }

  /// Replace the suite for [requestId] with [updatedSuite].
  ///
  /// Typically called after [AssertionEngine.executeAll] completes.
  void updateSuiteResults(String requestId, AssertionSuite updatedSuite) {
    state = {...state, requestId: updatedSuite};
  }

  /// Update a single rule within the suite.
  void updateRule(String requestId, AssertionRule updatedRule) {
    if (!state.containsKey(requestId)) return;
    final suite = state[requestId]!;
    final updatedRules = suite.rules.map((r) {
      return r.id == updatedRule.id ? updatedRule : r;
    }).toList();
    state = {...state, requestId: suite.copyWith(rules: updatedRules)};
  }
}
