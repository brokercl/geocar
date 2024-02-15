import 'package:geocar/app/data/points/point.dart';
import 'package:geocar/main.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';

class InvoiceController extends GetxController {
  late Future<Isar> db;

  Rx<DateTime> startDate =
      DateTime.now().obs; // startDate 2024-02-13 09:56:28.478660
  Rx<DateTime> endDate =
      DateTime.now().obs; // endDate 2024-02-13 09:56:28.478548
  // ojo: los milisegundos hacen que startDate and endDate NO sean iguales
  RxDouble sumTariff = RxDouble(0);

  RxBool isFilterList = RxBool(false);

  InvoiceController() {
    db = openIsarDB();
  }
  RxList<Point> points = RxList<Point>([]);

  Future<RxList<Point>> findAllPoints() async {
    final isar = await db;

    points.value = await isar.points.where().findAll();

    sumTariff.value =
        points.fold<double>(0, (prev, curr) => prev + curr.tariff);

    return points;
  }

  Future<RxList<Point>> findStartEndDatesPoints(
      DateTime startDate, DateTime endDate) async {
    final isar = await db;

    points.value = await isar.points
        .where()
        .filter()
        .dateBetween(
            (DateTime(
                startDate.year, startDate.month, startDate.day, 0, 0, 0, 0, 0)),
            DateTime(
                endDate.year, endDate.month, endDate.day, 23, 59, 59, 999, 999),
            includeLower: true,
            includeUpper: true)
        .findAll();

    // Calculate the sum of tariffs
    sumTariff.value =
        points.fold<double>(0, (prev, curr) => prev + curr.tariff);

    print('points.length ${points.length}');

    return points;
  }
}
