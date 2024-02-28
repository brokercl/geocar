import 'dart:io';

import 'package:excel/excel.dart';
import 'package:geocar/app/data/points/point.dart';
import 'package:geocar/app/modules/locate/controllers/locate_controller.dart';
import 'package:geocar/main.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path_provider/path_provider.dart';

class InvoiceController extends GetxController {
  late Future<Isar> db;
  final locateController = Get.find<LocateController>();

  Rx<DateTime> startDate =
      DateTime.now().obs; // startDate 2024-02-13 09:56:28.478660
  Rx<DateTime> endDate =
      DateTime.now().obs; // endDate 2024-02-13 09:56:28.478548
  // ojo: los milisegundos hacen que startDate and endDate NO sean iguales
  RxDouble sumTariff = RxDouble(0);

  RxBool isFilterList = RxBool(false);
  // Create Excel file
  final excel = Excel.createExcel();

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

  late Sheet sheet;
  final email = 'brokercl@gmail.com';
  final token = '';

  sendExcelByEmail(String nomExcelFile) async {
    final smtpServer = gmailSaslXoauth2(email, token);

    final message = Message()
      ..from = Address(email, 'Geocar')
      ..recipients = ['userEmail@emailServer']
      ..subject = 'points from Geocar'
      ..text = 'testing mailer pub dev';

    try {
      await send(message, smtpServer);
      Get.snackbar('email sent', 'successfully');
    } on MailerException catch (e) {
      Get.snackbar('error when trying to send email', 'Warning: $e',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 10));
    }

    sheet = excel[nomExcelFile];
    sheet.appendRow([
      const TextCellValue('Concesionaria'),
      const TextCellValue('Portico'),
      const TextCellValue('Date'),
      const TextCellValue('Tariff'),
    ]);

    // Add data rows
    for (final point in points) {
      final concesionaria =
          locateController.redConsecionesTagChile[point.point][0][0];
      final portico =
          '${locateController.redConsecionesTagChile[point.point][0][1]} - ${locateController.redConsecionesTagChile[point.point][0][2]}';
      final date = point.date;
      final tariff = point.tariff;
      sheet.appendRow([
        TextCellValue(concesionaria.toString()),
        TextCellValue(portico),
        TextCellValue(date.toString()),
        TextCellValue(tariff.toString())
      ]);
    }
    // send Excel file by email
    var fileBytes = excel.save();
    var directory = await getApplicationDocumentsDirectory();

    try {
      File('${directory.path}/points.xlsx')
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes!);
      print('File saved successfully in ${directory.path}/points.xlsx');
    } catch (e) {
      print('Error saving file: $e');
    }
  }
}
