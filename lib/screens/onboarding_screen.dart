import 'package:apidash/consts.dart';
import 'package:apidash/utils/onboarding_utils.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:apidash/widgets/button_onboarding_skip.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  
  @override
  Widget build(BuildContext context) {
    final pages =  [
        buildPageViewModel(
        asset: 'assets/lottie1.json',
        title: 'Welcome!',
        body: 'Have the Best Experience on Working with APIs',
        animationType: AnimationType.fadeIn,
        ),
        buildPageViewModel(
        asset: 'assets/lottie2.json',
        title: 'Organize your work!',
        body: '   API Dash efficiently stores history.\nEnhancing seamless task management.',
        animationType: AnimationType.scale,
        ), 
        buildPageViewModel(
        asset: 'assets/lottie3.json',
        title: 'Seamless and fast',
        body: 'API Dash is built to be lightweight.',
        ),
        buildPageViewModel(
        asset: 'assets/lottie4.json',
        title: 'Get Started with API Dash',
        body: 'Start Using Now!',
        animationType: AnimationType.bounce,
      ),
      ];
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            IntroductionScreen(
              pages: pages,
              onDone: () => onCompleted(context),
              next: const Icon(Icons.arrow_forward, size: 24,color: Colors.blueAccent,),
              done: const Text(
                'Start',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.blue),
              ),
              showBackButton: true, 
              dotsDecorator:DotsDecorator(
                size: const Size(10.0, 8.0),
                activeSize: const Size(30.0, 8.0),
                color: Colors.grey.shade400,
                activeColor: Colors.blueAccent,
                spacing: const EdgeInsets.symmetric(horizontal: 4),
                activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                ),
              ) ,
              
              back: const Icon(Icons.arrow_back, size: 24,color: Colors.blue,),
            ),
            skipButton(context)
          ],
        ),
      ),
    );
  }
}

