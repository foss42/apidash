import 'package:apidash/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
Widget skipButton(BuildContext context) {
  return Positioned(
    top: 30,
    right: 20,
    child: TextButton(
      onPressed: ()  {
        onCompleted(context);
      },
      child: const Text(
        'Skip',
        style: TextStyle(
          fontSize: 15,
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
