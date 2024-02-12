import 'package:geocar/app/data/points/point.dart';
import 'package:geocar/main.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';

class InvoiceController extends GetxController {
  late Future<Isar> db;

  Rx<DateTime> startDate = DateTime.now().obs;
  Rx<DateTime> endDate = DateTime.now().obs;
  RxInt sumTariff = RxInt(0);

  InvoiceController() {
    db = openIsarDB();
  }
  RxList<Point> points = RxList<Point>([]);

  Future<RxList<Point>> findAllPoints() async {
    final isar = await db;

    points.value = await isar.points.where().findAll();

    sumTariff.value =
        points.fold<double>(0, (prev, curr) => prev + curr.tariff).round();

    return points;
  }

  Future<RxList<Point>> findStartEndDatesPoints(
      DateTime startDate, DateTime endDate) async {
    final isar = await db;
    if (startDate == endDate) {
      print('startDate $startDate, endDate $endDate');
      // If start and end dates are the same, fetch points only for that specific date
      points.assignAll(
          await isar.points.where().filter().dateEqualTo(startDate).findAll());
    } else {
      print('startDate and endDate no son iguales');
      points.assignAll(await isar.points
          .where()
          .filter()
          .dateBetween(startDate, endDate)
          .findAll());
    }

    // Calculate the sum of tariffs
    sumTariff.value =
        points.fold<double>(0, (prev, curr) => prev + curr.tariff).round();

    return points;
  }
}
