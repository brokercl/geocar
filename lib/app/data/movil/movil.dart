import 'package:geocar/app/data/points/point.dart';
import 'package:geocar/app/data/users/user.dart';
import 'package:geocar/utils/utils.dart';
import 'package:isar/isar.dart';

part 'movil.g.dart';

@Collection()
class Movil {
  Id? id;
  @Backlink(to: 'userLinksMovil')
  final movilToUser = IsarLinks<User>();

  final movilToPoint = IsarLinks<Point>();

  String? placa;
  @enumerated
  CategoryMovil categoryMovil;

  Movil({
    required this.id,
    required this.placa,
    required this.categoryMovil,
  });
}
