import 'package:get/get.dart';

import '../controllers/locate_controller.dart';

class LocateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocateController>(
      () => LocateController(),
    );
  }
}
