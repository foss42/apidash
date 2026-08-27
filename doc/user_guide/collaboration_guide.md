# Collaboration (Git & Sync to phone)

Use the **Collaboration** rail (desktop) to version your workspace with Git and to sync with a phone over the same Wi‑Fi via QR.

**Desktop:** Git + Sync to phone.  
**Mobile:** Sync (QR) only.


## Workspace as a Git repo

API Dash treats your **workspace folder** as the Git repository root. Collections, environments, and related JSON on disk are what get committed (history and local secrets stay out of Git by design).

Typical setup:

1. Open Collaboration.
2. If Git is missing, install it (system Git — Credential Manager / SSH agent).
3. Initialize the repository on this workspace (if needed).
4. Connect a remote (GitHub, GitLab, Bitbucket, etc.).
5. Select changes, commit, then push.

You can also clone an Apidash workspace repo from the workspace selector.


## Check remote, Pull, and Push

These map to normal Git operations. The labels prefer plain language where it helps.

### Check remote

Runs `git fetch`. It **does not change your workspace files**. It only refreshes what the remote has so API Dash can show ahead/behind.

After a successful check you get a snackbar, for example:

- **Up to date with remote**
- **N commits available — Pull to apply**
- **N local commits to push**
- **Behind and ahead** (diverged — Pull may need a merge)

The overview also shows **Last checked: …**.

### Pull

Brings remote commits into the workspace and reloads requests/environments from disk. Use this when you are **behind** the remote.

When you are behind, **Pull** is emphasized (filled button) so it is the obvious next step after Check remote.

### Push

Sends your local commits to the remote (when you are **ahead**). If the remote has new commits you have not pulled, push may be rejected — Check remote / Pull first.


## Changes, diffs, and branches

- The left pane lists uncommitted changes (checkbox tree). Prefer selecting Apidash workspace paths for commits.
- Select a file to preview a **visual** or **raw** diff.
- Switch or create branches from the branch control.
- Overflow actions may include restore commit, reset workspace, reveal folder, or open in an editor.


## Sync to phone (LAN QR)

On the same Collaboration page (desktop), **Sync to phone** starts a short-lived QR session over the local network. Sync is **one-way per apply** (Send or Receive), then the session ends. It is separate from Git: Sync does not commit or push.

Mobile opens Collaboration / scan QR to join. First pairing is phone-driven (adopt/replace); later sessions can be incremental against a stored baseline.

Do not put secrets you care about only in synced JSON values that are meant to stay device-local (env secrets and AI keys use secure storage and are not copied with the folder).


## Tips

- **Check remote** ≠ **Pull**. Check only updates status; Pull updates files.
- Flush pending edits before Pull / Push / branch switch when prompted (autosave normally handles this).
- If authentication fails, sign in with Git Credential Manager or SSH outside the app , API Dash does not open an interactive Git password prompt.
