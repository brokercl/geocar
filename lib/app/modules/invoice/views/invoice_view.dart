import 'package:flutter/material.dart';
import 'package:geocar/bottom_nav_bar.dart';
import 'package:get/get.dart';

import '../controllers/invoice_controller.dart';

class InvoiceView extends GetView<InvoiceController> {
  const InvoiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice View'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                controller.findStudents();
              },
              child: const Text('Fetch Points'),
            ),
            Obx(() {
              if (controller.points.isEmpty) {
                return const Text('No points found');
              } else {
                return Column(
                  children: controller.points.map((point) {
                    return ListTile(
                      leading: Text(point.point.toString()),
                      title: Text(point.date
                          .toString()), // Assuming Point has a property 'title'
                      subtitle: Text(point.tariff
                          .toString()), // Assuming Point has a property 'description'
                    );
                  }).toList(),
                );
              }
            }),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
