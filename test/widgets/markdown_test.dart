import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/markdown.dart';

void main() {
  testWidgets('Testing CustomMarkdown', (tester) async {
    const markdown = CustomMarkdown(data: """Is a markdown ~`star on github`~ 
              
              #br
              #br

              ~`github repo`~ ~`Discord Server`~""");
    await tester.pumpWidget(markdown);
    //expectTextStrings(tester.allWidgets, <String>['Data1']);
  }, skip: true);
}
