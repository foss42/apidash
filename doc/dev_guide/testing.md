# How to run tests?

To run tests execute the following command:

```
flutter test --coverage
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

## Testing a single file

To run tests specified in a single file, execute the following command:

```
flutter test <file_path>.dart
```

Example:

```
flutter test test/widgets/codegen_previewer_test.dart
```
