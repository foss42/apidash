import 'dart:convert';
import 'dart:io';

import 'package:better_networking/better_networking.dart';
import 'package:path/path.dart' as path;

import 'base_command.dart';

class RunCommand extends BaseCommand {
  RunCommand() {
    argParser
      ..addOption(
        'folder',
        abbr: 'f',
        help: 'Folder ID to look for the request',
      )
      ..addOption('request', abbr: 'r', help: 'Request ID to execute');
  }

  @override
  String get name => 'run';

  @override
  String get description => 'Run a saved request by its ID';

  @override
  Future<void> execute() async {
    final workspacePath = _getWorkspacePath();

    if (workspacePath == null) {
      log.err('APIDASH_WORKSPACE_PATH environment variable is not set.');
      return;
    }

    final collectionID = argResults?.rest.isNotEmpty == true
        ? argResults!.rest.first
        : null;
    final folderID = argResults?['folder'] as String?;
    final requestID = argResults?['request'] as String?;

    if (collectionID == null || collectionID.trim().isEmpty) {
      log.err('Collection ID is required.');
      return;
    }

    if (requestID == null || requestID.trim().isEmpty) {
      log.err('Request ID is required.');
      return;
    }

    try {
      final result = await executeRequest(
        workspacePath,
        collectionID,
        folderID,
        requestID,
      );
      const encoder = JsonEncoder.withIndent('  ');
      log.write(encoder.convert(result));
    } catch (e) {
      log.err(e.toString());
    }
  }

  Future<HttpRequestModel?> _loadRequest(
    String workspacePath,
    String collectionID,
    String? folderID,
    String requestID,
  ) async {
    final requestPath = folderID != null && folderID.trim().isNotEmpty
        ? path.join(
            workspacePath,
            'collections',
            collectionID,
            folderID,
            '$requestID.json',
          )
        : path.join(
            workspacePath,
            'collections',
            collectionID,
            '$requestID.json',
          );

    final requestFile = File(requestPath);
    if (!await requestFile.exists()) {
      return null;
    }

    final raw = await requestFile.readAsString();
    final decodedJson = jsonDecode(raw);
    if (decodedJson is Map<String, dynamic>) {
      return HttpRequestModel.fromJson(decodedJson);
    }

    return null;
  }

  Future<Map<String, dynamic>> executeRequest(
    String workspacePath,
    String collectionID,
    String? folderID,
    String requestID,
  ) async {
    final request = await _loadRequest(
      workspacePath,
      collectionID,
      folderID,
      requestID,
    );

    if (request == null) {
      throw Exception(
        'Request not found: $requestID in collection $collectionID'
        '${folderID != null ? ' and folder $folderID' : ''}.',
      );
    }

    final (response, duration, error) = await sendHttpRequest(
      requestID,
      APIType.rest,
      request,
    );

    if (error != null || response == null) {
      throw Exception(error ?? 'Request failed');
    }

    return const HttpResponseModel()
        .fromResponse(response: response, time: duration)
        .toJson();
  }

  String? _getWorkspacePath() {
    return Platform.environment['APIDASH_WORKSPACE_PATH'];
  }
}
