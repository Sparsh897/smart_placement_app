import 'package:get/get.dart';
import '../controllers/company_dashboard_controller.dart';
import '../../company_auth/controllers/company_auth_controller.dart';

class CompanyDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompanyDashboardController>(
      () => CompanyDashboardController(),
    );
    
    // Use Get.find to get existing CompanyAuthController or create if not exists
    // This prevents re-initialization
    try {
      Get.find<CompanyAuthController>();
    } catch (e) {
      // Controller doesn't exist, create it
      Get.put<CompanyAuthController>(CompanyAuthController(), permanent: true);
    }
  }
}