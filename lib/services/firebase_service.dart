import 'dart:async';
import 'dart:math';

import 'package:Aerobotix/model/member.dart';
import 'package:Aerobotix/screens/authentication_screen.dart';
import 'package:Aerobotix/utils/helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:platform_device_id/platform_device_id.dart';

class FirestoreService {
  static late FirestoreService singleton;
  static String userId = "user1";
  static bool hasInstance = false;

  static FirestoreService getInstance() {
    if (hasInstance == false) {
      singleton = FirestoreService();
      hasInstance = true;
    }
    return singleton;
  }

  static Future<void> addProfilePhoto(String photo, String phone) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference memberRef = db.collection('members').doc(phone);

    try {
      memberRef.set({
        "photo": photo,
        "profile_photos": FieldValue.arrayUnion([photo]),
      }, SetOptions(merge: true));
    } catch (e) {}
  }

  static Future<bool> addUser(
      String first_name,
      String last_name,
      String phone,
      String password,
      Gender gender,
      int level,
      String branch,
      String photo,
      DateTime birthDate) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference memberRef = db.collection('members').doc(phone);
    String g = "";
    gender == Gender.Female ? g = "Female" : g = "Male";
    bool exist = false;
    try {
      await memberRef.get().then((doc) {
        exist = doc.exists;
      });
    } catch (e) {
      // If any error
      return false;
    }
    if (exist == false) {
      String? deviceId = "";
      try {
        print("hereeeeeeeeeeeeeee");
        deviceId = await PlatformDeviceId.getDeviceId;
        print("id");
        print(deviceId);
      } catch (e) {
        print("rrr");
      }
      try {
        memberRef.set({
          "phone": phone,
          "password": password,
          "first_name": first_name,
          "last_name": last_name,
          "gender": g,
          "level": level,
          "branch": branch,
          "photo": photo,
          "birth_date": birthDate,
          "auth": true,
          'device': deviceId,
          "online": DateTime.now(),
        });
        Member.phone = phone;
        Member.first_name = first_name;
        Member.last_name = last_name;
        Member.gender = gender;
        Member.level = level;
        Member.branch = branch;
        Member.photo = photo;
        Member.birthDate = birthDate;
        Member.password = password;
        Member.auth = true;
        Member.online = DateTime.now();
        Member.device = deviceId!;
      } catch (e) {}
    }
    return exist;
  }

  static Future<bool> isConnected() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference memberRef = db.collection('members');
    String? deviceId = "";
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
      print(deviceId);
    } catch (e) {
      return false;
    }

    try {
      print("tryinnnnnnnnnnnnnnnnnnnnng");
      QuerySnapshot user = await memberRef
          .where("device", isEqualTo: deviceId)
          .where("auth", isEqualTo: true)
          .limit(1)
          .get();
      DocumentSnapshot logged = user.docs.first;
      if (logged.id.isNotEmpty) {
        allocateData(logged);
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static Future<void> updateDevice(phone) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference memberRef = db.collection('members').doc(phone);

    String? deviceId = "";
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } catch (e) {
      print("error");
    }
    try {
      memberRef.update({
        "auth": true,
        'device': deviceId,
        "online": DateTime.now(),
      });
      Member.auth = true;
      Member.online = DateTime.now();
      Member.device = deviceId!;
    } catch (e) {}
  }

  static Future<bool> disconnect(phone, context) async {
    bool result = await InternetConnectionChecker().hasConnection;
if(result == false) {
    showSnackBar('Please check your internet connection!',
          col: Colors.redAccent[700]);
          return false;
   }
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference memberRef = db.collection('members').doc(phone);
    bool success = true;
    try {
      await memberRef.update({
        "auth": false,
        "online": DateTime.now(),
      }).timeout(
          Duration(
            seconds: 10,
          ), onTimeout: () {
        success = false;
        return false;
      }).onError((error, stackTrace) {
        success = false;
        return false;
      });
      if (success) {
        Member.auth = false;
        Member.online = DateTime.now();

        Navigator.pushNamedAndRemoveUntil(
          context,
          AuthenticationScreen.id,
          (route) => false,
        );
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> auth(code, phone) async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == false) {
      showSnackBar('Please check your internet connection!',
          col: Colors.redAccent[700]);
      return false;
    }
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      DocumentReference memberRef = db.collection('members').doc(phone);
      DocumentSnapshot? user;

      user = await memberRef.get().timeout(Duration(
            seconds: 7,
          ));
      print(user.data());
      if (user.get("password") != "") {
        if (user.get("password").toString() != code) {
          showSnackBar("Incorrect password ✋ !", col: Colors.red);
          return false;
        } else {
          return true;
        }
      } else {
        return false;
      }
    } on TimeoutException catch (e) {
      showSnackBar('Please check your internet connection!',
          col: Colors.redAccent[700]);
      return false;
    } catch (e) {
      showSnackBar('Please check your internet connection!',
          col: Colors.redAccent[700]);
      return false;
    }
  }

  static void allocateData(user) {
    try {
      Member.birthDate = user.get("birth_date").toDate();
      print(Member.birthDate);
      Member.first_name = user.get("first_name");
      Member.last_name = user.get("last_name");
      user.get("gender") == "Female"
          ? Member.gender = Gender.Female
          : Member.gender = Gender.Male;
      print(Member.gender);
      Member.level = user.get("level");
      Member.branch = user.get("branch");
      Member.photo = user.get("photo");

      Member.phone = user.get("phone");

      Member.password = user.get("password");
      print(Member.password);
      Member.profilePhotos = user.get("profile_photos");
      print(Member.profilePhotos);
    } catch (e) {}
  }

  static Future<bool> fetchUser(String phone) async {
    bool exist = false;
    late DocumentSnapshot user;
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == false) {
      showSnackBar('Please check your internet connection!',
          col: Colors.redAccent[700]);
      return false;
    }
    try {
      FirebaseFirestore db = await FirebaseFirestore.instance;
      DocumentReference memberRef = db.collection('members').doc(phone);

      await memberRef.get().then((doc) {
        exist = doc.exists;
        user = doc;
      }).timeout(Duration(seconds: 5));
    } on TimeoutException catch (e) {
      showSnackBar('Please check your internet connection!',
          col: Colors.redAccent[700]);
      return false;
    } catch (e) {
      showSnackBar('Please check your internet connection!',
          col: Colors.redAccent[700]);
      return false;
    }
    if (exist == true) {
      allocateData(user);
    } else {
      showSnackBar('There is no user with this phone number!',
          col: Colors.redAccent[700]);
    }
    return exist;
  }

  static Future<String> getImage(path, image) async {
    String downloadURL = "";
    if (image == "") {
      return "";
    }
    try {
      downloadURL = await FirebaseStorage.instance
          .ref()
          .child(path + image)
          .getDownloadURL()
          .onError((error, stackTrace) => "")
          .timeout(Duration(seconds: 5), onTimeout: () => "");
      print(downloadURL);
    } catch (e) {
      return "";
    }
    return downloadURL;
  }

  Future<void> setString(String key, String value) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference userRef = db.collection('members').doc(Member.phone);
    userRef.update({key: value});
    print("updated " + key + " to " + value);
  }
}
