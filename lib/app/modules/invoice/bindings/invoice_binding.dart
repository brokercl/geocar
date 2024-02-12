import 'package:geocar/app/modules/locate/controllers/locate_controller.dart';
import 'package:get/get.dart';

import '../controllers/invoice_controller.dart';

class InvoiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvoiceController>(
      () => InvoiceController(),
    );

    Get.lazyPut<LocateController>(
      () => LocateController(),
    );
  }
}
