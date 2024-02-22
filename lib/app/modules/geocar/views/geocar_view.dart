import 'package:flutter/material.dart';
import 'package:geocar/app/modules/geocar/controllers/geocar_controller.dart';
import 'package:geocar/bottom_nav_bar.dart';
import 'package:geocar/utils/utils.dart';

import 'package:get/get.dart';

class GeoCarView extends GetView<GeoCarController> {
  GeoCarView({super.key});
  final _inputFormatter = CustomInputFormatter();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: appBar('Geo Car View'),
      body: Center(
        child: Obx(
          () => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  controller.categoryMovilList.length,
                  (i) {
                    var category =
                        controller.categoryMovilList[i][0] as CategoryMovil;
                    // var label =
                    //     controller.categoryMovilList[i][2] as String;
                    return Expanded(
                      child: Obx(
                        () => IconButton(
                          icon: controller.categoryMovilList[i][1][0].value
                              ? Image.asset(
                                  controller.categoryMovilList[i][1][1])
                              : Image.asset(
                                  controller.categoryMovilList[i][1][2]),
                          onPressed: () {
                            //cambio la ultima categoria de movil seleccionada a false
                            controller
                                .categoryMovilList[
                                    controller.lastMovilSelected.value][1][0]
                                .value = false;
                            // actualizo ultima categoria a la selecionada por usuario
                            controller.lastMovilSelected.value = i;
                            //cambio categoria de movil seleccionada por usuario a true
                            controller.categoryMovilList[i][1][0].value = true;
                            controller.selectedMovilCategory.value = category;
                          },
                          iconSize: 60,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Formatos Patente',
                    style: titleGeoCarTextStyle,
                  ),
                  Text(
                    'AA1234',
                    style: subTitleGeoCarTextStyle,
                  ),
                  Text(
                    'AAAA12',
                    style: subTitleGeoCarTextStyle,
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200, // adjust width as needed
                      height: 100, // adjust height as needed
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ), // adjust corner radius as needed
                      child: TextField(
                        controller: controller.patenteController.value,
                        maxLength: 6,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [_inputFormatter],
                        decoration: InputDecoration(
                            labelText: 'Ingresa tu Patente',
                            labelStyle: subTitleGeoCarTextStyle),
                        onChanged: (newPatente) {
                          // close keyboard after check patente format
                          if (controller
                              .validarFormatoPlacaPatente(newPatente)) {
                            Get.focusScope!.unfocus();
                          }
                          controller.patenteController.value.text = newPatente;
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        controller
                            .getIconData(), // Call the function to get IconData based on the condition
                        color: controller.isPatenteFormatOk.value
                            ? Colors.green
                            : Colors.red,
                        size: 48.0,
                      ),
                    ),
                  ],
                ),
              ),
              BottomNavBar()
            ],
          ),
        ),
      ),
    ));
  }
}
