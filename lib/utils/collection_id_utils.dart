// Folder names under apidash-data/collections/ — derived from the display name.

/// Lowercase hyphenated id (ASCII letters and digits). Empty input becomes `collection`.
String collectionFolderIdFromDisplayName(String displayName) {
  final t = displayName.trim().toLowerCase();
  final sb = StringBuffer();
  var lastWasSep = false;
  for (final c in t.split('')) {
    if (RegExp(r'[a-z0-9]').hasMatch(c)) {
      sb.write(c);
      lastWasSep = false;
    } else if (c == ' ' || c == '-' || c == '_' || c == '.') {
      if (sb.isNotEmpty && !lastWasSep) {
        sb.write('-');
        lastWasSep = true;
      }
    }
  }
  var s = sb.toString().replaceAll(RegExp(r'-+'), '-');
  s = s.replaceAll(RegExp(r'^-+|-+$'), '');
  if (s.isEmpty) return 'collection';
  if (s.length > 120) {
    s = s.substring(0, 120).replaceAll(RegExp(r'-+$'), '');
    if (s.isEmpty) return 'collection';
  }
  return s;
}

final RegExp _uuidLike = RegExp(
  r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
);

bool collectionIdLooksLikeUuid(String id) => _uuidLike.hasMatch(id);

/// Resolves a unique folder id: slug from [displayName], then `-2`, `-3`, … if needed.
String uniqueCollectionFolderId(String displayName, Set<String> takenIds) {
  final base = collectionFolderIdFromDisplayName(displayName);
  if (!takenIds.contains(base)) return base;
  var n = 2;
  while (takenIds.contains('$base-$n')) {
    n++;
  }
  return '$base-$n';
}

bool collectionDisplayNamesEqual(String a, String b) =>
    a.trim().toLowerCase() == b.trim().toLowerCase();
