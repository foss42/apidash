import 'package:apidash/app.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/services/shared_preferences_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

Widget _getAnimatedLottie(String asset, AnimationType animationType) {
    Widget lottieAnimation = Lottie.asset(asset, width: 250, height: 250);

    switch (animationType) {
      case AnimationType.fadeIn:
        return lottieAnimation.animate().fadeIn(duration: 800.ms);
      case AnimationType.scale:
        return lottieAnimation.animate().scale(duration: 800.ms);
     case AnimationType.bounce:
        return lottieAnimation.animate().moveY(begin: -100, end: 0, duration: 1000.ms).scaleXY(end: 1.1, duration: 700.ms).then().scaleXY(end: 1.0, duration: 600.ms);
      default:
        return lottieAnimation;
    }
  }
Widget _getAnimatedText(String text, {bool isTitle = false}) {
  TextStyle textStyle = TextStyle(
    fontSize: isTitle ? 24 : 16,
    fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
    color: isTitle ? Colors.black : Colors.black54,
  );

  return Text(text, style: textStyle).animate()
      .fadeIn(duration: (isTitle ? 1 : 1).seconds)
      .slideY(begin: isTitle ? -0.3 : 0.3, end: 0);
}

  PageViewModel buildPageViewModel({
    required String asset,
    required String title,
    required String body,
    AnimationType animationType = AnimationType.none,
  }) {
    return PageViewModel(
      titleWidget: _getAnimatedText(title, isTitle: true),
      bodyWidget: _getAnimatedText(body),
      image: Center(child: _getAnimatedLottie(asset, animationType)),
      decoration: const PageDecoration(
        pageColor: Colors.white,
        imagePadding: EdgeInsets.only(top: 40),
      ),
    );
  }
void onCompleted(BuildContext context) async {

  Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => const DashApp(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeInOut));
        
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ),
  );
    await setOnboardingStatus();
}
