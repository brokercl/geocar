import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocar/utils/utils.dart';
import 'package:get/get.dart';

class GeoCarController extends GetxController {
  Rx<CategoryMovil> selectedMovilCategory = CategoryMovil.c.obs;

  RxBool isPatenteFormatOk = RxBool(false);

  Rx<TextEditingController> patenteController = TextEditingController().obs;
  Rx<Color> randomColor = Rx<Color>(Colors.blue);
  void generateRandomColor() {
    // Generate a random color
    randomColor.value =
        Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  // Define a regular expression for AA1111 (patentes antiguas) y para AAAA11 (patentes nuevas)
  // primeras 2 posiciones solo letras, sgtes 2 posiciones letras y numeroa, ultimas 2 posiciones solo numeros
  RegExp allowedOldPatenteFormat1 = RegExp(r'^[a-zA-Z]{2}[a-zA-Z\d]{2}\d{2}$');

  List categoryMovilList = [
    [CategoryMovil.c, Icons.car_rental, 'moto auto camioneta'],
    [CategoryMovil.b, Icons.bus_alert, 'bus camion'],
    [CategoryMovil.r, Icons.fire_truck, 'bus camion con remolque'],
  ];

  // Function to validate the license plate format
  IconData getIconData() {
    // Replace this logic with your own conditions
    return isPatenteFormatOk.value ? Icons.check_circle : Icons.error;
  }

  bool validarFormatoPlacaPatente(String placaPatente) {
    isPatenteFormatOk.value = allowedOldPatenteFormat1.hasMatch(placaPatente);
    return isPatenteFormatOk.value;
  }
}
