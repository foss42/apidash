import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_field_editor/src/json_highlight/json_highlight.dart';

void main() {
  group('JsonHighlight', () {
    test(
      'build method should create TextSpan with correct number of children',
      () {
        // Arrange
        var jsonHighlight = JsonHighlight(isFormating: true);
        var data =
            '{"key": "value", "number": 123, "bool": true, "null": null}';

        // Act
        TextSpan result = jsonHighlight.build(data);

        // Assert
        expect(
          result.children!.length,
          23,
        ); // adjust this based on your expected result
      },
    );
  });
}
