export 'dashboard.dart';
import 'package:apidash/screens/mobile/onboarding/onboarding.dart';
import 'package:apidash/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';


///-- Use this to setup themes, initial Bindings, any animations and much
class MApp extends StatelessWidget {
  const MApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      themeMode: ThemeMode.system,
      theme:TAppTheme.lightTheme ,
      darkTheme: TAppTheme.darkTheme,
      home: const OnBoardingScreen(),
    );
  }
}