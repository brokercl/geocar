import 'package:flutter/material.dart';
import 'package:geocar/bottom_nav_bar.dart';

import 'package:get/get.dart';

import '../controllers/lawyer_controller.dart';

class LawyerView extends GetView<LawyerController> {
  const LawyerView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lawyer View'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text(
          'Send Invoice to Lawyer..',
          style: TextStyle(fontSize: 20),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
