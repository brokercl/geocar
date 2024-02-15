// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';

var locateViewfontZise = 18.0;
var geoCarViewfontZise = 18.0;
double geoCarViewIconSIze = 30;
double geoCarSizedBox = 10;

appBar(String appBarString) => AppBar(
      automaticallyImplyLeading: false,
      title: Text(appBarString),
      centerTitle: true,
    );

Color selected = Colors.blue;
Color unSelected = Colors.grey;
Color itsTrue = Colors.green;
Color itsfalse = Colors.blue;
Color horaSaturada = const Color.fromARGB(255, 216, 33, 20);
Color horaPunta = const Color.fromARGB(255, 200, 89, 4);
Color horaBaja = const Color.fromARGB(255, 67, 211, 96);

// impresion consola depuracion en colores
String reset = '\x1B[0m';
String red = '\x1B[31m';
String green = '\x1B[32m';
String yellow = '\x1B[33m';

TextStyle trueTitleLocateTextStyle = TextStyle(color: itsTrue, fontSize: 30);
TextStyle falseTitleLocateTextStyle = TextStyle(color: itsfalse, fontSize: 30);
TextStyle trueSubTitleLocateTextStyle = TextStyle(color: itsTrue, fontSize: 20);
TextStyle falseSubTitleLocateTextStyle =
    TextStyle(color: itsfalse, fontSize: 20);

TextStyle titleGeoCarTextStyle = TextStyle(color: selected, fontSize: 30);
TextStyle subTitleGeoCarTextStyle = TextStyle(color: selected, fontSize: 20);

UseCases useCase = UseCases.addPoint;

enum UseCases {
  logout, //buildAppBar
  getBack, //buildAppBar

  findUsers,

  addPoint,
  readUser,
  updatePoint,
  deleteUser,
}

enum ObjectStatus {
  active, // means a teacher took the course to teach
  pending, // means ready for a teacher to take the course
  deleted,
  suspended, // along other reasons, suspended means no teacher or a minimun students
}

// Role means what the user is allowed to do or not
enum Role {
  admin, // crud all except tutor pays
  manager, // crud over teachers and students
  utp, // set schedule class
  ecommerce, // set course cost
  tutor, // pay student courses, tutor can IsarLink to student, and BackLink too
}

enum CategoryMovil {
  c, // moto, auto, camioneta
  b, // bus, camion
  r, //: bus articulado, camion con remolque
}

enum CardinalPoint { NW, N, NE, E, SW, S, SE, W }

// TODO actualiza feriados todos los años
final List<DateTime> feriados = [
  DateTime(2024, 1, 1), // Año Nuevo
  DateTime(2024, 3, 29), // Viernes Santo
  DateTime(2024, 3, 30), // Sábado Santo
  DateTime(2024, 5, 1), // Día del Trabajo
  DateTime(2024, 5, 21), // Día de las Glorias Navales
  DateTime(2024, 6, 9), // Elecciones Primarias Alcaldes y Gobernadores
  DateTime(2024, 6, 20), // Día Nacional de los Pueblos Indígenas
  DateTime(2024, 6, 29), // San Pedro y San Pablo
  DateTime(2024, 7, 16), // Día de la Virgen del Carmen
  DateTime(2024, 8, 15), // Asunción de la Virgen
  DateTime(2024, 9, 18), // Independencia Nacional
  DateTime(2024, 9, 19), // Día de las Glorias del Ejército
  DateTime(2024, 9, 20), // Feriado añadido de Fiestas Patrias
  DateTime(2024, 10, 12), // Encuentro de Dos Mundos
  DateTime(2024, 10,
      27), // Elecciones Municipales, Consejeros Regionales y Gobernadores Regionales
  DateTime(2024, 10, 31), // Día de las Iglesias Evangélicas y Protestantes
  DateTime(2024, 11, 1), // Día de Todos los Santos
  DateTime(2024, 12, 8), // Inmaculada Concepción
  DateTime(2024, 12, 25), // Navidad
];

Future<void> selectDate(BuildContext context, Rx<DateTime> selectedDate,
    DateTime firstDate, DateTime lastDate) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: selectedDate.value,
    firstDate: firstDate,
    lastDate: lastDate,
  );
  if (pickedDate != null && pickedDate != selectedDate.value) {
    selectedDate.value = pickedDate;
  }
}

String formatCurrency(double amount) {
  final formatter = NumberFormat("#,###", "es_CL");
  return formatter.format(amount);
}
