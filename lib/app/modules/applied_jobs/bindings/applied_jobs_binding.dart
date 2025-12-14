import 'package:get/get.dart';

import '../controllers/applied_jobs_controller.dart';

class AppliedJobsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppliedJobsController>(
      () => AppliedJobsController(),
    );
  }
}