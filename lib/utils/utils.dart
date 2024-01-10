// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

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
  c, // moto auto camioneta
  b, // bus camion
  r, //: bus camion con remolque
}

enum CardinalPoint { NW, N, NE, E, SW, S, SE, W }
