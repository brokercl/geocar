import 'package:flutter/material.dart';
import 'package:geocar/app/data/movil/movil.dart';
import 'package:geocar/app/data/points/point.dart';
import 'package:geocar/app/data/users/user.dart';

import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "GeoCar",
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    ),
  );
  openIsarDB();
}

Future<Isar> openIsarDB() async {
  final dir = await getApplicationDocumentsDirectory();
  if (Isar.instanceNames.isEmpty) {
    return await Isar.open(
      [
        UserSchema,
        MovilSchema,
        PointSchema,
      ],
      inspector: true,
      directory: dir.path,
    );
  }
  return Future.value(Isar.getInstance());
}
