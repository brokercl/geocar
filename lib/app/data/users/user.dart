import 'package:geocar/app/data/movil/movil.dart';
import 'package:geocar/utils/utils.dart';
import 'package:isar/isar.dart';

part 'user.g.dart';

@Collection()
class User {
  Id? id; // you can also use id = null to auto increment

// index se escribe sobre el campo que se desea indexar..
// en este caso  @Index va a ser efecto sobre email
  @Index(
    type: IndexType.value,
    unique: true,
  )
  String? email;

  String? password;

  @enumerated
  ObjectStatus status;

  final userLinksMovil = IsarLinks<Movil>();

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.status,
  });
}
