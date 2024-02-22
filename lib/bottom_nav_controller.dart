import 'package:geocar/app/modules/geocar/controllers/geocar_controller.dart';
import 'package:geocar/app/routes/app_pages.dart';
import 'package:get/get.dart';

class BottomNavController extends GetxController {
  List icons = [
    ['assets/images/van_on.png', 'assets/images/van_off.png', 'van'],
    ['assets/images/gps_on.png', 'assets/images/gps_off.png', 'gps'],
    [
      'assets/images/calendario_on.png',
      'assets/images/calendario_off.png',
      'calendario'
    ],
  ];

// this list work togheter with icons list
  final stateIcons = [true, false, false];

  var lastSelected = 0;

  var geoCarController = Get.find<GeoCarController>();
  RxInt selectedView = 0.obs;

  void changeView(int view) {
    switch (view) {
      case 0:
        Get.toNamed(Routes.geocar);
        break;
      case 1:
        Get.toNamed(Routes.locate);
        break;
      case 2:
        Get.toNamed(Routes.invoice);
        break;
    }
    // selectedView.value = view;
  }
}
