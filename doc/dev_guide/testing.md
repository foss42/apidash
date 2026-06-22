# How to run tests?

As API Dash is a monorepo with multi-package architecture we use [melos](https://pub.dev/packages/melos). 

```
dart pub global activate melos
```

Bootstrap to initialize the workspace, link local packages together and install remaining package dependencies. 

```
melos bootstrap
```

Get all dependencies of packages

```
melos pub-get
```

Get all dependencies of main app

```
flutter pub get
```

To run tests with coverage across the entire workspace (all packages), execute:

```
melos test
```

### Generating a Unified HTML Coverage Report

Because API Dash is a monorepo, the `coverage/lcov.info` file at the root only contains the coverage data for the main application. To generate a unified HTML report that accurately reflects the test coverage for all the sub-packages, you need to merge their `lcov.info` files. 

You can use the provided `merge_coverage.sh` script to automate this process. It combines the coverage files and corrects the source file paths for the sub-packages.

Make the script executable (if it isn't already) and run it:

```bash
chmod +x merge_coverage.sh
./merge_coverage.sh
```

**Note**: On macOS you need to have `lcov` installed on your system (`brew install lcov`) for the script to use `genhtml`.

To view the unified coverage report in your browser for further analysis, execute: 

```
open coverage/html/index.html
```

## Testing a single file

To run tests specified in a single file, execute the following command:

```
flutter test <file_path>.dart
```

Example:

```
flutter test test/widgets/codegen_previewer_test.dart
```
