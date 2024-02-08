import 'package:flutter/material.dart';
import 'package:geocar/app/modules/geocar/controllers/geocar_controller.dart';
import 'package:geocar/utils/utils.dart';
import 'package:get/get.dart';

import 'bottom_nav_controller.dart';

class BottomNavBar extends StatelessWidget {
  final bottomNavController = Get.put(BottomNavController());
  final geoCarController = Get.find<GeoCarController>();
  final List<IconData> icons = [
    Icons.bike_scooter,
    Icons.location_on,
    Icons.inventory_outlined,
    Icons.balance,
  ];

  BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return BottomNavigationBar(
        items: List.generate(
          icons.length,
          (index) => BottomNavigationBarItem(
            icon: Icon(icons[index],
                color: bottomNavController.selectedView.value == index
                    ? geoCarController.isPatenteFormatOk.value
                        ? selected
                        : unSelected
                    : unSelected),
            label: '',
          ),
        ),
        currentIndex: bottomNavController.selectedView.value,
        onTap: (index) {
          bottomNavController.changeView(index);
          // Implement navigation or other actions based on the selected index.
        },
      );
    });
  }
}
