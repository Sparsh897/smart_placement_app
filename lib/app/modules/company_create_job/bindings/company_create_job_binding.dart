import 'package:get/get.dart';
import '../controllers/company_create_job_controller.dart';

class CompanyCreateJobBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompanyCreateJobController>(
      () => CompanyCreateJobController(),
    );
  }
}