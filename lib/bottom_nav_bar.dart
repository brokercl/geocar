import 'package:flutter/material.dart';
import 'package:geocar/app/modules/geocar/controllers/geocar_controller.dart';
import 'package:get/get.dart';

import 'bottom_nav_controller.dart';

class BottomNavBar extends StatelessWidget {
  final bottomNavController = Get.put(BottomNavController());
  final geoCarController = Get.find<GeoCarController>();

  BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(
        bottomNavController.icons.length,
        (i) => IconButton(
          icon: Image.asset(bottomNavController.stateIcons[i]
              ? bottomNavController.icons[i][0]
              : bottomNavController.icons[i][1]),
          onPressed: () {
            if (geoCarController.isPatenteFormatOk.value) {
              bottomNavController.stateIcons[bottomNavController.lastSelected] =
                  false;
              bottomNavController.stateIcons[i] = true;
              bottomNavController.lastSelected = i;
              bottomNavController.changeView(i);
            } else {
              if (i > 0) {
                Get.snackbar(
                    'Patente No Ingresada', 'por favor ingrese su patente..',
                    snackPosition: SnackPosition.BOTTOM);
              }
            }
          },
        ),
      ),
    );
  }
}
