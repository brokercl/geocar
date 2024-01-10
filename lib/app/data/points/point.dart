import 'package:geocar/app/data/movil/movil.dart';
import 'package:isar/isar.dart';

part 'point.g.dart';

@Collection()
class Point {
  Id? id; // this id correspond to costaneraNorteSN[index] from where I get name, coordinates (lat, long)
  // and all parameters related to that point
  @Backlink(to: 'movilToPoint')
  final pointToMovil = IsarLinks<Movil>();

  DateTime? date;
  double tariff;

  Point({
    required this.id, //this id correspond to costaneraNorteNS[index] from where I get name and point coordinates (lat, long), tarif, category movil and more..
    required this.date,
    required this.tariff,
  });
}
