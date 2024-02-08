import 'package:flutter/material.dart';
import 'package:geocar/utils/utils.dart';
import 'package:get/get.dart';

class GeoCarController extends GetxController {
  Rx<CategoryMovil> selectedMovilCategory = CategoryMovil.c.obs;

  RxBool isPatenteFormatOk = RxBool(false);
  RxInt lastMovilSelected =
      RxInt(0); // seleciono la categoria 'moto, auto o camioneta' por defecto

  Rx<TextEditingController> patenteController = TextEditingController().obs;
  Rx<Color> randomColor = Rx<Color>(Colors.blue);

  // Define a regular expression for AA1111 (patentes antiguas) y para AAAA11 (patentes nuevas)
  // primeras 2 posiciones solo letras, sgtes 2 posiciones letras y numeroa, ultimas 2 posiciones solo numeros
  RegExp allowedOldPatenteFormat1 = RegExp(r'^[a-zA-Z]{2}[a-zA-Z\d]{2}\d{2}$');

  List categoryMovilList = [
    [
      CategoryMovil.c,
      [false.obs, 'assets/images/van_on.png', 'assets/images/van_off.png'],
      'moto, auto o camioneta'
    ],
    [
      CategoryMovil.b,
      [
        false.obs,
        'assets/images/autobus_on.png',
        'assets/images/autobus_off.png'
      ],
      'bus, camion'
    ],
    [
      CategoryMovil.r,
      [
        false.obs,
        'assets/images/camion_acoplado_on.png',
        'assets/images/camion_acoplado_off.png'
      ],
      'bus articulado, camion con remolque'
    ],
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

  @override
  void onInit() {
    // cambio categoria 'moto, auto o camioneta' seleccionada por defecto a true
    categoryMovilList[lastMovilSelected.value][1][0].value = true;
    super.onInit();
  }
}
