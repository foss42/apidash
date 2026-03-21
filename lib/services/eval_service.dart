import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../screens/eval/eval_consts.dart';

class EvalService {
  static Future<void> runBenchmark({
    required BenchmarkType benchmarkType,
    required String modelName,
    int concurrency = 5,
    int total = 20,
    String? workflow,
    required Function(String) onLog,
    required Function(String) onResult,
    required Function(String) onError,
  }) async {
    try {
      String pythonCmd = kIsWeb ? "" : (Platform.isWindows ? 'python' : 'python3');
      
      if (pythonCmd.isEmpty) {
        onError("Python execution is only supported on desktop platform.");
        return;
      }

      List<String> args = [
        'eval_backend/runner.py',
        '--benchmark', benchmarkType.cmd,
        '--target', modelName,
      ];

      if (benchmarkType == BenchmarkType.stressTest) {
        args.addAll(['--concurrency', concurrency.toString(), '--total', total.toString()]);
      }

      if (benchmarkType == BenchmarkType.agenticWorkflow && workflow != null) {
        args.addAll(['--workflow', workflow]);
      }

      Process process = await Process.start(pythonCmd, args);

      // Handle standard output (logs and results)
      process.stdout.transform(utf8.decoder).listen((data) {
        List<String> lines = data.split('\n');
        for (String line in lines) {
          if (line.trim().isEmpty) continue;
          
          if (line.startsWith('RESULT:')) {
            onResult(line.substring(7));
          } else {
            onLog(line);
          }
        }
      });

      // Handle standard error
      process.stderr.transform(utf8.decoder).listen((data) {
        onError(data);
      });

      // Wait for process to exit
      int exitCode = await process.exitCode;
      if (exitCode != 0) {
        onError("Benchmark process exited with code $exitCode");
      }
    } catch (e) {
      onError("Failed to start benchmark: $e");
    }
  }
}
