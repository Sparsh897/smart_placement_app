import 'package:get/get.dart';

class UserTypeSelectionController extends GetxController {
  final selectedUserType = ''.obs;

  void selectUserType(String type) {
    selectedUserType.value = type;
  }

  void navigateToAuth() {
    if (selectedUserType.value.isEmpty) {
      Get.snackbar(
        'Selection Required',
        'Please select whether you are a User or Company',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return;
    }

    if (selectedUserType.value == 'user') {
      Get.toNamed('/auth');
    } else if (selectedUserType.value == 'company') {
      Get.toNamed('/company-auth');
    }
  }
}