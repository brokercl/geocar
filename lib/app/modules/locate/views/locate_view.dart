import 'package:flutter/material.dart';
import 'package:geocar/app/modules/geocar/controllers/geocar_controller.dart';
import 'package:geocar/bottom_nav_bar.dart';
import 'package:geocar/utils/utils.dart';

import 'package:get/get.dart';

import '../controllers/locate_controller.dart';

class LocateView extends GetView<LocateController> {
  const LocateView({super.key});
  @override
  Widget build(BuildContext context) {
    var geoCarController = Get.find<GeoCarController>();
    return SafeArea(
      child: Obx(
        () => Scaffold(
          appBar: appBar('Locate View'),
          body: Center(
            // child: Container(
            //   decoration: const BoxDecoration(
            //       image: DecorationImage(
            //           image: AssetImage(
            //               'assets/images/autopista.png'))), // cargar imagen de fondo
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromARGB(184, 120, 162, 234),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Current Date: ${controller.getFormattedDate()}',
                        style: TextStyle(fontSize: locateViewfontZise),
                      ),
                      Text(
                        'Current Time: ${controller.getFormattedTime()}',
                        style: TextStyle(fontSize: locateViewfontZise),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromARGB(184, 182, 104, 230),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            geoCarController.categoryMovilList[geoCarController
                                .selectedMovilCategory.value.index][1][1],
                            width: 60,
                          ),
                          Text(
                            ' ${geoCarController.categoryMovilList[geoCarController.selectedMovilCategory.value.index][2]}',
                            style: TextStyle(fontSize: locateViewfontZise),
                          ),
                        ],
                      ),
                      Text(
                        'patente: ${geoCarController.patenteController.value.text}',
                        style: TextStyle(fontSize: locateViewfontZise),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Transform.rotate(
                            angle: controller.heading.value,
                            child: const Icon(
                              Icons.arrow_forward,
                              size: 50.0,
                            ),
                          ),
                          Text('heading: ${controller.heading.value}'),
                        ],
                      ),
                      Text('direction: ${controller.direction.value}'),
                      const SizedBox(height: 10),
                      Text(
                        'Direction: ${controller.bearing.value}',
                        style: TextStyle(fontSize: locateViewfontZise),
                      ),
                      Text(
                        'LAT: ${controller.lat.value}',
                        style: TextStyle(fontSize: locateViewfontZise),
                      ),
                      Text(
                        'LONG: ${controller.long.value}',
                        style: TextStyle(fontSize: locateViewfontZise),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color.fromARGB(162, 255, 214, 64),
                    ),
                    child: controller.porticoMatch.value ==
                            -1 // porticoMatch es inicializado -1 indicando no portico
                        ? const Text('Buscando Portico')
                        : Column(
                            children: [
                              Text(controller.redConsecionesTagChile[
                                      controller.porticoMatch.value][0][0]
                                  .toString()), // nombre concesion

                              Text(
                                  controller.redConsecionesTagChile[
                                          controller.porticoMatch.value][0][1] +
                                      ' ' +
                                      controller.redConsecionesTagChile[
                                          controller.porticoMatch.value][0][2],
                                  style:
                                      trueSubTitleLocateTextStyle), // codigo + nombre portico
                              Text(
                                '${controller.redConsecionesTagChile[controller.porticoMatch.value][2]}',
                              ), // latitud longitud del portico
                              // en posicion 8, comienzan las tarifas
                              Text(
                                'tarifa: ${controller.tariff.value}',
                                style: TextStyle(
                                    color: controller.isHoraSaturada.value
                                        ? horaSaturada
                                        : controller.isHoraPunta.value
                                            ? horaPunta
                                            : horaBaja),
                              ),
                              Visibility(
                                visible: controller.isHoraSaturada.value,
                                child: Text(
                                    'hora saturada: ${controller.inicioHoraSaturada.hour}:${controller.inicioHoraSaturada.minute == 0 ? '00' : '${controller.inicioHoraSaturada.minute}'} - ${controller.finHoraSaturada.hour}:${controller.finHoraSaturada.minute == 0 ? '00' : '${controller.finHoraSaturada.minute}'}',
                                    style: TextStyle(color: horaSaturada)),
                              ),
                              Visibility(
                                visible: controller.isHoraPunta.value,
                                child: Text(
                                    'hora punta: ${controller.inicioHoraPunta.hour}:${controller.inicioHoraPunta.minute == 0 ? '00' : '${controller.inicioHoraPunta.minute}'} - ${controller.finHoraPunta.hour}:${controller.finHoraPunta.minute == 0 ? '00' : '${controller.finHoraPunta.minute}'}',
                                    style: TextStyle(color: horaPunta)),
                              ),
                              Visibility(
                                visible: !(controller.isHoraSaturada.value ||
                                    controller.isHoraPunta.value),
                                child: Text('hora baja:',
                                    style: TextStyle(color: horaBaja)),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavBar(),
        ),
      ),
    );
  }
}
