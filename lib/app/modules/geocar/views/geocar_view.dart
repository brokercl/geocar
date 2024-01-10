import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                          controller.categoryMovilList.length, (index) {
                        var category = controller.categoryMovilList[index][0]
                            as CategoryMovil;
                        var icon =
                            controller.categoryMovilList[index][1] as IconData;
                        var label =
                            controller.categoryMovilList[index][2] as String;

                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              controller.selectedMovilCategory.value = category;
                              controller.generateRandomColor();
                            },
                            child: Obx(
                              () => Container(
                                color: controller.selectedMovilCategory.value ==
                                        category
                                    ? controller.randomColor.value
                                    : Colors.grey,
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      icon,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      label,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(
                      height: 30,
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
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
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
                              if (controller.validarFormatoPlacaPatente(
                                  newPatente)) Get.focusScope!.unfocus();
                              controller.patenteController.value.text =
                                  newPatente;
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
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomNavBar()));
  }
}

class CustomInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow only letters for first 2 positions
    if (newValue.text.isNotEmpty &&
        !RegExp(r'[a-zA-Z]').hasMatch(newValue.text[0])) {
      return oldValue;
    }

    if (newValue.text.length >= 2 &&
        !RegExp(r'[a-zA-Z]').hasMatch(newValue.text[1])) {
      return TextEditingValue(
        text: newValue.text.substring(0, 1),
        selection: const TextSelection.collapsed(offset: 1),
      );
    }

    // Allow letters and numbers for position 3 to 4
    if (newValue.text.length >= 3 &&
        !RegExp(r'[a-zA-Z0-9]').hasMatch(newValue.text[2])) {
      return TextEditingValue(
        text: newValue.text.substring(0, 2),
        selection: const TextSelection.collapsed(offset: 2),
      );
    }

    if (newValue.text.length >= 4 &&
        !RegExp(r'[a-zA-Z0-9]').hasMatch(newValue.text[3])) {
      return TextEditingValue(
        text: newValue.text.substring(0, 3),
        selection: const TextSelection.collapsed(offset: 3),
      );
    }

    // Allow only numbers for position 5 to 6
    if (newValue.text.length >= 5 &&
        !RegExp(r'[0-9]').hasMatch(newValue.text[4])) {
      return TextEditingValue(
        text: newValue.text.substring(0, 4),
        selection: const TextSelection.collapsed(offset: 4),
      );
    }

    if (newValue.text.length >= 6 &&
        !RegExp(r'[0-9]').hasMatch(newValue.text[5])) {
      return TextEditingValue(
        text: newValue.text.substring(0, 5),
        selection: const TextSelection.collapsed(offset: 5),
      );
    }

    return newValue;
  }
}
