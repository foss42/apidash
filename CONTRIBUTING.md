## Contribution Guidelines

We value your participation in this open source project. This page will give you a quick overview of how to get involved.

You can contribute to the project in any or all of the following ways: 

- [Ask a question](https://github.com/foss42/api-dash/discussions)
- [Submit a bug report](https://github.com/foss42/api-dash/issues/new/choose)
- [Request a new feature](https://github.com/foss42/api-dash/issues/new/choose)
- [Suggest ways to improve the developer experience of an existing feature](https://github.com/foss42/api-dash/issues/new/choose)
- [Add documentation](https://github.com/foss42/api-dash/issues/new/choose)
- To add a new feature, resolve an existing issue or add a new test to the project, check out the guidelines below.

### I have not contributed to any open source project before. Will I get any guidance?

In case you are new to the open source ecosystem, we would be more than happy to guide you through the entire process. Just join our [Discord server](https://bit.ly/heyfoss) and drop a message in the **#foss** channel.

## Code Contribution Guidelines

### Some things to keep in mind before opening a PR

We currently do not accept PRs that involve:
- Code refactoring without any new feature addition/existing issue resolution.
- Bumping of dependency versions (SDKs, Packages).

### Resolving an existing issue / Adding a requested feature

You can find all existing issues [here](https://github.com/foss42/api-dash/issues).

A good place to start is to take a look at ["good first issues"](https://github.com/foss42/api-dash/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22). 

**Step 1** - Once you have identified the issue you want to work on, comment on it so that we can discuss how to approach and solve the problem.  
**Step 2** - Fork the `foss42/api-dash` repo and create a new branch in your fork (name it `add-feature-xyz` or `resolve-issue-xyz`).  
**Step 3** - Run API Dash locally (More details below). Make code changes in the branch.  
**Step 4** - Once code changes have been made. Make sure you add the relevant tests in the `test` folder. (More details on testing below)  
**Step 5** - [Open a Pull Request](https://help.github.com/articles/using-pull-requests/) with a clear title and description and add a reference to the issue.  
**Step 6** - Wait for feedback and review. We would closely work with you on the Pull Request.

### Adding a new feature

**Step 1** - Open an [issue](https://github.com/foss42/api-dash/issues/new/choose) so that we can discuss on the new feature that you want to add.  
**Step 2** - Fork the `foss42/api-dash` repo and create a new branch in your fork (name it `add-feature-xyz`).  
**Step 3** - Run API Dash locally (More details below). Make code changes in the branch.  
**Step 4** - Once the feature is implemented. Make sure you add the relevant tests in the `test` folder. (More details on testing below)  
**Step 5** - [Open a Pull Request](https://help.github.com/articles/using-pull-requests/) with a clear title and description and add a reference to the issue.  
**Step 6** - Wait for feedback and review. We would closely work with you on the Pull Request.

### Adding a new test

You can contribute by adding missing tests for:
- Widgets (`lib/widgets/`)
- Models (`lib/models/`)
- Utilities (`lib/utils/`)
- Riverpod providers (`lib/providers/`)
- Code generation (`lib/codegen/`) 
- Services (`lib/services/`).

**Step 1** - Once you have identified the test you want to add or improve, fork the `foss42/api-dash` repo and create a new branch in your fork (name it `add-test-xyz`).  
**Step 2** - Add the test to an existing test file or create a new test file in the `test` folder.  
**Step 3** - Run the tests locally (More details below).   
**Step 5** - [Open a Pull Request](https://help.github.com/articles/using-pull-requests/) with a clear title and description.  
**Step 6** - Wait for feedback and review. We would closely work with you on the Pull Request.

## General Instructions 

### How to run API Dash locally?

1. Fork the project.
2. Create a local clone of the forked project to run it locally.
3. Based on your desktop environment, enable Windows, macOS or Linux for the project. Select the same target device.
4. This project uses [Records feature in Dart](https://github.com/dart-lang/language/blob/main/accepted/future-releases/records/records-feature-specification.md), so to run the project you need to execute the following command:

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

Note: On macOS you need to have lcov installed on your system (`brew install lcov`) to run the above command.

Execute 

```
open coverage/html/index.html
```

to view the coverage report in the browser for further analysis.
