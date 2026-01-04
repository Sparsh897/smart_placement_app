import 'package:get/get.dart';
import '../controllers/company_applications_controller.dart';

class CompanyApplicationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompanyApplicationsController>(
      () => CompanyApplicationsController(),
    );
  }
}