import 'dart:convert';
import 'package:git/git.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:apidash/consts.dart';

class GitService {
  final String repositoryUrl;
  final String token;
  final String branch;

  GitService({
    required this.repositoryUrl,
    required this.token,
    this.branch = 'main',
  });

  Future<void> pushData() async {
    final directory = await getApplicationDocumentsDirectory();
    final repoDir = '${directory.path}/apidash_repo';

    final gitDir = await GitDir.fromExisting(repoDir, allowSubdirectory: true);
    await gitDir.runCommand(['pull', 'origin', branch]);

    final box = await Hive.openBox(kDataBox);
    final data = box.toMap();
    final jsonData = jsonEncode(data);

    final file = File('$repoDir/collections.json');
    await file.writeAsString(jsonData);

    await gitDir.runCommand(['add', 'collections.json']);
    await gitDir.runCommand(['commit', '-m', 'Update collections']);
    await gitDir.runCommand(['push', 'origin', branch]);
  }

  Future<void> pullData() async {
    final directory = await getApplicationDocumentsDirectory();
    final repoDir = '${directory.path}/apidash_repo';

    final gitDir = await GitDir.fromExisting(repoDir, allowSubdirectory: true);
    await gitDir.runCommand(['pull', 'origin', branch]);

    final file = File('$repoDir/collections.json');
    if (await file.exists()) {
      final jsonData = await file.readAsString();
      final data = jsonDecode(jsonData);

      final box = await Hive.openBox(kDataBox);
      await box.putAll(data);
    }
  }
}
