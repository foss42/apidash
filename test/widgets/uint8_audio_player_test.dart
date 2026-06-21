import 'dart:typed_data';
import 'package:apidash/widgets/uint8_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Testing Uint8AudioPlayer renders CircularProgressIndicator initially', (tester) async {
    bool errorBuilderCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Uint8AudioPlayer(
            bytes: Uint8List(0),
            type: 'audio',
            subtype: 'mpeg',
            errorBuilder: (context, error, stackTrace) {
              errorBuilderCalled = true;
              return const Text('Audio Error');
            },
          ),
        ),
      ),
    );

    // Initial state: Waiting for stream
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Pump to let the async stream emit state
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    // Since just_audio fails to initialize on tests (no method channel), 
    // it will either stay loading or throw an error.
    // If errorBuilder was called, it should display 'Audio Error'.
    if (errorBuilderCalled) {
      expect(find.text('Audio Error'), findsOneWidget);
    }
  });
}
