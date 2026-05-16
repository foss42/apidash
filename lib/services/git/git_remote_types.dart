// Shared types for Git-backed collection sync (provider-agnostic: any remote URL).

class GitSyncRemoteException implements Exception {
  GitSyncRemoteException(this.message, [this.exitCode]);

  final String message;
  final int? exitCode;

  @override
  String toString() => 'GitSyncRemoteException: $message';
}

class PullResult {
  const PullResult({
    required this.commitSha,
    required this.files,
  });

  final String commitSha;
  final Map<String, String> files;
}

class BranchInfo {
  const BranchInfo({
    required this.name,
    required this.sha,
    this.protected = false,
  });

  final String name;
  final String sha;
  final bool protected;
}

class CommitInfo {
  const CommitInfo({
    required this.sha,
    required this.message,
    this.authorName,
    this.authorEmail,
    this.date,
    required this.treeSha,
  });

  final String sha;
  final String message;
  final String? authorName;
  final String? authorEmail;
  final DateTime? date;
  final String treeSha;
}
