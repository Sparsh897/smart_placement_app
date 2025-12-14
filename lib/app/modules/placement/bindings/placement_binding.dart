import 'package:get/get.dart';

import '../controllers/placement_controller.dart';

class PlacementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlacementController>(PlacementController.new, fenix: true);
  }
}
