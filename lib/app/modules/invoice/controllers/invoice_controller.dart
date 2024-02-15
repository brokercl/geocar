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
    if (startDate.year == endDate.year &&
        startDate.month == endDate.month &&
        startDate.day == endDate.day) {
      print('startDate and endDate son iguales');
      print('startDate $startDate, endDate $endDate');
      // If start and end dates are the same, fetch points only for that specific date
      points.value =
          await isar.points.where().filter().dateEqualTo(startDate).findAll();
    } else {
      print('startDate and endDate no son iguales');
      print('startDate $startDate, endDate $endDate');
      points.value = await isar.points
          .where()
          .filter()
          .dateBetween(startDate, endDate,
              includeLower: true, includeUpper: true)
          .findAll();
    }

    // Calculate the sum of tariffs
    sumTariff.value =
        points.fold<double>(0, (prev, curr) => prev + curr.tariff);

    print('points.length ${points.length}');

    return points;
  }
}
