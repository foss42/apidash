## Contribution Guidelines

We value your participation in this open source project. This page will give you a quick overview of how to get involved.

You can contribute to the project in any or all of the following ways: 

- [Ask a question](https://github.com/foss42/apidash/discussions)
- [Submit a bug report](https://github.com/foss42/apidash/issues/new/choose)
- [Request a new feature](https://github.com/foss42/apidash/issues/new/choose)
- [Suggest ways to improve the developer experience of an existing feature](https://github.com/foss42/apidash/issues/new/choose)
- Add documentation
- Add a new feature, resolve an existing issue or add a new test to the project. (Goto [Code Contribution Guidelines](#code-contribution-guidelines)).

### I have not contributed to any open source project before. Will I get any guidance?

In case you are new to the open source ecosystem, we would be more than happy to guide you through the entire process. Just join our [Discord server](https://bit.ly/heyfoss) and drop a message in the **#foss** channel.

## Code Contribution Guidelines

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

As the project has not migrated to Dart 3, the latest Flutter version we support is `3.7.12` (Dart `2.19.6`). If you are using newer flutter version, you will get errors. 

In case you are setting up Flutter for the first time, just go ahead and download version `3.7.12` (Stable) SDK from the [Flutter SDK Archive](https://docs.flutter.dev/release/archive). Then proceed with the Flutter installation.

In case you have already setup Flutter, make sure to switch to `stable` branch and use the instructions below to downgrade/upgrade if you are on any version other than the one mentioned above.

1. Locate the directory where you have installed Flutter SDK and navigate to it. The contents of the directory should resemble the following:
```
$ ls
analysis_options.yaml  CONTRIBUTING.md       flutter_root.iml  TESTOWNERS
AUTHORS                dartdoc_options.yaml  LICENSE           version
bin                    dev                   packages
CODE_OF_CONDUCT.md     examples              PATENT_GRANT
CODEOWNERS             flutter_console.bat   README.md
```

2. In the same directory, execute the following command to change the head of the local Flutter SDK to version `3.7.12`.
```
git checkout 4d9e56e
```

3. Run the Flutter Doctor command to verify:
```
$ flutter doctor -v

[!] Flutter (Channel unknown, 3.7.12, on Ubuntu 22.04.2 LTS 5.19.0-42-generic,
    locale en_IN)
    ! Flutter version 3.7.12 on channel unknown at
      /home/<user>/snap/flutter/common/flutter
      Currently on an unknown channel. Run `flutter channel` to switch to an
      official channel.
      If that doesn't fix the issue, reinstall Flutter by following instructions
      at https://flutter.dev/docs/get-started/install.
    ! Unknown upstream repository.
      Reinstall Flutter by following instructions at
      https://flutter.dev/docs/get-started/install.
    • Framework revision 4d9e56e694 (5 weeks ago), 2023-04-17 21:47:46 -0400
    • Engine revision 1a65d409c7
    • Dart version 2.19.6
    • DevTools version 2.20.1
    • If those were intentional, you can disregard the above warnings; however
      it is recommended to use "git" directly to perform update checks and
      upgrades.
```

### How to run API Dash locally?

1. Fork the project.
2. Create a clone of the forked project on your computer to run it locally.
3. Based on your desktop environment, enable Windows, macOS or Linux for the project. Select the same target device.
4. This project uses [Records feature in Dart](https://github.com/dart-lang/language/blob/main/accepted/future-releases/records/records-feature-specification.md), so to run the project execute the following command:

```
flutter run --enable-experiment=records
```

### How to run tests?

To run tests execute the following command:

```
flutter test --enable-experiment=records --coverage
```

To generate coverage report as html execute:

```
genhtml coverage/lcov.info -o coverage/html  
```

**Note**: On macOS you need to have `lcov` installed on your system (`brew install lcov`) to run the above command.

To view the coverage report in the browser for further analysis, execute: 

```
open coverage/html/index.html
```

#### Testing a single file

To run tests specified in a single file, execute the following command:

```
flutter test --enable-experiment=records <file_path>.dart
```

Example:

```
flutter test --enable-experiment=records test/widgets/codegen_previewer_test.dart
```

### How to add a new package to pubspec.yaml?

Instead of copy pasting from pub.dev, it is recommended that you use `flutter pub add package_name` to add a new package to `pubspec.yaml`. You can read more [here](https://docs.flutter.dev/packages-and-plugins/using-packages#adding-a-package-dependency-to-an-app-using-flutter-pub-add).
