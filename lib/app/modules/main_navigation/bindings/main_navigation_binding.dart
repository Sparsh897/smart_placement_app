import 'package:get/get.dart';

import '../controllers/main_navigation_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../user/controllers/user_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../placement/controllers/placement_controller.dart';
import '../../applied_jobs/controllers/applied_jobs_controller.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavigationController>(
      () => MainNavigationController(),
    );
    
    // Initialize all required controllers for the main navigation
    Get.lazyPut<PlacementController>(
      () => PlacementController(),
    );
    
    Get.lazyPut<AuthController>(
      () => AuthController(),
    );
    
    Get.lazyPut<UserController>(
      () => UserController(),
    );
    
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    
    Get.lazyPut<AppliedJobsController>(
      () => AppliedJobsController(),
    );
  }
}