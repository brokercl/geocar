import 'package:flutter/material.dart';
import 'package:geocar/app/modules/invoice/controllers/invoice_controller.dart';
import 'package:geocar/app/modules/locate/controllers/locate_controller.dart';
import 'package:geocar/bottom_nav_bar.dart';
import 'package:geocar/utils/utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Assuming you're using GetX for state management

class InvoiceView extends GetView<InvoiceController> {
  InvoiceView({super.key});
  final locateController = Get.find<LocateController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Invoice View'),
      body: Column(
        children: [
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onLongPress: () {
                    // Disable copy-paste functionality
                  },
                  onPressed: () async => selectDate(context,
                      controller.startDate, DateTime(2024, 1), DateTime.now()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 152, 32, 32), // Change the color here
                  ),
                  child: Text(
                      'Start Date \n${DateFormat('dd-MM-yyyy').format(controller.startDate.value)}'),
                ),
                ElevatedButton(
                  onLongPress: () {
                    // Disable copy-paste functionality
                  },
                  onPressed: () async {
                    selectDate(context, controller.endDate, DateTime(2024, 1),
                        DateTime.now());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 77, 38, 155), // Change the color here
                  ),
                  child: Text(
                      'End Date \n${DateFormat('dd-MM-yyyy').format(controller.endDate.value)}'),
                ),
                ElevatedButton(
                    onLongPress: () {
                      // Disable copy-paste functionality
                    },
                    onPressed: () {
                      print(
                          'controller.startDate ${controller.startDate} controller.endDate ${controller.endDate}');
                      if (DateTime(
                              controller.endDate.value.year,
                              controller.endDate.value.month,
                              controller.endDate.value.day,
                              0,
                              0,
                              0,
                              0,
                              0)
                          .isBefore(DateTime(
                              controller.startDate.value.year,
                              controller.startDate.value.month,
                              controller.startDate.value.day,
                              0,
                              0,
                              0,
                              0,
                              0))) {
                        Get.snackbar('Fecha final debe ser >= a fecha inicial',
                            'por favor corrija..',
                            snackPosition: SnackPosition.BOTTOM);
                        controller.isFilterList.value = false;
                      } else {
                        controller.isFilterList.value = true;
                      }
                      // Call method to fetch points based on input dates
                      controller.findStartEndDatesPoints(
                          controller.startDate.value, controller.endDate.value);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.points.isEmpty
                          ? const Color.fromARGB(60, 173, 20, 20)
                          : controller.isFilterList.value
                              ? const Color.fromARGB(255, 173, 20, 20)
                              : const Color.fromARGB(
                                  60, 173, 20, 20), // Change the color here
                    ),
                    child: const Text('Filter \nPoints')),
                ElevatedButton(
                  onLongPress: () {
                    // Disable copy-paste functionality
                  },
                  onPressed: () {
                    controller.isFilterList.value = false;
                    // Call method to fetch all points
                    controller.findAllPoints();
                    // Change the color here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.points.isEmpty
                        ? const Color.fromARGB(60, 26, 147, 15)
                        : controller.isFilterList.value
                            ? const Color.fromARGB(60, 26, 147, 15)
                            : const Color.fromARGB(
                                255, 26, 147, 15), // Change the color here
                  ),
                  child: const Text('All \nPoints'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () {
                if (controller.points.isEmpty) {
                  return const Text('points is Empty');
                } else {
                  return ListView.builder(
                    itemCount: controller.points.length,
                    itemBuilder: (context, index) {
                      final point = controller.points[index];
                      return ListTile(
                        // title: Text('Point: ${point.point}'),
                        title: Text(
                            'Concesionaria: ${locateController.redConsecionesTagChile[point.point][0][0]} \nPortico: ${locateController.redConsecionesTagChile[point.point][0][1]} - ${locateController.redConsecionesTagChile[point.point][0][2]}'),
                        subtitle: Text(
                          'Date: ${point.date}',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 45, 113, 34)),
                        ),
                        trailing: Text(
                          'Tariff: ${point.tariff}',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 190, 41, 30)),
                        ),
                        // Display other relevant point information
                      );
                    },
                  );
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {},
                child: Image.asset('assets/images/pdf_down.png'),
              ),
              Obx(
                () => Text(
                  '\$ ${formatCurrency(controller.sumTariff.value)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: Colors.red),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Image.asset('assets/images/excel_down.png'),
              ),
              InkWell(
                onTap: () {},
                child: Image.asset('assets/images/abogado.png'),
              ),
            ],
          ),
          BottomNavBar(),
        ],
      ),
    );
  }
}
