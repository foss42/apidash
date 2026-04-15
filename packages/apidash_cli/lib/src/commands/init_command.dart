import 'package:apidash_storage/apidash_storage.dart';

import 'base_command.dart';

class InitCommand extends BaseCommand {
  @override
  String get name => 'init';

  @override
  String get description => 'Create API Dash HIS workspace';

  @override
  Future<void> execute() async {
    final results = argResults;
    if (results == null || results.rest.isEmpty) {
      log.err('Missing path. Usage: apidash init <path>');
      return;
    }

    final workspacePath = results.rest.first;
    try {
      final his = HisService(workspacePath: workspacePath);
      await his.createWorkspace();

      log.success('Workspace created at $workspacePath');
      log.info(
        'Run this in your shell to set workspace path: '
        '${WorkspaceService.shellExportCommand(workspacePath)}',
      );
    } catch (e) {
      log.err('Failed to create workspace: $e');
    }
  }
}
