import 'package:geocar/app/modules/geocar/controllers/geocar_controller.dart';
import 'package:geocar/app/routes/app_pages.dart';
import 'package:get/get.dart';

class BottomNavController extends GetxController {
  var geoCarController = Get.find<GeoCarController>();
  RxInt selectedView = 0.obs;
  void changeView(int view) {
    switch (view) {
      case 0:
        Get.toNamed(Routes.geocar);
        break;
      case 1:
        if (geoCarController.isPatenteFormatOk.value) {
          Get.toNamed(Routes.locate);
        } else {
          Get.snackbar('Patente No Ingresada', 'por favor ingrese su patente..',
              snackPosition: SnackPosition.BOTTOM);
        }
      case 2:
        if (geoCarController.isPatenteFormatOk.value) {
          Get.toNamed(Routes.invoice);
        } else {
          Get.snackbar('Patente No Ingresada', 'por favor ingrese su patente..',
              snackPosition: SnackPosition.BOTTOM);
        }

      case 3:
        if (geoCarController.isPatenteFormatOk.value) {
          Get.toNamed(Routes.lawyer);
        } else {
          Get.snackbar('Patente No Ingresada', 'por favor ingrese su patente..',
              snackPosition: SnackPosition.BOTTOM);
        }
    }
    selectedView.value = view;
  }
}
