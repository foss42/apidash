import 'package:apidash/consts.dart';
import 'package:apidash/models/collection_model.dart';
import 'package:apidash/models/request_summary_model.dart';
import 'package:apidash/utils/file_utils.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

import 'git_diff_file_kind.dart';
import 'git_diff_side_by_side_shell.dart';
import 'git_diff_snapshots.dart';
import 'git_json_fallback_column.dart';
import 'git_request_visual_diff.dart';

enum GitListDiffRowKind { added, removed, modified }

class GitListDiffRow {
  const GitListDiffRow({
    required this.kind,
    required this.label,
    this.detail,
    this.method,
    this.apiType,
  });

  final GitListDiffRowKind kind;
  final String label;
  final String? detail;
  final HTTPVerb? method;
  final APIType? apiType;
}

List<GitListDiffRow> diffCollectionIndexRows({
  Map<String, Object?>? head,
  Map<String, Object?>? current,
}) {
  final original = _parseCollectionIndex(head);
  final updated = _parseCollectionIndex(current);
  return _diffById(
    original: original,
    updated: updated,
    idOf: (e) => e.id,
    labelOf: (e) => e.name.isNotEmpty ? e.name : e.id,
    equals: (a, b) => a.id == b.id && a.name == b.name,
    modifiedDetail: (a, b) =>
        a.name == b.name ? null : '${a.name} → ${b.name}',
  );
}

List<GitListDiffRow> diffCollectionRows({
  Map<String, Object?>? head,
  Map<String, Object?>? current,
}) {
  final rows = <GitListDiffRow>[];
  final headModel =
      head != null ? CollectionModel.fromJson(head) : null;
  final currentModel =
      current != null ? CollectionModel.fromJson(current) : null;

  if (headModel != null &&
      currentModel != null &&
      headModel.name != currentModel.name) {
    rows.add(
      GitListDiffRow(
        kind: GitListDiffRowKind.modified,
        label: headModel.name.isNotEmpty ? headModel.name : headModel.id,
        detail: '${headModel.name} → ${currentModel.name}',
      ),
    );
  }

  rows.addAll(
    _diffById<RequestSummary>(
      original: headModel?.requests ?? const [],
      updated: currentModel?.requests ?? const [],
      idOf: (e) => e.id,
      labelOf: _requestSummaryLabel,
      equals: _requestSummaryEquals,
      modifiedDetail: _requestSummaryModifiedDetail,
      detailOf: _requestSummaryPresenceDetail,
      methodOf: (e) => e.method,
      apiTypeOf: (e) => e.apiType,
    ),
  );
  return rows;
}

List<GitListDiffRow> diffEnvironmentIndexRows({
  Map<String, Object?>? head,
  Map<String, Object?>? current,
}) {
  final original = _parseEnvironmentIds(head);
  final updated = _parseEnvironmentIds(current);
  return _diffById(
    original: original.map((id) => _IdLabel(id: id, label: id)).toList(),
    updated: updated.map((id) => _IdLabel(id: id, label: id)).toList(),
    idOf: (e) => e.id,
    labelOf: (e) => e.label,
    equals: (a, b) => a.id == b.id,
  );
}

List<GitListDiffRow> diffWorkflowIndexRows({
  Map<String, Object?>? head,
  Map<String, Object?>? current,
}) {
  final original = _parseWorkflowNames(head);
  final updated = _parseWorkflowNames(current);
  return _diffById(
    original: original.map((name) => _IdLabel(id: name, label: name)).toList(),
    updated: updated.map((name) => _IdLabel(id: name, label: name)).toList(),
    idOf: (e) => e.id,
    labelOf: (e) => e.label,
    equals: (a, b) => a.id == b.id,
  );
}

List<GitListDiffRow> diffEnvironmentRows({
  Map<String, Object?>? head,
  Map<String, Object?>? current,
}) {
  final rows = <GitListDiffRow>[];
  final headModel =
      head != null ? EnvironmentModel.fromJson(head) : null;
  final currentModel =
      current != null ? EnvironmentModel.fromJson(current) : null;

  if (headModel != null &&
      currentModel != null &&
      headModel.name != currentModel.name) {
    rows.add(
      GitListDiffRow(
        kind: GitListDiffRowKind.modified,
        label: headModel.name.isNotEmpty ? headModel.name : headModel.id,
        detail: '${headModel.name} → ${currentModel.name}',
      ),
    );
  }

  rows.addAll(
    _diffById<EnvironmentVariableModel>(
      original: headModel?.values ?? const [],
      updated: currentModel?.values ?? const [],
      idOf: (e) => e.key,
      labelOf: (e) => e.key,
      equals: _envVarEquals,
      modifiedDetail: _envVarModifiedDetail,
      detailOf: _envVarPresenceDetail,
    ),
  );
  return rows;
}

class _IdLabel {
  const _IdLabel({required this.id, required this.label});
  final String id;
  final String label;
}

List<({String id, String name})> _parseCollectionIndex(
  Map<String, Object?>? json,
) {
  if (json == null) return const [];
  final entries = json[kWorkspaceCollectionsIndexKey];
  if (entries is! List) return const [];
  final result = <({String id, String name})>[];
  for (final item in entries) {
    if (item is! String) continue;
    final name = item.trim();
    if (name.isEmpty) continue;
    final id = makeCollectionId(name);
    result.add((id: id, name: name));
  }
  return result;
}

List<String> _parseEnvironmentIds(Map<String, Object?>? json) {
  if (json == null) return const [];
  final entries = json[kWorkspaceEnvironmentIdsKey];
  if (entries is! List) return const [];
  return [
    for (final item in entries)
      if (item != null) item.toString(),
  ];
}

List<String> _parseWorkflowNames(Map<String, Object?>? json) {
  if (json == null) return const [];
  final entries = json[kWorkspaceWorkflowsIndexKey];
  if (entries is! List) return const [];
  return [
    for (final item in entries)
      if (item is String && item.trim().isNotEmpty) item.trim(),
  ];
}

String _requestSummaryLabel(RequestSummary summary) {
  final name = summary.name.trim();
  if (name.isNotEmpty) return name;
  final url = summary.url.trim();
  if (url.isNotEmpty) return url;
  return summary.id;
}

bool _requestSummaryEquals(RequestSummary a, RequestSummary b) {
  return a.id == b.id &&
      a.name == b.name &&
      a.apiType == b.apiType &&
      a.method == b.method &&
      a.url == b.url;
}

String? _requestSummaryModifiedDetail(RequestSummary a, RequestSummary b) {
  final parts = <String>[];
  if (a.name != b.name) {
    parts.add('name: ${a.name} → ${b.name}');
  }
  if (a.apiType != b.apiType) {
    parts.add('type: ${a.apiType.label} → ${b.apiType.label}');
  }
  if (a.method != b.method) {
    parts.add(
      'method: ${a.method?.name.toUpperCase() ?? '—'} → '
      '${b.method?.name.toUpperCase() ?? '—'}',
    );
  }
  if (a.url != b.url) {
    parts.add('url: ${a.url} → ${b.url}');
  }
  if (parts.isEmpty) return null;
  return parts.join(' · ');
}

bool _envVarEquals(EnvironmentVariableModel a, EnvironmentVariableModel b) {
  return a.key == b.key &&
      a.enabled == b.enabled &&
      a.type == b.type &&
      (a.type == EnvironmentVariableType.secret
          ? true
          : a.value == b.value);
}

String? _envVarModifiedDetail(
  EnvironmentVariableModel a,
  EnvironmentVariableModel b,
) {
  final parts = <String>[];
  if (a.enabled != b.enabled) {
    parts.add(a.enabled ? 'enabled → disabled' : 'disabled → enabled');
  }
  if (a.type != b.type) {
    parts.add('type: ${a.type.name} → ${b.type.name}');
  }
  if (a.type != EnvironmentVariableType.secret && a.value != b.value) {
    parts.add('value: ${a.value} → ${b.value}');
  } else if (a.type == EnvironmentVariableType.secret &&
      a.type == b.type &&
      a.key == b.key) {
    parts.add('secret value changed');
  }
  if (parts.isEmpty) return null;
  return parts.join(' · ');
}

String? _requestSummaryPresenceDetail(RequestSummary summary) {
  final parts = <String>[];
  if (summary.apiType == APIType.rest && summary.method != null) {
    parts.add(summary.method!.name.toUpperCase());
  } else {
    parts.add(summary.apiType.label);
  }
  final url = summary.url.trim();
  if (url.isNotEmpty) parts.add(url);
  return parts.isEmpty ? null : parts.join(' · ');
}

String? _envVarPresenceDetail(EnvironmentVariableModel variable) {
  final parts = <String>[
    variable.enabled ? 'enabled' : 'disabled',
    'type: ${variable.type.name}',
  ];
  if (variable.type == EnvironmentVariableType.secret) {
    parts.add('••••');
  } else if (variable.value.trim().isNotEmpty) {
    parts.add(variable.value);
  }
  return parts.join(' · ');
}

List<GitListDiffRow> _diffById<T>({
  required List<T> original,
  required List<T> updated,
  required String Function(T) idOf,
  required String Function(T) labelOf,
  required bool Function(T, T) equals,
  String? Function(T, T)? modifiedDetail,
  String? Function(T)? detailOf,
  HTTPVerb? Function(T)? methodOf,
  APIType? Function(T)? apiTypeOf,
}) {
  final origMap = {for (final item in original) idOf(item): item};
  final currMap = {for (final item in updated) idOf(item): item};
  final ids = {...origMap.keys, ...currMap.keys};
  final rows = <GitListDiffRow>[];

  for (final id in ids) {
    final orig = origMap[id];
    final curr = currMap[id];
    if (orig == null && curr != null) {
      rows.add(
        GitListDiffRow(
          kind: GitListDiffRowKind.added,
          label: labelOf(curr),
          detail: detailOf?.call(curr),
          method: methodOf?.call(curr),
          apiType: apiTypeOf?.call(curr),
        ),
      );
    } else if (orig != null && curr == null) {
      rows.add(
        GitListDiffRow(
          kind: GitListDiffRowKind.removed,
          label: labelOf(orig),
          detail: detailOf?.call(orig),
          method: methodOf?.call(orig),
          apiType: apiTypeOf?.call(orig),
        ),
      );
    } else if (orig != null && curr != null && !equals(orig, curr)) {
      rows.add(
        GitListDiffRow(
          kind: GitListDiffRowKind.modified,
          label: labelOf(curr),
          detail: modifiedDetail?.call(orig, curr),
          method: methodOf?.call(curr),
          apiType: apiTypeOf?.call(curr),
        ),
      );
    }
  }
  return rows;
}

class GitListDiffView extends StatelessWidget {
  const GitListDiffView({super.key, required this.rows});

  final List<GitListDiffRow> rows;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (rows.isEmpty) {
      return const GitDiffEmptyState();
    }

    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ListView.separated(
          padding: kP8,
          itemCount: rows.length,
          separatorBuilder: (_, _) => kVSpacer5,
          itemBuilder: (context, index) {
            final row = rows[index];
            final kind = switch (row.kind) {
              GitListDiffRowKind.added => GitDiffChangeKind.added,
              GitListDiffRowKind.removed => GitDiffChangeKind.removed,
              GitListDiffRowKind.modified => GitDiffChangeKind.modified,
            };
            final highlight = getGitDiffHighlight(
              Theme.of(context).brightness,
              kind,
            );

            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: highlight.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: highlight.foreground.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (row.method != null && row.apiType == APIType.rest)
                    Text(
                      row.method!.name.toUpperCase(),
                      style: kCodeStyle.copyWith(
                        fontSize: 11,
                        color: highlight.foreground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  if (row.apiType != null && row.apiType != APIType.rest)
                    Text(
                      row.apiType!.label,
                      style: textTheme.labelSmall?.copyWith(
                        color: highlight.foreground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  Text(
                    row.label,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: highlight.foreground,
                    ),
                  ),
                  if (row.detail != null && row.detail!.isNotEmpty) ...[
                    kVSpacer5,
                    Text(
                      row.detail!,
                      style: textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class GitListSnapshotPreview extends StatelessWidget {
  const GitListSnapshotPreview({
    super.key,
    required this.fileKind,
    required this.snapshots,
  });

  final GitDiffFileKind fileKind;
  final GitDiffSnapshots snapshots;

  @override
  Widget build(BuildContext context) {
    if (!snapshots.hasContent) {
      return const GitDiffEmptyState();
    }

    final originalLines = _linesForSide(fileKind, snapshots.headJson, snapshots.headRaw);
    final currentLines = _linesForSide(fileKind, snapshots.currentJson, snapshots.currentRaw);

    if (originalLines.isEmpty && currentLines.isEmpty) {
      return GitDiffSideBySideShell(
        original: GitJsonFallbackColumn(
          raw: snapshots.headRaw,
          fieldKey: 'git-list-head-fallback',
        ),
        current: GitJsonFallbackColumn(
          raw: snapshots.currentRaw,
          fieldKey: 'git-list-current-fallback',
        ),
      );
    }

    return GitDiffSideBySideShell(
      original: _SnapshotListColumn(lines: originalLines),
      current: _SnapshotListColumn(lines: currentLines),
    );
  }

  List<String> _linesForSide(
    GitDiffFileKind kind,
    Map<String, Object?>? json,
    String? raw,
  ) {
    if (json == null) return const [];
    return switch (kind) {
      GitDiffFileKind.collectionIndex => [
          for (final entry in _parseCollectionIndex(json))
            entry.name.isNotEmpty ? entry.name : entry.id,
        ],
      GitDiffFileKind.collection => [
          if (json[kWorkspaceCollectionNameKey] != null)
            json[kWorkspaceCollectionNameKey].toString(),
          ...CollectionModel.fromJson(json)
              .requests
              .map(_requestSummaryLabel),
        ],
      GitDiffFileKind.environmentIndex => _parseEnvironmentIds(json),
      GitDiffFileKind.environment => [
          if (json['name'] != null) json['name'].toString(),
          ...EnvironmentModel.fromJson(json)
              .values
              .where((v) => v.key.isNotEmpty)
              .map((v) => v.key),
        ],
      GitDiffFileKind.workflowIndex => _parseWorkflowNames(json),
      GitDiffFileKind.workflow => [
          if (json['name'] != null) json['name'].toString(),
          for (final item in (json['nodes'] as List? ?? const []))
            if (item is Map)
              (item['label']?.toString().trim().isNotEmpty ?? false)
                  ? item['label'].toString()
                  : (item['type']?.toString() ?? item['id']?.toString() ?? 'node'),
        ],
      _ => const [],
    };
  }
}

class _SnapshotListColumn extends StatelessWidget {
  const _SnapshotListColumn({required this.lines});

  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    if (lines.isEmpty) {
      return const GitDiffEmptyState();
    }

    final scheme = Theme.of(context).colorScheme;
    return ListView.separated(
      padding: kP12,
      itemCount: lines.length,
      separatorBuilder: (_, _) => kVSpacer5,
      itemBuilder: (context, index) {
        return Text(
          lines[index],
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.9),
              ),
        );
      },
    );
  }
}
