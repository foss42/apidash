import 'package:apidash/git/widgets/git_visual_diff/git_diff_file_kind.dart';
import 'package:apidash/git/widgets/git_visual_diff/git_diff_snapshots.dart';
import 'package:apidash/git/widgets/git_visual_diff/git_list_diff.dart';
import 'package:apidash/git/widgets/git_visual_diff/git_request_visual_diff.dart';
import 'package:apidash/git/widgets/git_visual_diff/git_response_visual_diff.dart';
import 'package:apidash/git/widgets/git_visual_diff/git_workflow_visual_diff.dart';
import 'package:flutter/material.dart';

class GitVisualDiffView extends StatelessWidget {
  const GitVisualDiffView({
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

    return switch (fileKind) {
      GitDiffFileKind.request => GitRequestVisualDiff(
        original: parseRequestModel(snapshots.headJson),
        current: parseRequestModel(snapshots.currentJson),
        originalRaw: snapshots.headRaw,
        currentRaw: snapshots.currentRaw,
      ),
      GitDiffFileKind.response => GitResponseVisualDiff(
        original: parseResponseModel(snapshots.headJson),
        current: parseResponseModel(snapshots.currentJson),
        originalRaw: snapshots.headRaw,
        currentRaw: snapshots.currentRaw,
      ),
      GitDiffFileKind.responseBody => GitResponseVisualDiff(
        original: parseResponseModel(snapshots.headJson),
        current: parseResponseModel(snapshots.currentJson),
        originalRaw: snapshots.headRaw,
        currentRaw: snapshots.currentRaw,
      ),
      GitDiffFileKind.collection => _buildListDiff(
        diffCollectionRows(
          head: snapshots.headJson,
          current: snapshots.currentJson,
        ),
      ),
      GitDiffFileKind.collectionIndex => _buildListDiff(
        diffCollectionIndexRows(
          head: snapshots.headJson,
          current: snapshots.currentJson,
        ),
      ),
      GitDiffFileKind.environment => _buildListDiff(
        diffEnvironmentRows(
          head: snapshots.headJson,
          current: snapshots.currentJson,
        ),
      ),
      GitDiffFileKind.environmentIndex => _buildListDiff(
        diffEnvironmentIndexRows(
          head: snapshots.headJson,
          current: snapshots.currentJson,
        ),
      ),
      GitDiffFileKind.workflow => GitWorkflowVisualDiff(
        original: parseWorkflowDocument(snapshots.headJson),
        current: parseWorkflowDocument(snapshots.currentJson),
        originalRaw: snapshots.headRaw,
        currentRaw: snapshots.currentRaw,
      ),
      GitDiffFileKind.workflowIndex => _buildListDiff(
        diffWorkflowIndexRows(
          head: snapshots.headJson,
          current: snapshots.currentJson,
        ),
      ),
      GitDiffFileKind.unsupported => const SizedBox.shrink(),
    };
  }

  Widget _buildListDiff(List<GitListDiffRow> rows) {
    if (rows.isNotEmpty) {
      return GitListDiffView(rows: rows);
    }
    return GitListSnapshotPreview(fileKind: fileKind, snapshots: snapshots);
  }
}
