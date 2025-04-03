import 'package:flutter/material.dart';

class DashbotUnknownPage extends StatelessWidget {
  const DashbotUnknownPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("You are not supposed to be here"),
        TextButton(
          onPressed: () {},
          child: Text("Report Now"),
        ),
      ],
    );
  }
}
