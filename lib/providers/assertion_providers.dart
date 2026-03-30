// DashAssert – Assertion Providers
// Part of the AI-Powered Response Assertion Engine for API Dash
// Relates to GSoC 2026 Idea #4: Agentic API Testing

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:uuid/uuid.dart';
import '../models/assertion_model.dart';
import '../models/assertion_preset.dart';
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

const _uuid = Uuid();

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

  /// Replace the suite for [requestId] with [updatedSuite] and append a
  /// new [AssertionRun] entry to the run history (capped at 20 entries).
  ///
  /// Typically called after [AssertionEngine.executeAll] completes.
  void updateSuiteResults(
    String requestId,
    AssertionSuite updatedSuite, {
    Duration? responseTime,
    int? statusCode,
  }) {
    final run = AssertionRun(
      id: _uuid.v4(),
      runAt: DateTime.now(),
      passCount: updatedSuite.rules
          .where((r) => r.status == AssertionStatus.pass)
          .length,
      failCount: updatedSuite.rules
          .where((r) => r.status == AssertionStatus.fail)
          .length,
      totalCount: updatedSuite.rules.length,
      statusCode: statusCode,
      responseTime: responseTime,
    );
    // Keep only the last 20 runs
    final history =
        [...updatedSuite.runHistory, run].reversed
            .take(20)
            .toList()
            .reversed
            .toList();
    state = {
      ...state,
      requestId: updatedSuite.copyWith(runHistory: history),
    };
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

  // ---------------------------------------------------------------------------
  // Preset Templates
  // ---------------------------------------------------------------------------

  /// Apply a preset template to the suite for [requestId].
  ///
  /// Deduplicates rules by description — preset rules already present in the
  /// suite (matched by description) are skipped.
  void applyPreset(String requestId, AssertionPreset preset) {
    final suite = getSuiteForRequest(requestId);
    final existingDescriptions =
        suite.rules.map((r) => r.description).toSet();
    final newRules = preset.rules
        .where((r) => !existingDescriptions.contains(r.description))
        .map((r) => r.copyWith(id: _uuid.v4())) // fresh IDs to avoid conflicts
        .toList();
    state = {
      ...state,
      requestId: suite.copyWith(rules: [...suite.rules, ...newRules]),
    };
  }
}
