const kLabelCloneFromGitOptional = 'CLONE FROM GIT [OPTIONAL]';
const kMsgGitCloneSuccess = 'Repository cloned and workspace opened';

const kGitIconAsset = 'assets/git/giticon.png';
const kLabelGitAhead = 'Ahead';
const kLabelGitBehind = 'Behind';
const kLabelGitBackToOverview = 'Back';
const kLabelGitDiffPreview = 'Select a file to preview changes';
const kLabelGitDiffLoading = 'Loading diff…';
const kLabelGitDiffEmpty = 'No diff available';
const kLabelGitDiffVisual = 'Visual';
const kLabelGitDiffRaw = 'Raw';
const kLabelGitDiffOriginal = 'Original';
const kLabelGitDiffCurrent = 'Current';
const kLabelGitCommitter = 'Committing as';
const kLabelGitPushOrigin = 'Push origin';
const kMsgGitCommitterNotConfigured =
    'Git user.name is not configured for this repository';
const kMsgGitNotInstalled =
    'Git is not installed. Install Git to clone repositories or use Collaboration.';
const kMsgGitNotARepository = 'This workspace is not a Git repository yet.';
const kMsgGitNoChanges = 'No uncommitted changes';
const kMsgGitNoCommits = 'No commits yet';
const kMsgGitCommitSuccess = 'Changes committed';
const kMsgGitPushSuccess = 'Pushed to remote';
const kMsgGitFetchSuccess = 'Checked remote';
const kMsgGitPullSuccess = 'Pulled latest changes';
const kMsgGitRestoreCommitSuccess = 'Workspace restored to selected commit';
const kMsgGitRestoreCommitConfirmTitle = 'Restore this commit?';
const kMsgGitRestoreCommitConfirmBody =
    'Workspace files will match this commit exactly. Uncommitted edits, newly created untracked files, and any newer commits on this branch are removed locally.';
const kLabelGitRestoreCommit = 'Restore';
const kMsgGitPushRejected =
    'Remote has new changes. Pull first, then push again.';
const kMsgGitPullDivergent =
    'Local and remote both have new commits. Pull again to merge them.';
const kMsgGitMergeConflict =
    'The same file was changed on both sides. Pull was cancelled. Edit the file in your editor, then try Pull again.';
const kMsgGitUnmergedFiles =
    'A previous merge was not finished. Pull was cancelled — try Pull again.';
const kMsgGitAuthRequired =
    'This remote needs authentication. Sign in with Git Credential Manager or SSH, then try again.';
const kMsgGitOverviewHint =
    'Perform git actions or open files from sidebar to view';
const kMsgGitNeverFetched = 'Not checked yet';
const kMsgGitLastFetchedJustNow = 'Last checked: less than a minute ago';
const kMsgGitCheckoutSuccess = 'Switched branch';
const kMsgGitCreateBranchSuccess = 'Created and switched to new branch';
const kLabelGitNewBranch = 'New branch…';
const kLabelGitCreateBranch = 'Create branch';
const kLabelGitSwitchBranch = 'Switch branch';
const kLabelGitNoBranch = 'No branch';
const kTitleGitNewBranch = 'Create new branch';
const kHintGitBranchName = 'e.g. feature/my-change';
const kMsgGitBranchNameEmpty = 'Enter a branch name';
const kMsgGitBranchNameTooLong = 'Branch name is too long';
const kMsgGitBranchNameReserved = 'That name is reserved by Git';
const kMsgGitBranchNameInvalid =
    'Use letters, numbers, hyphens, underscores, and slashes only';
const kMsgGitBranchExists = 'A branch with this name already exists';
const kMsgGitCheckoutLocalChanges =
    'Commit or discard your changes before switching branches';
const kGitInstallUrl = 'https://git-scm.com/downloads';
const kLabelGitSetupStepInstall = 'Install Git';
const kLabelGitSetupStepInit = 'Initialize repository';
const kLabelGitSetupStepRemote = 'Connect remote';
const kLabelGitSetupStepSync = 'Sync workspace';
const kMsgGitSetupInstallBody =
    'Git must be installed on your computer. API Dash uses your system Git for push and pull.';
const kMsgGitSetupInitBody =
    'Turn this workspace folder into a Git repository. Your requests and environments will be versioned as JSON files.';
const kMsgGitSetupRemoteBody =
    'Create an empty repository on GitHub, GitLab, Bitbucket, or any Git host, then paste the clone URL here.';
const kMsgGitSetupSyncBody =
    'Select your changes, write a commit message, and sync to publish the workspace for the first time.';

String formatGitBehindRemoteHint(int behind) {
  final unit = behind == 1 ? 'commit' : 'commits';
  return '$behind $unit behind remote. Pull to update before pushing.';
}

String formatGitFetchResultMessage({
  required int ahead,
  required int behind,
}) {
  if (behind > 0 && ahead > 0) {
    return 'Checked remote: $behind behind, $ahead ahead. Pull may need a merge.';
  }
  if (behind > 0) {
    final unit = behind == 1 ? 'commit' : 'commits';
    return 'Checked remote: $behind $unit available — Pull to apply';
  }
  if (ahead > 0) {
    final unit = ahead == 1 ? 'commit' : 'commits';
    return 'Checked remote: up to date with remote. $ahead local $unit to push';
  }
  return 'Checked remote: up to date with remote';
}
