import 'dart:async';
import 'dart:convert';
import 'dart:io';

abstract class Transport {
  Stream<String> get stream;
  void send(String message);
  Future<void> close();
}

class StdIOTransport implements Transport {
  final StreamController<String> _controller = StreamController<String>();
  late final StreamSubscription _subscription;

  StdIOTransport() {
    _subscription = stdin
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen((line) {
      if (line.trim().isNotEmpty) {
        _controller.add(line);
      }
    });
  }

  @override
  Stream<String> get stream => _controller.stream;

  @override
  void send(String message) {
    stdout.writeln(message);
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    await _controller.close();
  }
}

class ProcessTransport implements Transport {
  final Process _process;
  final StreamController<String> _controller = StreamController<String>();
  late final StreamSubscription _stdoutSubscription;
  late final StreamSubscription _stderrSubscription;

  ProcessTransport(this._process) {
    _stdoutSubscription = _process.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen((line) {
      final jsonStart = line.indexOf('{');
      if (jsonStart != -1) {
        _controller.add(line.substring(jsonStart));
      }
    });

    _stderrSubscription = _process.stderr
        .transform(utf8.decoder)
        .listen((data) {
      stderr.write('MCP SERVER ERR: $data');
    });
  }

  @override
  Stream<String> get stream => _controller.stream;

  @override
  void send(String message) {
    _process.stdin.writeln(message);
  }

  @override
  Future<void> close() async {
    await _stdoutSubscription.cancel();
    await _stderrSubscription.cancel();
    await _controller.close();
    _process.kill();
  }
}
