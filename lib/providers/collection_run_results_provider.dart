import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/models/models.dart';

class RunResult {
  final String requestId;
  final String requestName;
  final String url;
  final String method;
  final int? statusCode;
  final int responseTimeMs;
  final int responseSize;
  final String? error;

  RunResult({
    required this.requestId,
    required this.requestName,
    required this.url,
    required this.method,
    this.statusCode,
    required this.responseTimeMs,
    required this.responseSize,
    this.error,
  });
}

class CollectionRunResults {
  final DateTime startTime;
  final String collectionName;
  final String environment;
  final int iterations;
  final int totalDurationMs;
  final List<RunResult> results;
  final bool isRunning;

  CollectionRunResults({
    required this.startTime,
    required this.collectionName,
    required this.environment,
    required this.iterations,
    required this.totalDurationMs,
    required this.results,
    required this.isRunning,
  });

  CollectionRunResults copyWith({
    DateTime? startTime,
    String? collectionName,
    String? environment,
    int? iterations,
    int? totalDurationMs,
    List<RunResult>? results,
    bool? isRunning,
  }) {
    return CollectionRunResults(
      startTime: startTime ?? this.startTime,
      collectionName: collectionName ?? this.collectionName,
      environment: environment ?? this.environment,
      iterations: iterations ?? this.iterations,
      totalDurationMs: totalDurationMs ?? this.totalDurationMs,
      results: results ?? this.results,
      isRunning: isRunning ?? this.isRunning,
    );
  }

  int get passedTests => results.where((r) => r.statusCode != null && r.statusCode! >= 200 && r.statusCode! < 300).length;
  int get failedTests => results.where((r) => r.statusCode == null || r.statusCode! < 200 || r.statusCode! >= 300).length;
  int get skippedTests => 0; // For future implementation
  double get avgResponseTime {
    if (results.isEmpty) return 0;
    return results.map((r) => r.responseTimeMs).reduce((a, b) => a + b) / results.length;
  }
}

final collectionRunResultsProvider = StateNotifierProvider<CollectionRunResultsNotifier, CollectionRunResults?>((ref) {
  return CollectionRunResultsNotifier();
});

class CollectionRunResultsNotifier extends StateNotifier<CollectionRunResults?> {
  CollectionRunResultsNotifier() : super(null);

  void startRun({
    required String collectionName,
    required String environment,
    required int iterations,
  }) {
    state = CollectionRunResults(
      startTime: DateTime.now(),
      collectionName: collectionName,
      environment: environment,
      iterations: iterations,
      totalDurationMs: 0,
      results: [],
      isRunning: true,
    );
  }

  void addResult(RunResult result) {
    if (state == null) return;
    
    state = state!.copyWith(
      results: [...state!.results, result],
      totalDurationMs: state!.totalDurationMs + result.responseTimeMs,
    );
  }

  void finishRun() {
    if (state == null) return;
    state = state!.copyWith(isRunning: false);
  }

  void reset() {
    state = null;
  }
} 