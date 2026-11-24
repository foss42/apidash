/// Pure Dart core for API Dash performance testing.
///
/// Contains the versioned results format ([PerfRunResults] and friends) and
/// the metrics calculator ([PerfMetricsCalculator]) shared by the future
/// headless CLI and the in-app performance dashboard. No Flutter or I/O
/// dependencies so it can run on any Dart VM (server, CI runner, desktop).
library perf_core;

export 'src/load_profile.dart';
export 'src/metrics_calculator.dart';
export 'src/perf_results.dart';
export 'src/perf_run_config.dart';
export 'src/perf_sample.dart';
