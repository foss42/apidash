import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SendingWidget extends StatelessWidget {
  const SendingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset("assets/sending.json"),
        ],
      ),
    );
  }
}
