import 'package:flutter/material.dart';

class LogoApidash extends StatelessWidget {
  const LogoApidash({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: 0.1, 
        child: const FlutterLogo(
          size: 400, 
        ),
        // TODO: Replace FlutterLogo with apidash_logo 
        // child: Image.asset(
        //   'assets/apidash_logo.png', 
        //   width: X,
        //   height: X,
        // ),
        // OR use SVG:
        // child: SvgPicture.asset(
        //   'assets/apidash_logo.svg', 
        //   width: X,
        //   height: X,
        // ),
      ),
    );
  }
}