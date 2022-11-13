import 'dart:math';

import 'package:gender_picker/source/enums.dart';

class Member {
  static String first_name = "";
  static String last_name = "";
  static String phone = "";
  static String password = "";
  static Gender gender = Gender.Others;
  static int level = 0;

  static String branch = "";
  static String photo = "";
  static List<dynamic> profilePhotos = [];
  static DateTime birthDate = DateTime.now();
  static bool auth = false;
  static bool verified = false;
  static DateTime online = DateTime.now();
  static String device = "";
  static int entryYear=DateTime.now().year;
  static int xp = 10;
  static String gameLevel = "3asfour";
  static bool isNew = true;
  static List<dynamic> badges=[];
  static List<dynamic> otherBadges=[];
  static List<dynamic> roles=[];
  static int claim=0;





  static String otherPhone="";
}
