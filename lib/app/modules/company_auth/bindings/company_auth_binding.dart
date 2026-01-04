import 'package:get/get.dart';
import '../controllers/company_auth_controller.dart';

class CompanyAuthBinding extends Bindings {
  @override
  void dependencies() {
    // Use permanent controller to prevent re-initialization
    if (!Get.isRegistered<CompanyAuthController>()) {
      Get.put<CompanyAuthController>(
        CompanyAuthController(),
        permanent: true,
      );
    }
  }
}