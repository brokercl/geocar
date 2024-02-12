import 'package:geocar/app/data/points/point.dart';
import 'package:geocar/main.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';

class InvoiceController extends GetxController {
  late Future<Isar> db;

  InvoiceController() {
    db = openIsarDB();
  }
  RxList<Point> points = RxList<Point>([]);

  Future<RxList<Point>> findStudents() async {
    final isar = await db;

    points.value = await isar.points.where().findAll();
    return points;
  }
}
