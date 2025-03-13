import 'package:apidash/app.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/services/shared_preferences_services.dart';
import 'package:apidash/utils/onboarding_utils.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:apidash/widgets/button_onboarding_skip.dart';

class CheckOnboardingStatus extends StatelessWidget {
  const CheckOnboardingStatus({super.key});

   @override
Widget build(BuildContext context) {
  return MaterialApp(
    home: FutureBuilder<bool>(
      future: getOnboardingStatus(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    
        return snapshot.data! ? const DashApp() : const OnboardingScreen();
      },
    ),
  );
}
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
 List<PageViewModel> pages() {
    return [
      buildPageViewModel(
        asset: 'assets/lottie1.json',
        title: 'Welcome!',
        body: 'Have the Best Experience on Working with APIs',
        animationType: AnimationType.fadeIn,
      ),
      buildPageViewModel(
        asset: 'assets/lottie2.json',
        title: 'Organize your work!',
        body: 'API Dash efficiently stores history\nEnhancing seamless task management.',
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
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white10,
      body: Stack(
        children: [
          IntroductionScreen(
            pages: pages(),
            onDone: () => onCompleted(context),
            next: const Icon(Icons.arrow_forward, size: 24,color: Colors.blueAccent,),
            done: const Text(
              'Start',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.blue),
            ),
            showBackButton: true, 
             dotsDecorator: DotsDecorator(
              size: const Size(10.0, 8.0),
              activeSize: const Size(30.0, 8.0),
              color: Colors.grey.shade400,
              activeColor: Colors.blueAccent,
              spacing: const EdgeInsets.symmetric(horizontal: 4),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            
            back: const Icon(Icons.arrow_back, size: 24,color: Colors.blue,),
          ),
          skipButton(context)
        ],
      ),
    );
  }
}
void onCompleted(BuildContext context)async {
     await setOnboardingStatus();
  Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      transitionDuration: const Duration(seconds: 2), 
      pageBuilder: (context, animation, secondaryAnimation) => const DashApp(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); 
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    ),
  );


}
