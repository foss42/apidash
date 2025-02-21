## Contribution Guidelines

We value your participation in this open source project. This page will give you a quick overview of how to get involved.

You can contribute to the project in any or all of the following ways: 

- [Ask a question](https://github.com/foss42/apidash/discussions)
- [Submit a bug report](https://github.com/foss42/apidash/issues/new/choose)
- [Request a new feature](https://github.com/foss42/apidash/issues/new/choose)
- [Suggest ways to improve the developer experience of an existing feature](https://github.com/foss42/apidash/issues/new/choose)
- Add documentation
- Add a new feature, resolve an existing issue or add a new test to the project. (Goto [Code Contribution Guidelines](#code-contribution-guidelines)).

## Resources for New Contributors

- API Dash Code Walkthrough - [Video](https://www.youtube.com/live/rIlwCTKNz-A?si=iMxTxzkpY_ySo4Ow&t=339)
- Getting Started with Flutter - [Video](https://www.youtube.com/watch?v=8K2gV1P6ZHI)
- API Dash Developer Guide - [Read](https://github.com/foss42/apidash/blob/main/doc/dev_guide/README.md)

## Code Contribution Guidelines

### Why we do not assign issues to anyone?

- By not assigning issues upfront, anyone can feel welcome to contribute without feeling like the issue is already "taken."
- This also prevents discouraging new contributors who might feel locked out if issues are pre-assigned.
- Contributors are encouraged to pick issues that align with their skills and interests. To take initiative rather than waiting for permission or being "assigned" work.
- Sometimes contributors express interest but never follow through. If issues are assigned prematurely, others might avoid working on them, delaying progress.
- Leaving issues unassigned ensures that work can proceed without bottlenecks if someone goes inactive.
- Open issues encourage community discussion and brainstorming. Prematurely assigning an issue can stifle input from others who might have better ideas or solutions.
- As open-source work is often voluntary, and contributors' availability can change. Keeping issues unassigned allows anyone to step in if the original contributor becomes unavailable.
This also supports multiple contributors collaborating on larger or complex issues.

### I have not contributed to any open source project before. Will I get any guidance?

In case you are new to the open source ecosystem, we would be more than happy to guide you through the entire process. Just join our [Discord server](https://bit.ly/heyfoss) and drop a message in the **#foss** channel.

### Some things to keep in mind before opening a PR

> PRs with precise changes (like adding a new test, resolving a bug/issue, adding a new feature) are always preferred over a single PR with a ton of file changes as they are easier to review and merge.

We currently do not accept PRs that involve:
- Code refactoring without any new feature addition/existing issue resolution.
- Bumping of dependency versions (SDKs, Packages).

### Resolving an existing issue / Adding a requested feature

You can find all existing issues [here](https://github.com/foss42/apidash/issues). A good place to start is to take a look at ["good first issues"](https://github.com/foss42/apidash/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22). 

**Step 1** - Identify the issue you want to work on.  
**Step 2** - Comment on the issue so that we can discuss how to approach and solve the problem.  
**Step 3** - Fork the [`foss42/apidash`](https://github.com/foss42/apidash) repo to your account.  
**Step 4** - Create a new branch in your fork and name it `add-feature-xyz` or `resolve-issue-xyz`.  
**Step 5** - Run API Dash locally (More details [here](#how-to-run-api-dash-locally)).  
**Step 6** - Make code changes in the branch.  
**Step 7** - Once code changes have been made. Make sure you add the relevant tests in the `test` folder and run tests (More details [here](#how-to-run-tests)).  
**Step 8** - [Open a Pull Request](https://help.github.com/articles/using-pull-requests/) with a clear title and description and add a reference to the issue (`#issue-number`).  
**Step 9** - Wait for feedback and review. We will closely work with you on the Pull Request.

### Adding a new feature

**Step 1** - Open an [issue](https://github.com/foss42/apidash/issues/new/choose) so that we can discuss on the new feature.  
**Step 2** - Fork the [`foss42/apidash`](https://github.com/foss42/apidash) repo to your account.  
**Step 3** - Create a new branch in your fork and name it `add-feature-xyz`.   
**Step 4** - Run API Dash locally (More details [here](#how-to-run-api-dash-locally)).  
**Step 5** - Make the necessary code changes required to implement the feature in the branch.  
**Step 6** - Once the feature is implemented. Make sure you add the relevant tests in the `test` folder and run tests (More details [here](#how-to-run-tests)).  
**Step 7** - [Open a Pull Request](https://help.github.com/articles/using-pull-requests/) with a clear title and description and add a reference to the issue (`#issue-number`).  
**Step 8** - Wait for feedback and review. We will closely work with you on the Pull Request.

### Adding a new test

You can contribute by adding missing/new tests for:
- Widgets (`lib/widgets/`)
- Models (`lib/models/`)
- Utilities (`lib/utils/`)
- Riverpod providers (`lib/providers/`)
- Code generation (`lib/codegen/`) 
- Services (`lib/services/`).

**Step 1** - Identify the test you want to add or improve.  
**Step 2** - Fork the [`foss42/apidash`](https://github.com/foss42/apidash) repo to your account.  
**Step 3** - Create a new branch in your fork and name it `add-test-xyz`.  
**Step 4** - Add the test to an existing test file or create a new test file in the `test` folder.  
**Step 5** - Run the tests locally (More details [here](#how-to-run-tests)).  
**Step 6** - [Open a Pull Request](https://help.github.com/articles/using-pull-requests/) with a clear title and description of the tests you are adding.  
**Step 7** - Wait for feedback and review. We will closely work with you on the Pull Request.

## General Instructions 

### What is the supported Flutter/Dart version?

This project supports the latest Dart 3 & Flutter version. If you are using older Flutter version that does not support Dart 3, you might get errors. 

In case you are setting up Flutter for the first time, just go ahead and download the latest (Stable) SDK from the [Flutter SDK Archive](https://docs.flutter.dev/release/archive). Then proceed with the Flutter installation.

In case you have already setup Flutter, make sure to switch to `stable` branch and upgrade it.

### How to run API Dash locally?

Check out [here](https://github.com/foss42/apidash/blob/main/doc/dev_guide/setup_run.md)

### How to run tests?

Check out [here](https://github.com/foss42/apidash/blob/main/doc/dev_guide/testing.md)

### How to add a new package to pubspec.yaml?

Instead of copy pasting from pub.dev, it is recommended that you use `flutter pub add package_name` to add a new package to `pubspec.yaml`. You can read more [here](https://docs.flutter.dev/packages-and-plugins/using-packages#adding-a-package-dependency-to-an-app-using-flutter-pub-add).
