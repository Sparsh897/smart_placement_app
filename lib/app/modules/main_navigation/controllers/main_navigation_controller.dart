import 'package:get/get.dart';

class MainNavigationController extends GetxController {
  var currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize with home tab
    currentIndex.value = 0;
  }
}