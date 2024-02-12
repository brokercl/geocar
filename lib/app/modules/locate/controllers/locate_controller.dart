import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:geocar/app/data/points/point.dart';
import 'package:geocar/app/modules/geocar/controllers/geocar_controller.dart';
import 'package:geocar/main.dart';
import 'package:geocar/utils/utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';

class LocateController extends GetxController {
  var geoCarController = Get.find<GeoCarController>();
  late Future<Isar> db;

  LocateController() {
    db = openIsarDB();
  }

  RxList<dynamic> tagConcesiones = RxList(
    [
      [
        ['Autopista Central', 'EJE NORTE - SUR', 'Dirección Sur - Norte'],
        ['Autopista Central', 'EJE NORTE - SUR', 'Dirección Norte - Sur'],
        ['Autopista Central', 'EJE GENERAL VELÁSQUEZ', 'Dirección Sur - Norte'],
        ['Autopista Central', 'EJE GENERAL VELÁSQUEZ', 'Dirección Norte - Sur'],
      ],
    ],
  );

  RxList<dynamic> redConsecionesTagChile = RxList();

  // este int almacena la posicion de redConsecionesTagChile
  // para mostrar todos sus atributos
  RxInt porticoMatch =
      RxInt(-1); // porticoMatch es inicializado -1 indicando no portico

  RxList<Point> points = RxList<Point>();

  RxBool movilIsInsideRoute = RxBool(false);

/* categoria de vehiculos
  1 y 4 : motos, autos y camionetas
  2     : buses y camiones
  3 y 5 : buses articulados y camiones con remolque
*/

  // Tarifa = Costo Km * Longitud del portico * factor que es la categoria (index + 1) o sea * 1, * 2 ó * 3
  final List<double> costoKm = [
    92.021, // [0] Tarifa Normal para categoria 1 y 4
    184.042, // [1] Tarifa Punta para categoria 2
    276.063, // [2] Tarifa Saturada para categoria 3 y 5
  ];

/*
 checkMovilInsideRoute
 no cobrar tag cuando movil pasa por caletera
 The Earth's circumference is approximately 40,000 kilometers,
 and there are 360 degrees of latitude around the Earth.
 Therefore, 1 degree of latitude is roughly equal to 40,000 km / 360 ≈ 111.11 km.

To convert meters to degrees for latitude, you can use the following formula:

Change in Latitude (degrees) =           Change in Meters
                              ________________________________________
                              Approximate Meters per Degree at Equator

So, for a change of 3 meters:

Change in Latitude (degrees) =    3.5
                                ______
                                111.11

Change in Latitude (degrees) ≈ 0.031500315

Therefore, you would add approximately 0.031500315 degrees to your original latitude coordinate.
Keep in mind that this is a rough estimate, and the conversion factor can vary slightly depending on your location on Earth.
*/

  double routeWidth = 0.031500315;

  CardinalPoint calculateCardinalPoint(double heading) {
    if (heading >= 337.5 || heading < 22.5) {
      return CardinalPoint.N;
    } else if (heading >= 22.5 && heading < 67.5) {
      return CardinalPoint.NE;
    } else if (heading >= 67.5 && heading < 112.5) {
      return CardinalPoint.E;
    } else if (heading >= 112.5 && heading < 157.5) {
      return CardinalPoint.SE;
    } else if (heading >= 157.5 && heading < 202.5) {
      return CardinalPoint.S;
    } else if (heading >= 202.5 && heading < 247.5) {
      return CardinalPoint.SW;
    } else if (heading >= 247.5 && heading < 292.5) {
      return CardinalPoint.W;
    } else {
      return CardinalPoint.NW;
    }
  }

  addUpdatePoint(Point addUpdatePoint) async {
    final isar = await db;
//      isar.writeTxnSync<int>(() => isar.points.putSync(addUpdatePoint));
    if (useCase == UseCases.addPoint) {
      try {
        await isar.writeTxn(() async {
          await isar.points.put(addUpdatePoint); // insert & update
        });
      } catch (e) {
        Get.snackbar('error trying addUpdatePoint()', e.toString());
      }
    }
    if (useCase == UseCases.updatePoint) {
      try {
        final indexWherePoint = points.indexWhere(
            (foundedPoints) => foundedPoints.id == addUpdatePoint.id);
        points[indexWherePoint] = addUpdatePoint;
      } catch (e) {
        Get.snackbar('error trying addUpdatePoint()', e.toString());
      }
    }
    addUpdatePointAlarm();
  }

  Future<void> deletePoint(Point? point) async {
    final isar = await db;
    isar.writeTxn(() async {
      await isar.points.delete(point!.id);
    });
    points.removeWhere((foundedPoint) => foundedPoint.id == point!.id);
  }

  late Timer checktime, checkLatLong;
  Rx<DateTime> now = DateTime.now().obs;
  RxDouble accur = RxDouble(0.0);
  RxDouble speed = RxDouble(0.0);
  RxDouble speedAccuracy = RxDouble(0.0);
  RxDouble alt = RxDouble(0.0);
  RxDouble lat = RxDouble(0.0);
  RxDouble long = RxDouble(0.0);
  RxDouble heading = RxDouble(0.0);
  RxDouble altitudeAccuracy = RxDouble(0.0);
  RxDouble headingAccuracy = RxDouble(0.0);
  // considera movil a 200 km/h
  // avanza 55.5 mts x seg
  // por eso el range distance to point es de 60 mts
  double distanceRangePoint = 60;
  late Position lastPosition;
  late Position currentPosition;
  RxString direction = RxString('unknow');

  RxDouble bearing = RxDouble(0.0);
  RxDouble heightBox = RxDouble(10.0);

// RM Region Metropolitana
// Costanera Norte
// cada punto necesita 2 variables mas para funcionar
  // la var que calcula la distancia entre la posicion actual y el punto a chequear
  // y la boolean que chequea distancia al movil ,
  //cuando movil entra en rango establecido
  // booleana cambia a true y graba el punto
  // cuando se aleja, vuelve a false

  // se considera tambien un radio medido desde el punto medio
  // para chequear que movil pasa dentro del radio (el portico en cuyo caso se registra el punto) y no fuera (la caletera)

/* tengo una matriz de tarifas donde:
cada hoja es un portico
las filas son las propiedades del portico
las filas 4, 5 y 6  estan los 3 tipos de tarifas TBFP, TBP y TS
las columnas de estas filas tienen los horarios para 
los dias laborales, sabados y festivos y domingos
los tipos de vehiculos son: (1-4: moto, auto, camioneta, 2: bus, camion, 3: bus articulado, camion con remolque)
para aplicar tarifa conozco:
hora para aplicar o Tarifa Base Fuera Punta TBFP o Tarifa Base Punta TBP o Tarifa Saturacion TS
y fecha para aplicar o laboral o (Sabado y Festivos) o Domingo
*/

  final audioPlayer = AudioPlayer();
  addUpdatePointAlarm() async {
    audioPlayer.play(AssetSource('sounds/point.wav'));
  }

//this function try to obtain if vehicule goes to N, E, S or W
  String getDirection(
      double lastLat, double currentLat, double lastLong, double currentLong) {
    double latDiff = currentLat - lastLat;
    double longDiff = currentLong - lastLong;

    if (latDiff > 0) {
      return 'N'; // Moving North
    } else if (latDiff < 0) {
      return 'S'; // Moving South
    } else if (longDiff > 0) {
      return 'E'; // Moving East
    } else if (longDiff < 0) {
      return 'W'; // Moving West
    } else {
      return 'No movement'; // No significant change in position
    }
  }

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
          'Location services are disabled', 'Please enable the services');
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Location permissions are denied', '');
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Location permissions are permanently denied',
          'cannot request permissions.');
      return false;
    }
    return true;
  }

  Future<void> getLocation() async {
    // Check for location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permission if not granted
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Handle the case where the user denies permission
        Get.snackbar('Location permission denied', '');
        return;
      }
    }

    // Get current position
    try {
      lastPosition = (await Geolocator.getLastKnownPosition())!;

      currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      direction.value = getDirection(
          lastPosition.latitude,
          currentPosition.latitude,
          lastPosition.longitude,
          currentPosition.longitude);
      // Use the position data as needed
      //updateBearing();
      accur.value = currentPosition.accuracy;
      speed.value = currentPosition.speed;
      alt.value = currentPosition.altitude;
      lat.value = currentPosition.latitude;
      long.value = currentPosition.longitude;
      heading.value = currentPosition.heading;
    } catch (e) {
      // Handle exceptions that may occur while getting the position
      Get.snackbar('Error getting location: $e', '');
    }
  }

  // Function to get the formatted time in DMY format
  RxString getFormattedDate() =>
      "${now.value.day}-${now.value.month}-${now.value.year}".obs;

  RxString getFormattedTime() {
    if (now.value.minute < 10) {
      return "${now.value.hour}:0${now.value.minute}".obs;
    }
    return "${now.value.hour}:${now.value.minute}".obs;
  }

  setLatLong(double lat, double long) => Position(
        latitude: lat,
        longitude: long,
        timestamp: now.value,
        accuracy: accur.value,
        altitude: alt.value,
        altitudeAccuracy: altitudeAccuracy.value,
        heading: heading.value,
        headingAccuracy: headingAccuracy.value,
        speed: speed.value,
        speedAccuracy: speedAccuracy.value,
      );

  calculoTariff(double costoKm, double longitudPortico) =>
      costoKm *
      longitudPortico *
      geoCarController.selectedMovilCategory.value.index;

  chekDistance(Position startPoint, Position endPoint) =>
      Geolocator.distanceBetween(
        startPoint.latitude,
        startPoint.longitude,
        endPoint.latitude,
        endPoint.longitude,
      ).obs;

  void updateBearing() =>
      //TODO chequear updateBearing
      // Get the bearing between two positions, if movil goes to South or North
      bearing.value = Geolocator.bearingBetween(
        lat.value,
        long.value,
        currentPosition.latitude,
        currentPosition.longitude,
      );

  getTariffTag(String horaSaturada, String horaPunta) {
    if (horaSaturada.isNotEmpty) {
      List<List<DateTime>> rangesHorasSaturadas =
          convertToDateTimeList(horaSaturada);
      // Check if the current time is inside any of the ranges
      isHoraSaturada.value =
          isTimeInRanges(now.value, rangesHorasSaturadas, 'saturada');
    }

    if (horaPunta.isNotEmpty) {
      // Convert the time ranges into a Dart List of DateTime ranges
      List<List<DateTime>> rangesHorasPuntas = convertToDateTimeList(horaPunta);

      isHoraPunta.value = isTimeInRanges(now.value, rangesHorasPuntas, 'punta');
    }
    // Print the result
  }

  List<List<DateTime>> convertToDateTimeList(String timeRanges) {
    List<String> ranges = timeRanges.split(' / ');
    List<List<DateTime>> dateTimeList = [];

    for (String range in ranges) {
      List<String> startEndTimes = range.split(' - ');
      DateTime startTime = parseTimeString(startEndTimes[0]);
      DateTime endTime = parseTimeString(startEndTimes[1]);

      dateTimeList.add([startTime, endTime]);
    }

    return dateTimeList;
  }

  DateTime parseTimeString(String timeString) {
    List<String> parts = timeString.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    return DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, hours, minutes);
  }

  bool isTimeInRanges(
      DateTime time, List<List<DateTime>> ranges, String puntaOsaturado) {
    for (List<DateTime> range in ranges) {
      if (time.isAfter(range[0]) && time.isBefore(range[1])) {
        if (puntaOsaturado == 'saturada') {
          inicioHoraSaturada = range[0];
          finHoraSaturada = range[1];
        }
        if (puntaOsaturado == 'punta') {
          inicioHoraPunta = range[0];
          finHoraPunta = range[1];
        }
        return true;
      }
    }
    return false;
  }

  RxDouble tariff = RxDouble(0.0);
  RxBool isHoraSaturada = RxBool(false);
  RxBool isHoraPunta = RxBool(false);

  DateTime inicioHoraPunta = DateTime.now();
  DateTime finHoraPunta = DateTime.now();

  DateTime inicioHoraSaturada = DateTime.now();
  DateTime finHoraSaturada = DateTime.now();

  var lastPortico = 0;

  @override
  void onInit() async {
    lastPosition = setLatLong(0, 0);
    currentPosition = setLatLong(0, 0);

    // Dirección Sur- Norte

    redConsecionesTagChile.add([
      [
        tagConcesiones[0][0],
        'PA2', // codigo del portico
        'Los Guindos - La Capilla' // Referencia de tramos
      ],
      7.68, // longitud del portico
      setLatLong(-33.469212, -70.688426),
      // control horarios
      [
        // laboral
        '', // saturado
        '', // punta
        // si no es saturado ni punta es horario normal
      ],
      [
        // sabado y festivo
        '', // no tiene horario saturado
        '', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
      [
        // domingo
        '', // no tiene horario saturado
        '', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
    ]);
    redConsecionesTagChile.add([
      [
        tagConcesiones[0][0],
        'PA3', // codigo del portico
        'La Capilla - Colón' // Referencia de tramos
      ],
      5.63, // longitud del portico
      setLatLong(-33.5050412, -70.6967296),
      // control horarios
      [
        // laboral
        '08:00 - 08:30', // saturado
        '07:30 - 08:00 / 08:30 - 09:00', // punta
        // si no es saturado ni punta es horario normal
      ],
      [
        // sabado y festivo
        '', // no tiene horario saturado
        '', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
      [
        // domingo
        '', // no tiene horario saturado
        '18:00 - 20:00', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
    ]);
    redConsecionesTagChile.add([
      [
        tagConcesiones[0][0],
        'PA5', // codigo del portico
        'Colón - Las Acacias' // Referencia de tramos
      ],
      3.22, // longitud del portico
      setLatLong(-33.535322, -70.7073119),
      // control horarios
      [
        // laboral
        '07:30 - 08:30', // saturado
        '06:30 - 07:00 / 08:30 - 10:00', // punta
        // si no es saturado ni punta es horario normal
      ],
      [
        // sabado y festivo
        '', // no tiene horario saturado
        '', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
      [
        // domingo
        '', // no tiene horario saturado
        '18:00 - 20:00', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
    ]);
    redConsecionesTagChile.add([
      [
        tagConcesiones[0][0],
        'PA7', // codigo del portico
        'Depto Stgo' // Referencia de tramos
      ],
      4.35, // longitud del portico
      setLatLong(-33.4135777, -70.5798551),
      // control horarios
      [
        // laboral
        // TODO revisar los espacios en el formato de fechas: 07:30 - 08:30 / ,
        '', // saturado
        '07:30 - 09:30', // punta
        // si no es saturado ni punta es horario normal
      ],
      [
        // sabado y festivo
        '', // no tiene horario saturado
        '', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
      [
        // domingo
        '', // no tiene horario saturado
        '18:30 - 20:30', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
    ]);
    redConsecionesTagChile.add([
      [
        tagConcesiones[0][0],
        'PA30', // codigo del portico
        'Américo Vespucio - Departamental' // Referencia de tramos
      ],
      3.78, // longitud del portico
      setLatLong(-33.5581375, -70.7106908),
      // control horarios
      [
        // laboral
        '07:00 - 08:00 / 08:30 - 09:00', // saturado
        '06:30 - 07:00 / 08:00 - 08:30 / 09:00 - 09:30', // punta
        // si no es saturado ni punta es horario normal
      ],
      [
        // sabado y festivo
        '', // no tiene horario saturado
        '7:30 - 9:30', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
      [
        // domingo
        '', // no tiene horario saturado
        '18:30 - 20:30', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
    ]);
    redConsecionesTagChile.add([
      [
        tagConcesiones[0][0],
        'PA10', // codigo del portico
        'Departamental - Carlos Valdovinos' // Referencia de tramos
      ],
      2.75, // longitud del portico
      setLatLong(-33.5821585, -70.7139955),
      // control horarios
      [
        // laboral
        '07:00 - 08:00 / 08:30 - 09:00', // saturado
        '06:30 - 07:00 / 08:00 - 08:30 / 09:00 - 09:30', // punta
        // si no es saturado ni punta es horario normal
      ],
      [
        // sabado y festivo
        '', // no tiene horario saturado
        '7:30 - 9:30', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
      [
        // domingo
        '', // no tiene horario saturado
        '18:30 - 20:30', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
    ]);
    redConsecionesTagChile.add([
      [
        tagConcesiones[0][0],
        'PA31', // codigo del portico
        'Carlos Valdovinos - Alameda' // Referencia de tramos
      ],
      3.55, // longitud del portico
      setLatLong(-33.5961085, -70.7157705),
      // control horarios
      [
        // laboral
        '07:30 - 09:00', // saturado
        '06:30 - 07:30 / 09:00 -12:00 / 12:30 - 13:00 / 14:00 - 14:30 / 17:00 - 19:30', // punta
        // si no es saturado ni punta es horario normal
      ],
      [
        // sabado y festivo
        '', // no tiene horario saturado
        '10:00 - 13:00', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
      [
        // domingo
        '', // no tiene horario saturado
        '18:30 - 20:30', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
    ]);
    redConsecionesTagChile.add([
      [
        tagConcesiones[0][0],
        'PA13', // codigo del portico
        'Alameda - Río Mapocho' // Referencia de tramos
      ],
      1.75, // longitud del portico
      setLatLong(-33.6241357, -70.7148114),
      // control horarios
      [
        // laboral
        '07:30 - 09:00', // saturado
        '06:30 - 07:30 / 09:00 - 12:00 / 12:30 - 13:00 / 14:00 - 14:30 / 17:00 - 19:30', // punta
        // si no es saturado ni punta es horario normal
      ],
      [
        // sabado y festivo
        '', // no tiene horario saturado
        '10:00 - 13:00', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
      [
        // domingo
        '', // no tiene horario saturado
        '18:30 - 20:30', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
    ]);
    redConsecionesTagChile.add([
      [
        tagConcesiones[0][0],
        'PA16', // codigo del portico
        'Río Mapocho - 14 de la Fama' // Referencia de tramos
      ],
      4.09, // longitud del portico
      setLatLong(-33.6947523, -70.7239556),
      // control horarios
      [
        // laboral
        '', // saturado
        '07:30 - 09:30', // punta
        // si no es saturado ni punta es horario normal
      ],
      [
        // sabado y festivo
        '', // no tiene horario saturado
        '', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
      [
        // domingo
        '', // no tiene horario saturado
        '', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
    ]);

    redConsecionesTagChile.add([
      [
        tagConcesiones[0][0],
        'PA17', // codigo del portico
        '14 de la Fama - A. Vespucio Norte' // Referencia de tramos
      ],
      4.45, // longitud del portico
      setLatLong(-33.6947523, -70.7239556),
      // control horarios
      [
        // laboral
        '', // saturado
        '07:00 - 10:30 / 11:00 - 13:00 / 17:30 - 19:30', // punta
        // si no es saturado ni punta es horario normal
      ],
      [
        // sabado y festivo
        '', // no tiene horario saturado
        '', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
      [
        // domingo
        '', // no tiene horario saturado
        '', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
    ]);

    // Dirección Norte - Sur

    redConsecionesTagChile.add([
      [
        tagConcesiones[0][1],
        'PA18', // codigo del portico
        'A. Vespucio Norte - 14 de la Fama' // Referencia de tramos
      ],
      4.45, // longitud del portico
      setLatLong(-33.6947523, -70.7239556),
      // control horarios
      [
        // laboral
        '07:00 - 09:00 / 17:00 - 19:00', // saturado
        '09:00 - 09:30 / 11:30 - 12:00 / 16:30 - 17:00', // punta
        // si no es saturado ni punta es horario normal
      ],
      [
        // sabado y festivo
        '', // no tiene horario saturado
        '', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
      [
        // domingo
        '', // no tiene horario saturado
        '', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
    ]);

    redConsecionesTagChile.add([
      [
        tagConcesiones[0][1],
        'PA15', // codigo del portico
        '14 de la Fama - Río Mapocho' // Referencia de tramos
      ],
      4.09, // longitud del portico
      setLatLong(-33.6947523, -70.7239556),
      // control horarios
      [
        // laboral
        '', // saturado
        '07:00 - 08:00 / 18:30 - 20:30', // punta
        // si no es saturado ni punta es horario normal
      ],
      [
        // sabado y festivo
        '', // no tiene horario saturado
        '', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
      [
        // domingo
        '', // no tiene horario saturado
        '', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
    ]);

    redConsecionesTagChile.add([
      [
        tagConcesiones[0][1],
        'PA14', // codigo del portico
        'Río Mapocho - Alameda' // Referencia de tramos
      ],
      1.75, // longitud del portico
      setLatLong(-33.6947523, -70.7239556),
      // control horarios
      [
        // laboral
        '07:30 - 08:30 / 09:00 - 10-00 / 12:30 - 13:00 / 15:30 - 16:30 / 17:00 - 17:30 / 18:30 - 19:00', // saturado
        '08:30 - 09:00 / 10:00 - 10:30 / 11:00 - 12:30 / 13:00 - 15:30 / 16:30 - 17:00 / 17:30 - 18:30 / 19:00 - 20:30', // punta
        // si no es saturado ni punta es horario normal
      ],
      [
        // sabado y festivo
        '', // no tiene horario saturado
        '11:00 - 15:00', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
      [
        // domingo
        '', // no tiene horario saturado
        '', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
    ]);

    redConsecionesTagChile.add([
      [
        tagConcesiones[0][1],
        'PA12', // codigo del portico
        'Alameda - Carlos Valdovinos' // Referencia de tramos
      ],
      3.55, // longitud del portico
      setLatLong(-33.6947523, -70.7239556),
      // control horarios
      [
        // laboral
        '07:30 - 08:30 / 09:00 - 10-00 / 12:30 - 13:00 / 15:30 -16:30 / 17:00 - 17:30 / 18:30 - 19:00', // saturado
        '08:30 - 09:00 / 10:00 - 10:30 / 11:00 - 12:30 / 13:00 - 15:30 / 16:30 - 17:00 / 17:30 - 18:30 / 19:00 - 20:30', // punta
        // si no es saturado ni punta es horario normal
      ],
      [
        // sabado y festivo
        '', // no tiene horario saturado
        '11:00 - 15:00', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
      [
        // domingo
        '', // no tiene horario saturado
        '', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
    ]);

    redConsecionesTagChile.add([
      [
        tagConcesiones[0][1],
        'PA11', // codigo del portico
        'Carlos Valdovinos - Departamental' // Referencia de tramos
      ],
      2.75, // longitud del portico
      setLatLong(-33.6947523, -70.7239556),
      // control horarios
      [
        // laboral
        '', // saturado
        '17:30 - 20:30', // punta
        // si no es saturado ni punta es horario normal
      ],
      [
        // sabado y festivo
        '', // no tiene horario saturado
        '11:00 - 15:00', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
      [
        // domingo
        '', // no tiene horario saturado
        '', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
    ]);

    redConsecionesTagChile.add([
      [
        tagConcesiones[0][1],
        'PA9', // codigo del portico
        'Departamental - Américo Vespucio' // Referencia de tramos
      ],
      3.78, // longitud del portico
      setLatLong(-33.6947523, -70.7239556),
      // control horarios
      [
        // laboral
        '', // saturado
        '17:30 - 20:30', // punta
        // si no es saturado ni punta es horario normal
      ],
      [
        // sabado y festivo
        '', // no tiene horario saturado
        '11:00 - 15:00', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
      [
        // domingo
        '', // no tiene horario saturado
        '', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
    ]);

    redConsecionesTagChile.add([
      [
        tagConcesiones[0][1],
        'PA8', // codigo del portico
        'Américo Vespucio - Las Acacias' // Referencia de tramos
      ],
      4.35, // longitud del portico
      setLatLong(-33.6947523, -70.7239556),
      // control horarios
      [
        // laboral
        '', // saturado
        '18:30 - 20:30', // punta
        // si no es saturado ni punta es horario normal
      ],
      [
        // sabado y festivo
        '', // no tiene horario saturado
        '', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
      [
        // domingo
        '', // no tiene horario saturado
        '', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
    ]);

    redConsecionesTagChile.add([
      [
        tagConcesiones[0][1],
        'PA32', // codigo del portico
        'Las Acacias - Lo Blanco' // Referencia de tramos
      ],
      1.70, // longitud del portico
      setLatLong(-33.6947523, -70.7239556),
      // control horarios
      [
        // laboral
        '18:00 - 19:30', // saturado
        '17:00 - 18:00 / 19:30 - 20:30', // punta
        // si no es saturado ni punta es horario normal
      ],
      [
        // sabado y festivo
        '', // no tiene horario saturado
        '', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
      [
        // domingo
        '', // no tiene horario saturado
        '', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
    ]);

    redConsecionesTagChile.add([
      [
        tagConcesiones[0][1],
        'PA6', // codigo del portico
        'Lo Blanco - Colón' // Referencia de tramos
      ],
      1.52, // longitud del portico
      setLatLong(-33.6947523, -70.7239556),
      // control horarios
      [
        // laboral
        '18:00 - 19:30', // saturado
        '17:00 - 18:00 / 19:30 - 20:30', // punta
        // si no es saturado ni punta es horario normal
      ],
      [
        // sabado y festivo
        '', // no tiene horario saturado
        '', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
      [
        // domingo
        '', // no tiene horario saturado
        '', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
    ]);

    redConsecionesTagChile.add([
      [
        tagConcesiones[0][1],
        'PA37', // codigo del portico
        'Colón - Calera de Tango' // Referencia de tramos
      ],
      4.38, // longitud del portico
      setLatLong(-33.6947523, -70.7239556),
      // control horarios
      [
        // laboral
        '', // saturado
        '', // punta
        // si no es saturado ni punta es horario normal
      ],
      [
        // sabado y festivo
        '', // no tiene horario saturado
        '', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
      [
        // domingo
        '', // no tiene horario saturado
        '', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
    ]);

    redConsecionesTagChile.add([
      [
        tagConcesiones[0][1],
        'PA4', // codigo del portico
        'Calera de Tango - La Capilla' // Referencia de tramos
      ],
      1.25, // longitud del portico
      setLatLong(-33.6947523, -70.7239556),
      // control horarios
      [
        // laboral
        '', // saturado
        '', // punta
        // si no es saturado ni punta es horario normal
      ],
      [
        // sabado y festivo
        '', // no tiene horario saturado
        '', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
      [
        // domingo
        '', // no tiene horario saturado
        '', // solo tiene horario punta
        // entonces si no es punta es horario normal
      ],
    ]);

    redConsecionesTagChile.add(
      [
        [
          tagConcesiones[0][1],
          'PA1', // codigo del portico
          'La Capilla - Los Guindos' // Referencia de tramos
        ],
        7.68, // longitud del portico
        setLatLong(-33.6947523, -70.7239556),
        // control horarios
        [
          // laboral
          '', // saturado
          '', // punta
          // si no es saturado ni punta es horario normal
        ],
        [
          // sabado y festivo
          '', // no tiene horario saturado
          '', // solo tiene horario punta
          // entonces si no es punta es horario normal
        ],
        [
          // domingo
          '', // no tiene horario saturado
          '', // solo tiene horario punta
          // entonces si no es punta es horario normal
        ],
      ],
    );

    /* calculo tarifas por portico
          1ro se calculan las tarifas en horario normal
          luego las de hora punta
        finalmente se calculan las tarifas en horario saturado
        para ello se utiliza la sgte lista ya definida
        lista que hay que actualizar anualmente
          final List<double> costoKm = [
            92.021, // [0] Tarifa Normal para categoria 1 y 4, factor 1
            184.042, // [1] Tarifa Punta para categoria 2, factor 2
            276.063, // [2] Tarifa Saturada para categoria 3 y 5, factor 3
          ];
          que se multiplica por la longitud del portico y por el factor segun tipo de vehiculo
          esto da como resultado, 3 valores lo que segun el horario normal, punta o saturado, se selecciona el valor adecuado

        */

    // el valor de esta var es igual para cualquier elemento de la lista redConsecionesTagChile
    var redConsecionesTagChileFilaLength = redConsecionesTagChile[9].length;

    for (var hoja = 0; hoja < redConsecionesTagChile.length; hoja++) {
      // si el valor para horas saturadas es vacio o empty => la tarifa saturada sera 0
      print(
          '${red}horario laboral saturado ${redConsecionesTagChile[hoja][0][0]} [$hoja][3][0]: ${redConsecionesTagChile[hoja][3][0]}');
      // si el valor para horas punta es vacio o empty => la tarifa punta sera 0
      print(
          '${yellow}horario laboral punta ${redConsecionesTagChile[hoja][0][0]} [$hoja][3][1]: ${redConsecionesTagChile[hoja][3][1]}');
      print('');
      for (var fila = redConsecionesTagChileFilaLength;
          fila < redConsecionesTagChileFilaLength + costoKm.length;
          fila++) {
        redConsecionesTagChile[hoja].add([
          double.parse((costoKm[fila - redConsecionesTagChileFilaLength] *
                  redConsecionesTagChile[hoja][1] *
                  1) // tarifas para el grupo 1 y 4 para fila = 0
              .toStringAsFixed(2)),
          double.parse((costoKm[fila - redConsecionesTagChileFilaLength] *
                  redConsecionesTagChile[hoja][1] *
                  2 *
                  (redConsecionesTagChile[hoja][3][1].isEmpty
                      ? 0
                      : 1)) //  tarifas para el grupo 2 para fila = 1
              .toStringAsFixed(2)),
          double.parse((costoKm[fila - redConsecionesTagChileFilaLength] *
                  redConsecionesTagChile[hoja][1] *
                  3 *
                  (redConsecionesTagChile[hoja][3][0].isEmpty
                      ? 0
                      : 1)) // tarifas para el grupo 3 y 5 para fila = 2
              .toStringAsFixed(2)),
        ]);
      }
      print('tarifa para vehiculos grupo 1 y 4');
      print(
          'redConsecionesTagChile[$hoja][$redConsecionesTagChileFilaLength] ${redConsecionesTagChile[hoja][redConsecionesTagChileFilaLength]}');
      print('tarifa para vehiculos grupo 2');
      print(
          'redConsecionesTagChile[$hoja][${redConsecionesTagChileFilaLength + 1}] ${redConsecionesTagChile[hoja][redConsecionesTagChileFilaLength + 1]}');
      print('tarifa para vehiculos grupo 3 y 5');
      print(
          'redConsecionesTagChile[$hoja][${redConsecionesTagChileFilaLength + 2}] ${redConsecionesTagChile[hoja][redConsecionesTagChileFilaLength + 2]}');
      print('');
    }

    super.onInit();

    bool esFeriado = feriados.contains(DateTime(now.value.year, now.value.month,
        now.value.day)); // TODO check if feriado when day change

    // Start a timer to update the time every second
    checktime = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      now.value = DateTime.now();
    });
    checkLatLong = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        getLocation();

        // TODO taco: cada segundo se revisan todos los porticos para saber por cual portico el movil esta pasando
        // posible solucion, de acuerdo a ultima posicion conocida se podria intuir en un radio de 10 kms
        // pos cuales porticos el movil podria pasar, dependiendo de la ruta seleccionada por movil
        // de esta forma solo se revisarian 5 o 6 porticos dentro del radio y no todos
        // a cada portico chequeado, los valores se actualizan

        // por otro lado, quiza no valga la pena este calculo, ya que el total de porticos no superaria los 100

        for (var portico = lastPortico;
            portico < redConsecionesTagChile.length;
            portico++) {
          /*
                el sgte if chequea si movil pasa dentro del rango del portico (longitud) y sus latitudes, 
                para determinar si movil pasa por ruta (cobra tag) o por caletera (NO cobra tag)
                para el caso que movil se mueva de Norte a Sur
              */
          if (chekDistance(currentPosition, redConsecionesTagChile[portico][2])
                      .value <
                  distanceRangePoint &&
              currentPosition.latitude <=
                  redConsecionesTagChile[portico][2].latitude + routeWidth) {
            porticoMatch.value = portico;
            if (now().weekday >= 1 && now().weekday <= 5) {
              print('hoy es dia laboral');

              getTariffTag(redConsecionesTagChile[portico][3][0],
                  redConsecionesTagChile[portico][3][1]);
            } else if (now().weekday == 6 || esFeriado) {
              print('hoy es sabado o festivo');

              getTariffTag(redConsecionesTagChile[portico][4][0],
                  redConsecionesTagChile[portico][4][1]);
            } else if (now().weekday == 7) {
              print('hoy es domingo');
              getTariffTag(redConsecionesTagChile[portico][5][0],
                  redConsecionesTagChile[portico][5][1]);
              // si no hay horarios ni para saturado ni para punta => tarifa = 0
            }
            // asignacion de tarifa para dias laborales, (sabados o festivos) y domingos
            if (isHoraSaturada.value) {
              tariff.value = redConsecionesTagChile[portico][
                  redConsecionesTagChileFilaLength +
                      geoCarController.selectedMovilCategory.value.index][2];
            } else if (isHoraPunta.value) {
              tariff.value = redConsecionesTagChile[portico][
                  redConsecionesTagChileFilaLength +
                      geoCarController.selectedMovilCategory.value.index][1];
            } else {
              tariff.value = redConsecionesTagChile[portico][
                  redConsecionesTagChileFilaLength +
                      geoCarController.selectedMovilCategory.value.index][0];
            }
            print(
                'geoCarController.selectedMovilCategory.value.index: ${geoCarController.selectedMovilCategory.value.index}');
            print('tariff: ${tariff.value}');
            if (portico != lastPortico) {
              // avoid same point saved more than once
              addUpdatePoint(
                Point(
                  point:
                      portico, //this id correspond to costaneraNorteNS[index] from where I get name and point coordinates (lat, long)
                  date: now.value,
                  tariff: tariff.value,
                ),
              );
            }
            lastPortico = portico;

            break; // no need to keep searching, portico was founded..
          }
        }
        print('lastPosition $lastPosition');
        print('currentPosition $currentPosition');
      },
    );
  }

  @override
  void onClose() {
    // Cancel the timer when the controller is closed
    checktime.cancel();
    checkLatLong.cancel();
    audioPlayer.dispose();
    super.onClose();
  }
}
