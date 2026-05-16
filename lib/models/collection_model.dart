class CollectionModel {
  const CollectionModel({
    required this.id,
    required this.name,
    this.description = '',
    this.requestIds = const <String>[],
    this.activeEnvironmentId,
    this.gitConnection,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String description;
  final List<String> requestIds;
  final String? activeEnvironmentId;
  final GitConnectionModel? gitConnection;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'description': description,
        'requestIds': requestIds,
        if (activeEnvironmentId != null) 'activeEnvironmentId': activeEnvironmentId,
        if (gitConnection != null) 'gitConnection': gitConnection!.toJson(),
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
        if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      };

  factory CollectionModel.fromJson(Map<String, dynamic> json) => CollectionModel(
        id: json['id'] as String,
        name: json['name'] as String? ?? 'Untitled Collection',
        description: json['description'] as String? ?? '',
        requestIds: (json['requestIds'] as List<dynamic>? ?? const <dynamic>[])
            .whereType<String>()
            .toList(),
        activeEnvironmentId: json['activeEnvironmentId'] as String?,
        gitConnection: () {
          final raw = json['gitConnection'];
          if (raw is Map<String, dynamic>) {
            return GitConnectionModel.fromJson(raw);
          }
          if (raw is Map) {
            return GitConnectionModel.fromJson(
              raw.map(
                (key, value) => MapEntry(key.toString(), value),
              ),
            );
          }
          return null;
        }(),
        createdAt: _parseDateTime(json['createdAt']),
        updatedAt: _parseDateTime(json['updatedAt']),
      );

  CollectionModel copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? requestIds,
    String? activeEnvironmentId,
    bool clearActiveEnvironmentId = false,
    GitConnectionModel? gitConnection,
    bool clearGitConnection = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CollectionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      requestIds: requestIds ?? this.requestIds,
      activeEnvironmentId: clearActiveEnvironmentId
          ? null
          : (activeEnvironmentId ?? this.activeEnvironmentId),
      gitConnection:
          clearGitConnection ? null : (gitConnection ?? this.gitConnection),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value is! String || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }
}

/// Local Git working copy (any host: add `git remote` yourself). Not GitHub-API-specific.
class GitConnectionModel {
  const GitConnectionModel({
    required this.localRepoPath,
    this.repoDisplayName,
    this.branch = 'main',
    this.lastSyncedCommitSha,
    this.lastPushedAt,
    this.lastPulledAt,
  });

  /// Absolute path to the repository root (folder that contains `.git`).
  final String localRepoPath;

  /// Short label for UI (e.g. folder name). Optional.
  final String? repoDisplayName;

  final String branch;
  final String? lastSyncedCommitSha;
  final DateTime? lastPushedAt;
  final DateTime? lastPulledAt;

  GitConnectionModel copyWith({
    String? localRepoPath,
    String? repoDisplayName,
    String? branch,
    String? lastSyncedCommitSha,
    DateTime? lastPushedAt,
    DateTime? lastPulledAt,
  }) {
    return GitConnectionModel(
      localRepoPath: localRepoPath ?? this.localRepoPath,
      repoDisplayName: repoDisplayName ?? this.repoDisplayName,
      branch: branch ?? this.branch,
      lastSyncedCommitSha:
          lastSyncedCommitSha ?? this.lastSyncedCommitSha,
      lastPushedAt: lastPushedAt ?? this.lastPushedAt,
      lastPulledAt: lastPulledAt ?? this.lastPulledAt,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'localRepoPath': localRepoPath,
        if (repoDisplayName != null) 'repoDisplayName': repoDisplayName,
        'branch': branch,
        if (lastSyncedCommitSha != null) 'lastSyncedCommitSha': lastSyncedCommitSha,
        if (lastPushedAt != null) 'lastPushedAt': lastPushedAt!.toIso8601String(),
        if (lastPulledAt != null) 'lastPulledAt': lastPulledAt!.toIso8601String(),
      };

  factory GitConnectionModel.fromJson(Map<String, dynamic> json) {
    final localPath = json['localRepoPath'] as String?;
    if (localPath != null && localPath.isNotEmpty) {
      return GitConnectionModel(
        localRepoPath: localPath,
        repoDisplayName: json['repoDisplayName'] as String?,
        branch: json['branch'] as String? ?? 'main',
        lastSyncedCommitSha: json['lastSyncedCommitSha'] as String?,
        lastPushedAt: CollectionModel._parseDateTime(json['lastPushedAt']),
        lastPulledAt: CollectionModel._parseDateTime(json['lastPulledAt']),
      );
    }

    final owner = json['owner'] as String? ?? '';
    final repo = json['repo'] as String? ?? '';
    final legacyLabel =
        owner.isNotEmpty && repo.isNotEmpty ? '$owner/$repo' : null;
    return GitConnectionModel(
      localRepoPath: '',
      repoDisplayName: legacyLabel,
      branch: json['branch'] as String? ?? 'main',
      lastSyncedCommitSha: json['lastSyncedCommitSha'] as String?,
      lastPushedAt: CollectionModel._parseDateTime(json['lastPushedAt']),
      lastPulledAt: CollectionModel._parseDateTime(json['lastPulledAt']),
    );
  }
}
