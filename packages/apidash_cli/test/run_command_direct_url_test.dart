import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:apidash_cli/commands/run_command.dart';
import 'package:apidash_cli/storage/cli_storage.dart';
import 'package:hive_ce/hive.dart';
import 'package:test/test.dart';

void main() {
  late Directory hiveDir;
  late CommandRunner<void> runner;

  setUp(() async {
    hiveDir = await Directory.systemTemp.createTemp('apidash_cli_test_');
    Hive.init(hiveDir.path);

    CliStorage.dataBox = await Hive.openBox('apidash-data');
    CliStorage.historyMetaBox = await Hive.openBox('apidash-history-meta');
    CliStorage.historyLazyBox = await Hive.openLazyBox('apidash-history-lazy');

    runner = CommandRunner<void>('apidash', 'test')..addCommand(RunCommand());
  });

  tearDown(() async {
    await CliStorage.dataBox.close();
    await CliStorage.historyMetaBox.close();
    await CliStorage.historyLazyBox.close();
    await Hive.close();

    if (await hiveDir.exists()) {
      await hiveDir.delete(recursive: true);
    }
  });

  test('run --url executes request and saves it to history', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => server.close(force: true));

    server.listen((request) async {
      request.response
        ..statusCode = HttpStatus.ok
        ..headers.contentType = ContentType.json
        ..write('{"ok":true}');
      await request.response.close();
    });

    final url = 'http://${server.address.host}:${server.port}/ping';

    await runner.run(['run', '--url', url]);

    final history = await CliStorage.getHistory();
    expect(history, hasLength(1));

    final entry = history.single;
    expect(entry.url, url);
    expect(entry.method.name, 'get');
    expect(entry.httpResponseModel?.statusCode, HttpStatus.ok);
    expect(entry.name, 'CLI GET $url');
  });

  test('run positional URL supports method, headers, and body', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => server.close(force: true));

    String? observedMethod;
    String? observedHeader;
    String? observedBody;

    server.listen((request) async {
      observedMethod = request.method;
      observedHeader = request.headers.value('x-test');
      observedBody = await utf8.decoder.bind(request).join();

      request.response
        ..statusCode = HttpStatus.created
        ..write('created');
      await request.response.close();
    });

    final url = 'http://${server.address.host}:${server.port}/users';
    final payload = '{"name":"Ada"}';

    await runner.run([
      'run',
      url,
      '--method',
      'POST',
      '--header',
      'X-Test: cli',
      '--data',
      payload,
      '--name',
      'Create User',
    ]);

    expect(observedMethod, 'POST');
    expect(observedHeader, 'cli');
    expect(observedBody, payload);

    final history = await CliStorage.getHistory();
    expect(history, hasLength(1));

    final entry = history.single;
    expect(entry.name, 'Create User');
    expect(entry.method.name, 'post');
    expect(entry.url, url);
    expect(entry.httpResponseModel?.statusCode, HttpStatus.created);
  });

  test('run rejects direct URL flags without URL', () async {
    await expectLater(
      () => runner.run(['run', '--method', 'POST', '--name', 'Sample']),
      throwsA(isA<UsageException>()),
    );
  });

  test('run rejects body payload for GET requests', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => server.close(force: true));

    final url = 'http://${server.address.host}:${server.port}/items';

    await expectLater(
      () => runner.run([
        'run',
        '--url',
        url,
        '--method',
        'GET',
        '--data',
        '{"x":1}',
      ]),
      throwsA(isA<UsageException>()),
    );
  });
}
