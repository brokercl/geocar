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
      appBar: AppBar(
        title: const Text('Invoice'),
      ),
      body: Column(
        children: [
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
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
                  onPressed: () async {
                    selectDate(context, controller.endDate, DateTime(2024, 1),
                        DateTime.now());
                    if (controller.endDate.value
                        .isBefore(controller.startDate.value)) {
                      controller.endDate.value = controller.startDate.value;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 77, 38, 155), // Change the color here
                  ),
                  child: Text(
                      'End Date \n${DateFormat('dd-MM-yyyy').format(controller.endDate.value)}'),
                ),
                ElevatedButton(
                    onPressed: () {
                      controller.isFilterList.value = true;
                      // Call method to fetch points based on input dates
                      controller.findStartEndDatesPoints(
                          controller.startDate.value, controller.endDate.value);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.isFilterList.value
                          ? const Color.fromARGB(255, 173, 20, 20)
                          : const Color.fromARGB(
                              60, 173, 20, 20), // Change the color here
                    ),
                    child: const Text('Filter \nPoints')),
                ElevatedButton(
                  onPressed: () {
                    controller.isFilterList.value = false;
                    // Call method to fetch all points
                    controller.findAllPoints();
                    // Change the color here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.isFilterList.value
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
          Obx(() => Text('total: ${controller.sumTariff.value}')),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
