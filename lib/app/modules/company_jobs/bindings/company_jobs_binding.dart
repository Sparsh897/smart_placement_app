import 'package:get/get.dart';
import '../controllers/company_jobs_controller.dart';

class CompanyJobsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompanyJobsController>(
      () => CompanyJobsController(),
    );
  }
}