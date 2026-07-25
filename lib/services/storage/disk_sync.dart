import 'dart:collection';
import 'dart:io';

import 'package:apidash/consts.dart';
import 'package:apidash/utils/file_utils.dart';
import 'package:path/path.dart' as p;

// ---------------------------------------------------------------------------
// Write journal — filters app self-writes from Directory.watch
// ---------------------------------------------------------------------------

class WorkspaceWriteJournal {
  WorkspaceWriteJournal({
    this.ttl = const Duration(milliseconds: 2000),
  });

  final Duration ttl;
  final Map<String, DateTime> _entries = HashMap();

  void record(String path) {
    final normalized = _normalize(path);
    if (normalized.isEmpty) return;
    _entries[normalized] = DateTime.now();
    _purgeExpired();
  }

  /// Matches [path] or any descendant of a journaled path.
  bool wasRecent(String path) {
    _purgeExpired();
    final normalized = _normalize(path);
    if (normalized.isEmpty) return false;
    if (_entries.containsKey(normalized)) return true;
    for (final entry in _entries.keys) {
      if (p.isWithin(entry, normalized)) {
        return true;
      }
    }
    return false;
  }

  void clear() {
    _entries.clear();
  }

  void _purgeExpired() {
    final cutoff = DateTime.now().subtract(ttl);
    _entries.removeWhere((_, at) => at.isBefore(cutoff));
  }

  static String _normalize(String path) {
    final value = path.trim();
    if (value.isEmpty) return '';
    return p.normalize(value);
  }
}

final workspaceWriteJournal = WorkspaceWriteJournal();

// ---------------------------------------------------------------------------
// Classified filesystem events
// ---------------------------------------------------------------------------

sealed class WorkspaceDiskChange {
  const WorkspaceDiskChange();
}

final class WorkspaceRootRemoved extends WorkspaceDiskChange {
  const WorkspaceRootRemoved();

  @override
  bool operator ==(Object other) => other is WorkspaceRootRemoved;

  @override
  int get hashCode => runtimeType.hashCode;
}

final class CollectionRemovedFromDisk extends WorkspaceDiskChange {
  const CollectionRemovedFromDisk(this.collectionId);
  final String collectionId;

  @override
  bool operator ==(Object other) =>
      other is CollectionRemovedFromDisk && other.collectionId == collectionId;

  @override
  int get hashCode => Object.hash(runtimeType, collectionId);
}

final class CollectionAddedFromDisk extends WorkspaceDiskChange {
  const CollectionAddedFromDisk(this.collectionId);
  final String collectionId;

  @override
  bool operator ==(Object other) =>
      other is CollectionAddedFromDisk && other.collectionId == collectionId;

  @override
  int get hashCode => Object.hash(runtimeType, collectionId);
}

final class RequestRemovedFromDisk extends WorkspaceDiskChange {
  const RequestRemovedFromDisk({
    required this.collectionId,
    required this.requestId,
  });
  final String collectionId;
  final String requestId;

  @override
  bool operator ==(Object other) =>
      other is RequestRemovedFromDisk &&
      other.collectionId == collectionId &&
      other.requestId == requestId;

  @override
  int get hashCode => Object.hash(runtimeType, collectionId, requestId);
}

final class RequestAddedFromDisk extends WorkspaceDiskChange {
  const RequestAddedFromDisk({
    required this.collectionId,
    required this.requestId,
  });
  final String collectionId;
  final String requestId;

  @override
  bool operator ==(Object other) =>
      other is RequestAddedFromDisk &&
      other.collectionId == collectionId &&
      other.requestId == requestId;

  @override
  int get hashCode => Object.hash(runtimeType, collectionId, requestId);
}

final class RequestContentChangedOnDisk extends WorkspaceDiskChange {
  const RequestContentChangedOnDisk({
    required this.collectionId,
    required this.requestId,
  });
  final String collectionId;
  final String requestId;

  @override
  bool operator ==(Object other) =>
      other is RequestContentChangedOnDisk &&
      other.collectionId == collectionId &&
      other.requestId == requestId;

  @override
  int get hashCode => Object.hash(runtimeType, collectionId, requestId);
}

final class CollectionIndexChangedOnDisk extends WorkspaceDiskChange {
  const CollectionIndexChangedOnDisk();

  @override
  bool operator ==(Object other) => other is CollectionIndexChangedOnDisk;

  @override
  int get hashCode => runtimeType.hashCode;
}

final class RequestIndexChangedOnDisk extends WorkspaceDiskChange {
  const RequestIndexChangedOnDisk(this.collectionId);
  final String collectionId;

  @override
  bool operator ==(Object other) =>
      other is RequestIndexChangedOnDisk && other.collectionId == collectionId;

  @override
  int get hashCode => Object.hash(runtimeType, collectionId);
}

final class WorkflowRemovedFromDisk extends WorkspaceDiskChange {
  const WorkflowRemovedFromDisk(this.workflowId);
  final String workflowId;

  @override
  bool operator ==(Object other) =>
      other is WorkflowRemovedFromDisk && other.workflowId == workflowId;

  @override
  int get hashCode => Object.hash(runtimeType, workflowId);
}

final class WorkflowAddedFromDisk extends WorkspaceDiskChange {
  const WorkflowAddedFromDisk(this.workflowId);
  final String workflowId;

  @override
  bool operator ==(Object other) =>
      other is WorkflowAddedFromDisk && other.workflowId == workflowId;

  @override
  int get hashCode => Object.hash(runtimeType, workflowId);
}

final class WorkflowContentChangedOnDisk extends WorkspaceDiskChange {
  const WorkflowContentChangedOnDisk(this.workflowId);
  final String workflowId;

  @override
  bool operator ==(Object other) =>
      other is WorkflowContentChangedOnDisk && other.workflowId == workflowId;

  @override
  int get hashCode => Object.hash(runtimeType, workflowId);
}

final class WorkflowIndexChangedOnDisk extends WorkspaceDiskChange {
  const WorkflowIndexChangedOnDisk();

  @override
  bool operator ==(Object other) => other is WorkflowIndexChangedOnDisk;

  @override
  int get hashCode => runtimeType.hashCode;
}

final class EnvironmentRemovedFromDisk extends WorkspaceDiskChange {
  const EnvironmentRemovedFromDisk(this.environmentId);
  final String environmentId;

  @override
  bool operator ==(Object other) =>
      other is EnvironmentRemovedFromDisk &&
      other.environmentId == environmentId;

  @override
  int get hashCode => Object.hash(runtimeType, environmentId);
}

final class EnvironmentAddedFromDisk extends WorkspaceDiskChange {
  const EnvironmentAddedFromDisk(this.environmentId);
  final String environmentId;

  @override
  bool operator ==(Object other) =>
      other is EnvironmentAddedFromDisk &&
      other.environmentId == environmentId;

  @override
  int get hashCode => Object.hash(runtimeType, environmentId);
}

final class EnvironmentContentChangedOnDisk extends WorkspaceDiskChange {
  const EnvironmentContentChangedOnDisk(this.environmentId);
  final String environmentId;

  @override
  bool operator ==(Object other) =>
      other is EnvironmentContentChangedOnDisk &&
      other.environmentId == environmentId;

  @override
  int get hashCode => Object.hash(runtimeType, environmentId);
}

final class EnvironmentIndexChangedOnDisk extends WorkspaceDiskChange {
  const EnvironmentIndexChangedOnDisk();

  @override
  bool operator ==(Object other) => other is EnvironmentIndexChangedOnDisk;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// Maps a [FileSystemEvent] under [workspaceRoot] into a domain change.
///
/// Cross-platform notes:
/// - macOS Trash delete often arrives as [FileSystemMoveEvent] out of the tree
/// - Windows Recycle Bin / Linux trash are usually delete or move-out — both
///   classify as removal via [_isRemovalEvent]
/// - Create = drop/copy into the workspace
WorkspaceDiskChange? classifyWorkspaceDiskEvent({
  required FileSystemEvent event,
  required String workspaceRoot,
}) {
  final root = p.normalize(workspaceRoot);
  final eventPath = p.normalize(event.path);

  final isRemoval = _isRemovalEvent(event, root);
  final isCreate = event is FileSystemCreateEvent;
  final isContentWrite = event is FileSystemModifyEvent ||
      isCreate ||
      _isRenameWithinWorkspace(event, root);

  if (eventPath == root) {
    if (isRemoval) return const WorkspaceRootRemoved();
    return null;
  }

  if (!p.isWithin(root, eventPath)) return null;

  final relative = p.relative(eventPath, from: root);
  final segments = p.split(relative);
  if (segments.isEmpty) return null;
  if (segments.any(_shouldIgnoreSegment)) return null;

  final top = segments.first;
  if (top == kWorkspaceCollectionsDir) {
    return _classifyCollectionDiskEvent(
      segments: segments,
      isRemoval: isRemoval,
      isCreate: isCreate,
      isContentWrite: isContentWrite,
    );
  }
  if (top == kWorkspaceWorkflowsDir) {
    return _classifyWorkflowDiskEvent(
      segments: segments,
      isRemoval: isRemoval,
      isCreate: isCreate,
      isContentWrite: isContentWrite,
    );
  }
  if (top == kWorkspaceEnvironmentsDir) {
    return _classifyEnvironmentDiskEvent(
      segments: segments,
      isRemoval: isRemoval,
      isCreate: isCreate,
      isContentWrite: isContentWrite,
    );
  }
  return null;
}

WorkspaceDiskChange? _classifyCollectionDiskEvent({
  required List<String> segments,
  required bool isRemoval,
  required bool isCreate,
  required bool isContentWrite,
}) {
  if (segments.length == 2 && segments[1] == kWorkspaceCollectionsIndexFile) {
    if (isContentWrite && !isRemoval) {
      return const CollectionIndexChangedOnDisk();
    }
    return null;
  }

  if (segments.length < 2) return null;

  final collectionId = segments[1];
  if (collectionId.isEmpty || collectionId.startsWith('.')) return null;

  if (segments.length == 2) {
    if (isRemoval) return CollectionRemovedFromDisk(collectionId);
    if (isCreate) return CollectionAddedFromDisk(collectionId);
    return null;
  }

  final third = segments[2];

  if (segments.length == 3 && third == kWorkspaceRequestIndexFile) {
    if (isContentWrite && !isRemoval) {
      return RequestIndexChangedOnDisk(collectionId);
    }
    return null;
  }

  final requestId = third;
  if (requestId.isEmpty ||
      requestId.startsWith('.') ||
      requestId.endsWith(kJsonFileExtension)) {
    return null;
  }

  if (segments.length == 3) {
    if (isRemoval) {
      return RequestRemovedFromDisk(
        collectionId: collectionId,
        requestId: requestId,
      );
    }
    if (isCreate) {
      return RequestAddedFromDisk(
        collectionId: collectionId,
        requestId: requestId,
      );
    }
    return null;
  }

  if (segments.length == 4 && segments[3] == kWorkspaceRequestFile) {
    if (isRemoval) {
      return RequestRemovedFromDisk(
        collectionId: collectionId,
        requestId: requestId,
      );
    }
    if (isCreate) {
      return RequestAddedFromDisk(
        collectionId: collectionId,
        requestId: requestId,
      );
    }
    if (isContentWrite) {
      return RequestContentChangedOnDisk(
        collectionId: collectionId,
        requestId: requestId,
      );
    }
  }

  return null;
}

WorkspaceDiskChange? _classifyWorkflowDiskEvent({
  required List<String> segments,
  required bool isRemoval,
  required bool isCreate,
  required bool isContentWrite,
}) {
  if (segments.length == 2 && segments[1] == kWorkspaceWorkflowsIndexFile) {
    if (isContentWrite && !isRemoval) {
      return const WorkflowIndexChangedOnDisk();
    }
    return null;
  }

  if (segments.length != 2) return null;

  final fileName = segments[1];
  if (!fileName.endsWith(kJsonFileExtension)) {
    return null;
  }
  final workflowId = fileName.substring(
    0,
    fileName.length - kJsonFileExtension.length,
  );
  if (workflowId.isEmpty || workflowId.startsWith('.')) {
    return null;
  }

  if (isRemoval) return WorkflowRemovedFromDisk(workflowId);
  if (isCreate) return WorkflowAddedFromDisk(workflowId);
  if (isContentWrite) return WorkflowContentChangedOnDisk(workflowId);
  return null;
}

WorkspaceDiskChange? _classifyEnvironmentDiskEvent({
  required List<String> segments,
  required bool isRemoval,
  required bool isCreate,
  required bool isContentWrite,
}) {
  if (segments.length == 2 && segments[1] == kWorkspaceEnvironmentIndexFile) {
    if (isContentWrite && !isRemoval) {
      return const EnvironmentIndexChangedOnDisk();
    }
    return null;
  }

  if (segments.length != 2) return null;

  final fileName = segments[1];
  if (!fileName.endsWith(kJsonFileExtension)) {
    return null;
  }
  final environmentId = fileName.substring(
    0,
    fileName.length - kJsonFileExtension.length,
  );
  if (environmentId.isEmpty || environmentId.startsWith('.')) {
    return null;
  }

  if (isRemoval) return EnvironmentRemovedFromDisk(environmentId);
  if (isCreate) return EnvironmentAddedFromDisk(environmentId);
  if (isContentWrite) return EnvironmentContentChangedOnDisk(environmentId);
  return null;
}

bool _isRemovalEvent(FileSystemEvent event, String root) {
  if (event is FileSystemDeleteEvent) return true;
  if (event is FileSystemMoveEvent) {
    final destination = event.destination;
    if (destination == null || destination.isEmpty) return true;
    final dest = p.normalize(destination);
    return dest == root ? false : !p.isWithin(root, dest);
  }
  return false;
}

bool _isRenameWithinWorkspace(FileSystemEvent event, String root) {
  if (event is! FileSystemMoveEvent) return false;
  final destination = event.destination;
  if (destination == null || destination.isEmpty) return false;
  return p.isWithin(root, p.normalize(destination));
}

bool _shouldIgnoreSegment(String segment) {
  if (segment == '.git' || segment == 'node_modules' || segment == '.apidash') {
    return true;
  }
  if (segment.endsWith('.tmp')) return true;
  if (segment.startsWith('.')) return true;
  return false;
}

// ---------------------------------------------------------------------------
// OS duplicate folder naming (macOS / Windows / Linux)
// ---------------------------------------------------------------------------

final _macCopyPattern = RegExp(
  r'^(.*) copy(?: (\d+))?$',
  caseSensitive: false,
);
final _windowsCopyPattern = RegExp(
  r'^(.*) - Copy(?: \((\d+)\))?$',
  caseSensitive: false,
);
final _linuxCopyPattern = RegExp(
  r'^(.*) \((?:another )?copy(?: (\d+))?\)$',
  caseSensitive: false,
);

typedef _OsDuplicate = ({String base, int? number});

_OsDuplicate? _parseOsDuplicateName(String folderName) {
  final trimmed = folderName.trim();

  var match = _macCopyPattern.firstMatch(trimmed);
  if (match != null) {
    return (
      base: match.group(1)!.trim(),
      number: int.tryParse(match.group(2) ?? ''),
    );
  }

  match = _windowsCopyPattern.firstMatch(trimmed);
  if (match != null) {
    final n = match.group(2);
    return (
      base: match.group(1)!.trim(),
      number: n == null ? null : int.tryParse(n),
    );
  }

  match = _linuxCopyPattern.firstMatch(trimmed);
  if (match != null) {
    return (
      base: match.group(1)!.trim(),
      number: int.tryParse(match.group(2) ?? ''),
    );
  }

  return null;
}

bool looksLikeOsDuplicateName(String folderName) =>
    _parseOsDuplicateName(folderName) != null;

bool requestFolderNeedsNormalize(String folderId) {
  final trimmed = folderId.trim();
  if (trimmed.contains(' ') || trimmed.contains('(')) return true;
  if (looksLikeOsDuplicateName(trimmed)) return true;
  return storageIdSuffix(trimmed) == null;
}

String _humanizeStorageFolderName(String folderId) {
  var value = folderId.trim();
  final dup = _parseOsDuplicateName(value);
  if (dup != null) {
    value = dup.base;
  }
  final suffix = storageIdSuffix(value);
  if (suffix != null) {
    value = value.substring(0, value.length - 9);
  }
  value = value.replaceAll('-', ' ').replaceAll('_', ' ').trim();
  return value.isEmpty ? 'request' : value;
}

String ensureUniqueDisplayName(String name, Set<String> takenLowercase) {
  final trimmed = name.trim().isEmpty ? 'request' : name.trim();
  if (!takenLowercase.contains(trimmed.toLowerCase())) {
    return trimmed;
  }
  final copyMatch = _macCopyPattern.firstMatch(trimmed);
  if (copyMatch != null) {
    final root = copyMatch.group(1)!.trim();
    var n = int.tryParse(copyMatch.group(2) ?? '1') ?? 1;
    String candidate;
    do {
      n++;
      candidate = '$root copy $n';
    } while (takenLowercase.contains(candidate.toLowerCase()));
    return candidate;
  }
  var candidate = '$trimmed copy';
  var n = 2;
  while (takenLowercase.contains(candidate.toLowerCase())) {
    candidate = '$trimmed copy $n';
    n++;
  }
  return candidate;
}

/// Folder basename is identity. OS duplicates get a distinct display name.
String displayNameForRequestFolder({
  required String folderId,
  required String jsonName,
  required Set<String> takenDisplayNamesLowercase,
}) {
  final trimmedJson = jsonName.trim();
  final dup = _parseOsDuplicateName(folderId);
  String base;
  if (dup != null) {
    final fromJson = trimmedJson.isNotEmpty
        ? trimmedJson
        : _humanizeStorageFolderName(dup.base);
    final alreadyCopy = _parseOsDuplicateName(fromJson) != null ||
        _macCopyPattern.hasMatch(fromJson);
    if (alreadyCopy) {
      base = fromJson;
    } else if (dup.number == null) {
      base = '$fromJson copy';
    } else {
      base = '$fromJson copy ${dup.number}';
    }
  } else if (trimmedJson.isNotEmpty) {
    base = trimmedJson;
  } else {
    base = _humanizeStorageFolderName(folderId);
  }
  return ensureUniqueDisplayName(base, takenDisplayNamesLowercase);
}
