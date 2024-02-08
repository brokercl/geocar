import 'package:geocar/app/data/movil/movil.dart';
import 'package:isar/isar.dart';

part 'point.g.dart';

@Collection()
class Point {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment
  int point;
  // and all parameters related to that point
  @Backlink(to: 'movilToPoint')
  final pointToMovil = IsarLinks<Movil>();

  DateTime? date;
  double tariff;

  Point({
    required this.point, //this point correspond to costaneraNorteNS[index] from where I get name and point coordinates (lat, long), tarif, category movil and more..
    required this.date,
    required this.tariff,
  });
}
