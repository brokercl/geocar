import 'package:get/get.dart';

import '../controllers/geocar_controller.dart';

class GeoCarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GeoCarController>(
      () => GeoCarController(),
    );
  }
}
