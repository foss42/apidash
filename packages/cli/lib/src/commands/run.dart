import 'dart:convert';
import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:http/http.dart' as http;
import 'package:hive_ce/hive.dart';
import '../storage/storage.dart';

class RunCommand extends Command {
  final Logger logger;
  RunCommand(this.logger);

  @override final name = "run";
  @override final description = "Execute a saved request by ID.";

  @override
  void run() async {
    final dataDir = globalResults?['data-dir'] as String;
    if (argResults!.rest.isEmpty) throw UsageException('Missing request ID.', usage);
    final requestId = argResults!.rest.first;
    
    final storage = StorageHelper(dataDir, logger);
    try {
      await storage.init();
      final request = await storage.getRequest(requestId);
      if (request == null) {
        logger.err("Request not found: $requestId");
        return;
      }
      await executeRequest(request);
    } catch (e) {
      logger.err(e.toString());
    } finally {
      await Hive.close();
      await storage.cleanup();
    }
  }

  Future<void> executeRequest(Map<String, dynamic> request) async {
    final httpRequest = request['httpRequestModel'] ?? request;
    final method = (httpRequest['method'] ?? 'GET').toString().toUpperCase();
    String url = (httpRequest['url'] as String?) ?? '';

    if (url.isEmpty) {
      logger.err("Cannot run request: URL is missing.");
      return;
    }

    final Map<String, String> headers = {};
    final headersList = httpRequest['headers'] as List?;
    if (headersList != null) {
      for (var h in headersList) {
        if (h is Map && h['name'] != null && h['value'] != null) {
          headers[h['name'].toString()] = h['value'].toString();
        }
      }
    }

    final paramsList = httpRequest['params'] as List?;
    if (paramsList != null && paramsList.isNotEmpty) {
      final queryParams = <String>[];
      for (var p in paramsList) {
        if (p is Map && p['name'] != null && p['value'] != null) {
          queryParams.add('${Uri.encodeComponent(p['name'].toString())}=${Uri.encodeComponent(p['value'].toString())}');
        }
      }
      if (queryParams.isNotEmpty) {
        url += (url.contains('?') ? '&' : '?') + queryParams.join('&');
      }
    }

    final progress = logger.progress('Executing $method $url');
    final stopwatch = Stopwatch()..start();

    try {
      final client = http.Client();
      final uri = Uri.parse(url);
      late http.Response response;
      
      switch (method) {
        case 'GET': response = await client.get(uri, headers: headers); break;
        case 'POST': response = await client.post(uri, headers: headers, body: httpRequest['body']); break;
        case 'PUT': response = await client.put(uri, headers: headers, body: httpRequest['body']); break;
        case 'DELETE': response = await client.delete(uri, headers: headers); break;
        case 'PATCH': response = await client.patch(uri, headers: headers, body: httpRequest['body']); break;
        case 'HEAD': response = await client.head(uri, headers: headers); break;
        default: progress.fail("Unsupported method : $method"); return;
      }

      stopwatch.stop();
      progress.complete('Completed in ${stopwatch.elapsedMilliseconds}ms');
      _displayResponse(response);
    } catch (e) {
      progress.fail('Failed to connect: $e');
    }
  }

  void _displayResponse(http.Response response) {
    final statusColor = response.statusCode >= 200 && response.statusCode < 300 
      ? lightGreen 
      : (response.statusCode >= 400 ? lightRed : lightYellow);
    
    logger.info('\n${statusColor.wrap('Status: ${response.statusCode} ${response.reasonPhrase}')}');
    logger.info('Size:   ${response.bodyBytes.length} bytes');
    
    if (response.body.isNotEmpty) {
      logger.info('\n--- Response Body ---');
      try {
        final json = jsonDecode(response.body);
        final prettyJson = JsonEncoder.withIndent('  ').convert(json);
        logger.info(prettyJson);
      } catch (_) {
        logger.info(response.body);
      }
      logger.info('----------------------\n');
    }
  }
}
