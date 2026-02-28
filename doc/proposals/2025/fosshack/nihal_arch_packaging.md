# Add Arch Linux packaging instructions and CI Pipeline

Issue - https://github.com/foss42/apidash/issues/545  
PR - https://github.com/foss42/apidash/pull/594  
Link - https://fossunited.org/hack/fosshack25/p/e5n4kirnno

A GitHub action is triggered on new version tags when `pubspec.yaml` changes

It:
  - Extracts version from pubspec.yaml
  - Downloads and generates checksums for the .deb package and LICENSE
  - Updates the PKGBUILD with new version and checksums
  - Publishes to AUR using the KSXGitHub/github-actions-deploy-aur action

The following secrets need to be added to the GitHub repository:

- `AUR_USERNAME`: Maintainer's AUR username
- `AUR_EMAIL`: Maintainer's AUR email address
- `AUR_SSH_PRIVATE_KEY`: Maintiner's SSH private key with AUR access

Adding workflow for `.deb` turned out to be complex than I had thought.  
I have added the support for arm64 and this will assume `.deb` files are available at release time.  
If they’re not, it will fail, prompting manual intervention or a separate release process.
