class SavedWorkspaceEntry {
  const SavedWorkspaceEntry({
    required this.path,
    required this.name,
  });

  final String path;
  final String name;

  factory SavedWorkspaceEntry.fromJson(Map<String, Object?> json) {
    return SavedWorkspaceEntry(
      path: json['path'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, Object?> toJson() => {
        'path': path,
        'name': name,
      };
}
