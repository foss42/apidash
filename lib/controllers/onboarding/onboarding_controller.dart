
import 'package:apidash/screens/mobile/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// import '../../screens/login/login.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  /// Variable
  final pageController = PageController();
  // final currentPageIndex = 0.obs; alternate method below
  Rx<int> currentPageIndex = 0.obs;
/// Update Current Index when page Scroll
 void updatePageIndicator(index) => currentPageIndex.value = index;

/// Jump to the specific dot selected page.
void dotNavigationClick(index) {
  currentPageIndex.value = index;
  pageController.jumpTo(index);
}

/// Update Current Index & jump to next page
void nextPage() {
  if(currentPageIndex.value == 2){
    final storage = GetStorage();

    if(kDebugMode){
      print('===================== GET STORAGE ==============');
      print(storage.read('IsFirstTime'));
    }

    storage.write('IsFirstTime', false);

    if(kDebugMode){
      print('===================== GET STORAGE ==============');
      print(storage.read('IsFirstTime'));
    }

    Get.offAll(const MobileDashboard());
  } else{
    int page = currentPageIndex.value + 1;
    pageController.jumpToPage(page);
  }
}

/// Update current index & jump to the last Page
void skipPage() {
  currentPageIndex.value = 2;
  pageController.jumpTo(2);
}
}