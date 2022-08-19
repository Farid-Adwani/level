import 'dart:async';
import 'dart:math';

import 'package:Aerobotix/model/member.dart';
import 'package:Aerobotix/screens/authentication_screen.dart';
import 'package:Aerobotix/utils/helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:url_launcher/url_launcher.dart';

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
print("11111111111111111");
    try {
print("11111111111111111");

      memberRef.set({
        "photo": photo,
        "profile_photos": FieldValue.arrayUnion([photo]),
      }, SetOptions(merge: true));
print("11111111111111111");

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
          "verified": false,
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
        Member.verified = false;

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
    if (result == false) {
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

  static void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  static Future<bool> sms(phoneNumber) async {
    if (phoneNumber == "") {
      showSnackBar('Please enter your phone number!',
          col: Colors.redAccent[700]);
      return false;
    }
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == false) {
      showSnackBar('Please check your internet connection!',
          col: Colors.redAccent[700]);
      return false;
    }
    bool exist = false;
    String firstName = "";
    String lastName = "";
    String userphone = "";
    DocumentSnapshot? user;
    DocumentSnapshot? smsAdmin;

    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      DocumentReference memberRef = db.collection('admins').doc("sms");
      DocumentReference userRef = db.collection('members').doc(phoneNumber);

      await userRef.get().then((doc) {
        exist = doc.exists;
        user = doc;
      }).timeout(Duration(seconds: 5));

      if (exist == true) {
        userphone = user!.get("phone");
        firstName = user!.get("first_name");
        lastName = user!.get("first_name");
      } else {
        showSnackBar('There is no user with this phone number!',
            col: Colors.redAccent[700]);
        return false;
      }

      smsAdmin = await memberRef.get().timeout(Duration(
            seconds: 7,
          ));
      print(smsAdmin.data());
      if (smsAdmin.get("phone_sms") != "" && smsAdmin.get("reset_sms") != "") {
        String template = smsAdmin.get("reset_sms");
        template = template.replaceFirst("<phone>", userphone);
        template = template.replaceFirst("<name>", firstName + " " + lastName);
        template = template.replaceAll("<break>", '\n');
        template = template.replaceFirst("<emoji1>", "💗");
        template = template.replaceFirst("<emoji2>", "😭");
        template = template.replaceFirst("<emoji3>", "📞");
        if (user!.get("gender") == "Female") {
          template = template.replaceFirst("<emoji4>", "👧");
        } else {
          template = template.replaceFirst("<emoji4>", "👦");
        }

        FirestoreService._sendSMS(
            template, [smsAdmin.get("phone_sms").toString()]);
        return true;
      } else {
        showSnackBar("You can not do this ✋ !", col: Colors.red);
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

  static Future<bool> call() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == false) {
      showSnackBar('Please check your internet connection!',
          col: Colors.redAccent[700]);
      return false;
    }
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      DocumentReference memberRef = db.collection('admins').doc("sms");
      DocumentSnapshot? callAdmin;

      callAdmin = await memberRef.get().timeout(Duration(
            seconds: 7,
          ));
      print(callAdmin.data());
      if (callAdmin.get("phone_call") != "") {
        launch("tel://" + callAdmin.get("phone_call").toString());
        return true;
      } else {
        showSnackBar("You can not do this ✋ !", col: Colors.red);
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
      Member.first_name = user.get("first_name");
      Member.last_name = user.get("last_name");
      user.get("gender") == "Female"
          ? Member.gender = Gender.Female
          : Member.gender = Gender.Male;
      Member.level = user.get("level");
      Member.branch = user.get("branch");
      Member.photo = user.get("photo");
      Member.phone = user.get("phone");
      Member.auth = user.get("auth");
      Member.verified = user.get("verified");
      Member.password = user.get("password");
      Member.profilePhotos = user.get("profile_photos");
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
    Member.photo=downloadURL;
    return downloadURL;
  }

  static Future<bool> setString(String key, String value) async {
     
    if (value.trim() == "") {
      showSnackBar('Please enter a valid value!',
          col: Colors.redAccent[700]);
      return false;
    }
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == false) {
      showSnackBar('Please check your internet connection!',
          col: Colors.redAccent[700]);
      return false;
    }
    bool exist = false;
    String firstName = "";

    DocumentSnapshot? user;


    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      DocumentReference memberRef = db.collection('admins').doc("sms");
      DocumentReference userRef = db.collection('members').doc(Member.phone);

      await userRef.get().then((doc) {
        exist = doc.exists;
        user = doc;
      }).timeout(Duration(seconds: 5));

      if (exist == true) {
         userRef.update({key: value.trim()});
    print("updated " + key + " to " + value.trim());
     showSnackBar("Data updated successfully");
     return true;
      } else {
        showSnackBar('There is no user with this phone number!',
            col: Colors.redAccent[700]);
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


 static Future<bool> setlevel(String key, int value) async {
     
    if (value== "0")  {
      showSnackBar('Please select a level',
          col: Colors.redAccent[700]);
      return false;
    }
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == false) {
      showSnackBar('Please check your internet connection!',
          col: Colors.redAccent[700]);
      return false;
    }
    bool exist = false;
    String firstName = "";

    DocumentSnapshot? user;


    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      DocumentReference memberRef = db.collection('admins').doc("sms");
      DocumentReference userRef = db.collection('members').doc(Member.phone);

      await userRef.get().then((doc) {
        exist = doc.exists;
        user = doc;
      }).timeout(Duration(seconds: 5));

      if (exist == true) {
         userRef.update({key: value});
    print("updated " + key + " to " + value.toString());
     showSnackBar("Data updated successfully");
     return true;
      } else {
        showSnackBar('There is no user with this phone number!',
            col: Colors.redAccent[700]);
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


}
