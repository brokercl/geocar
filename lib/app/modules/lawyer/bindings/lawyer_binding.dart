import 'package:get/get.dart';

import '../controllers/lawyer_controller.dart';

class LawyerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LawyerController>(
      () => LawyerController(),
    );
  }
}
