import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:levels/model/profiles.dart';

class FirestoreService {
  static late FirestoreService singleton;
  static String userId = "user1";
  static String userName = "";
  static String userAvatar= "";

  static List<String> selectedGadgets = [];
  static bool hasInstance = false;
  static String gadget = "gadget1";
  static String phone = "";

  static List<String> days = [];
  static List<String> gadgets = [];

  static String selectedDay = "2022-07-25";
  static String selectedMonth = "07";
  static String selectedMonthName = "July";
  static FirestoreService getInstance() {
    if (hasInstance == false) {
      singleton = FirestoreService();
      hasInstance = true;
    }
    return singleton;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void fakeData() async {
    try {
      print("aaaaaaaaaaaaaa");
      QuerySnapshot qs =
          await FirebaseFirestore.instance.collectionGroup("days").get();
      print(qs.docs.toString());
      for (var item in qs.docs) {
        print(item.data());
      }
    } catch (e) {
      print(e.toString());
    }

    for (var i = 0; i < 31; i++) {
      String d = i.toString();
      if (i < 10) {
        d = "0" + d;
      }
      FirestoreService.setData("user1", "gadget1", "2022-07-" + d.toString());
      FirestoreService.setData("user1", "gadget2", "2022-07-" + d.toString());
      FirestoreService.setData("user1", "gadget3", "2022-07-" + d.toString());
      FirestoreService.setData("user1", "gadget4", "2022-07-" + d.toString());

      FirestoreService.setData("user2", "gadget1", "2022-07-" + d.toString());
      FirestoreService.setData("user2", "gadget2", "2022-07-" + d.toString());
      FirestoreService.setData("user2", "gadget3", "2022-07-" + d.toString());
      FirestoreService.setData("user2", "gadget4", "2022-07-" + d.toString());
      FirestoreService.setData("user3", "gadget1", "2022-07-" + d.toString());
      FirestoreService.setData("user3", "gadget2", "2022-07-" + d.toString());
      FirestoreService.setData("user3", "gadget3", "2022-07-" + d.toString());
      FirestoreService.setData("user3", "gadget4", "2022-07-" + d.toString());
    }
  }

  Future<String?> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<void> setString(String key, String value) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference userRef = db.collection('users').doc(userId);
    userRef.update({key: value});
    print("updated " + key + " to " + value);
  }

  Future<void> setNumber(String key, double value) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference userRef = db.collection('users').doc(userId);
    userRef.update({key: value});
    print("updated " + key.toString() + " to " + value.toString());
  }

  Future<void> toggleOnlieStatus(bool isOnline) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference userRef = db.collection('users').doc(userId);
    userRef.update({'isOnline': isOnline});
  }

  Future<void> setGadgetField(String gadgetId, String key, double value) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference gadgetRef =
        db.collection('users').doc(userId).collection('gadgets').doc(gadgetId);
    gadgetRef.update({key: value});
  }

  static Future<String> getUserFromPhoneNumber(String phone) async {
    var user = await FirebaseFirestore.instance
        .collection('users')
        .where('phone', isEqualTo: phone)
        .limit(1)
        .get();
    List userList = user.docs.toList();
    if (!userList.isEmpty) {
      print(userList[0].id);
      try {
        FirestoreService.userName= userList[0]["name"].toString() ;
      } catch (e) {
        
      }
      try {
        FirestoreService.userAvatar= userList[0]["avatar"].toString() ;
      } catch (e) {
        
      }
      return userList[0].id;
    }
    return "";
  }

  static Future<void> setData(String user, String gadget, String day) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference users = db
        .collection('users')
        .doc(user)
        .collection("gadgets")
        .doc(gadget)
        .collection("days")
        .doc(day) as DocumentReference<Object?>;
    var data = {
      "8h": {
        "fadult": Random().nextDouble() * 100,
        "fold": Random().nextDouble() * 100,
        "myoung": Random().nextDouble() * 100,
        "mold": Random().nextDouble() * 100,
        "fyoung": Random().nextDouble() * 100,
        "mkid": Random().nextDouble() * 100,
        "total_persons": Random().nextInt(500),
        "madult": Random().nextDouble() * 100,
        "fkid": Random().nextDouble() * 100
      },
      "9h": {
        "fadult": Random().nextDouble() * 100,
        "fold": Random().nextDouble() * 100,
        "myoung": Random().nextDouble() * 100,
        "mold": Random().nextDouble() * 100,
        "fyoung": Random().nextDouble() * 100,
        "mkid": Random().nextDouble() * 100,
        "total_persons": Random().nextInt(500),
        "madult": Random().nextDouble() * 100,
        "fkid": Random().nextDouble() * 100
      },
      "10h": {
        "fadult": Random().nextDouble() * 100,
        "fold": Random().nextDouble() * 100,
        "myoung": Random().nextDouble() * 100,
        "mold": Random().nextDouble() * 100,
        "fyoung": Random().nextDouble() * 100,
        "mkid": Random().nextDouble() * 100,
        "total_persons": Random().nextInt(500),
        "madult": Random().nextDouble() * 100,
        "fkid": Random().nextDouble() * 100
      },
      "11h": {
        "fadult": Random().nextDouble() * 100,
        "fold": Random().nextDouble() * 100,
        "myoung": Random().nextDouble() * 100,
        "mold": Random().nextDouble() * 100,
        "fyoung": Random().nextDouble() * 100,
        "mkid": Random().nextDouble() * 100,
        "total_persons": Random().nextInt(500),
        "madult": Random().nextDouble() * 100,
        "fkid": Random().nextDouble() * 100
      },
      "12h": {
        "fadult": Random().nextDouble() * 100,
        "fold": Random().nextDouble() * 100,
        "myoung": Random().nextDouble() * 100,
        "mold": Random().nextDouble() * 100,
        "fyoung": Random().nextDouble() * 100,
        "mkid": Random().nextDouble() * 100,
        "total_persons": Random().nextInt(500),
        "madult": Random().nextDouble() * 100,
        "fkid": Random().nextDouble() * 100
      },
      "13h": {
        "fadult": Random().nextDouble() * 100,
        "fold": Random().nextDouble() * 100,
        "myoung": Random().nextDouble() * 100,
        "mold": Random().nextDouble() * 100,
        "fyoung": Random().nextDouble() * 100,
        "mkid": Random().nextDouble() * 100,
        "total_persons": Random().nextInt(500),
        "madult": Random().nextDouble() * 100,
        "fkid": Random().nextDouble() * 100
      },
      "14h": {
        "fadult": Random().nextDouble() * 100,
        "fold": Random().nextDouble() * 100,
        "myoung": Random().nextDouble() * 100,
        "mold": Random().nextDouble() * 100,
        "fyoung": Random().nextDouble() * 100,
        "mkid": Random().nextDouble() * 100,
        "total_persons": Random().nextInt(500),
        "madult": Random().nextDouble() * 100,
        "fkid": Random().nextDouble() * 100
      },
      "15h": {
        "fadult": Random().nextDouble() * 100,
        "fold": Random().nextDouble() * 100,
        "myoung": Random().nextDouble() * 100,
        "mold": Random().nextDouble() * 100,
        "fyoung": Random().nextDouble() * 100,
        "mkid": Random().nextDouble() * 100,
        "total_persons": Random().nextInt(500),
        "madult": Random().nextDouble() * 100,
        "fkid": Random().nextDouble() * 100
      },
      "16h": {
        "fadult": Random().nextDouble() * 100,
        "fold": Random().nextDouble() * 100,
        "myoung": Random().nextDouble() * 100,
        "mold": Random().nextDouble() * 100,
        "fyoung": Random().nextDouble() * 100,
        "mkid": Random().nextDouble() * 100,
        "total_persons": Random().nextInt(500),
        "madult": Random().nextDouble() * 100,
        "fkid": Random().nextDouble() * 100
      },
      "17h": {
        "fadult": Random().nextDouble() * 100,
        "fold": Random().nextDouble() * 100,
        "myoung": Random().nextDouble() * 100,
        "mold": Random().nextDouble() * 100,
        "fyoung": Random().nextDouble() * 100,
        "mkid": Random().nextDouble() * 100,
        "total_persons": Random().nextInt(500),
        "madult": Random().nextDouble() * 100,
        "fkid": Random().nextDouble() * 100
      },
      "all_day_stats": {
        "fadult": Random().nextDouble() * 100,
        "fold": Random().nextDouble() * 100,
        "myoung": Random().nextDouble() * 100,
        "mold": Random().nextDouble() * 100,
        "fyoung": Random().nextDouble() * 100,
        "mkid": Random().nextDouble() * 100,
        "total_persons": Random().nextInt(2000) + 500,
        "madult": Random().nextDouble() * 100,
        "fkid": Random().nextDouble() * 100
      },
    };

    users.set(data);
  }

  Future<Map<DateTime, double>> getDayHoursMultiple(
      String day, String categorie) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    print(FirestoreService.selectedGadgets);
    print("i,nn");
    var data;
    Map<DateTime, double> hours = {};

    for (var gad in FirestoreService.selectedGadgets) {
      print("===============================" + gad.toString());
      await db
          .collection('users')
          .doc(FirestoreService.userId)
          .collection('gadgets')
          .doc(gad)
          .collection("days")
          .doc(day)
          .get()
          .then((doc) => {data = doc.data()});
      print(data);
      for (var i = 0; i < 24; i++) {
        String hour = i.toString() + "h";
        try {
          String sfer = "";
          if (i < 10) {
            sfer = "0";
          }

          if (data[hour] != null) {
            print(i);
            if (hours.containsKey(DateTime.parse(
                "2020-02-02 " + sfer + i.toString() + ":00:00Z"))) {
              double old = hours[DateTime.parse(
                  "2020-02-02 " + sfer + i.toString() + ":00:00Z")]!;
              hours[DateTime.parse(
                      "2020-02-02 " + sfer + i.toString() + ":00:00Z")] =
                  old +
                    
                          data[hour]["total_persons"].toDouble() ;
            } else {
              hours[DateTime.parse(
                      "2020-02-02 " + sfer + i.toString() + ":00:00Z")] =
                 
                      data[hour]["total_persons"].toDouble() ;
            }
            print(hours[DateTime.parse(
                "2020-02-02 " + sfer + i.toString() + ":00:00Z")]);

            // print(hour + "  ==> " + data[hour].toString());
          }
        } catch (e) {
          // print("errorrrr " + e.toString());
        }
      }
    }

    print(hours.toString());
    return hours;
  }

  Future<Map<DateTime, double>> getDayHours(
      String gadgetId, String day, String categorie) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var data;
    Map<DateTime, double> hours = {};
    await db
        .collection('users')
        .doc(FirestoreService.userId)
        .collection('gadgets')
        .doc(gadgetId)
        .collection("days")
        .doc(day)
        .get()
        .then((doc) => {data = doc.data()});

    for (var i = 0; i < 24; i++) {
      String hour = i.toString() + "h";
      try {
        String sfer = "";
        if (i < 10) {
          sfer = "0";
        }
        if (data[hour] != null) {
          hours[DateTime.parse(
                  "2020-02-02 " + sfer + i.toString() + ":00:00Z")] =
              data[hour][categorie].toDouble() *
                  data[hour]["total_persons"].toDouble() /
                  100.0;
          print(hour + "  ==> " + data[hour].toString());
        }
      } catch (e) {
        print("errorrrr " + e.toString());
      }
    }

    print(hours.toString());
    return hours;
  }

  Future<Map<DateTime, double>> getDaysMonthMultiple(String Month) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var data;
    print("innn");
    print(userId);
    print(FirestoreService.selectedGadgets);
    Map<DateTime, double> daysMap = {};
    List<String> daysList = [];
    for (String gad in FirestoreService.selectedGadgets) {
      print(gad + "rrrrrrrrrrrr");
      await db
          .collection('users')
          .doc(FirestoreService.userId)
          .collection('gadgets')
          .doc(gad)
          .collection("days")
          .get()
          .then((doc) => {data = doc.docs.toList()});
      print(data);
      try {
        for (var day in data) {
          if (day.id.toString().contains("-" + Month + "-")) {
            print(day.id);
            print(
                double.parse(day["all_day_stats"]["total_persons"].toString()));
            if (daysMap.containsKey(DateTime.parse(day.id.toString()))) {
              double old = daysMap[DateTime.parse(day.id.toString())]!;
              daysMap[DateTime.parse(day.id.toString())] = old +
                  double.parse(
                      day["all_day_stats"]["total_persons"].toString());
            } else {
              daysMap[DateTime.parse(day.id.toString())] = double.parse(
                  day["all_day_stats"]["total_persons"].toString());
            }
          }
        }
      } catch (e) {
        print("errorrrr " + e.toString());
      }
    }

    // print(hours.toString());
    return daysMap;
  }

  Future<Map<DateTime, double>> getDaysMonth(
      String gadgetId, String Month) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var data;
    Map<DateTime, double> daysMap = {};
    List<String> daysList = [];

    print(daysList);
    await db
        .collection('users')
        .doc(FirestoreService.userId)
        .collection('gadgets')
        .doc(gadgetId)
        .collection("days")
        .get()
        .then((doc) => {data = doc.docs.toList()});
    print(data);

    try {
      for (var day in data) {
        if (day.id.toString().contains("-" + Month + "-")) {
          print(day.id);

          daysMap[DateTime.parse(day.id.toString())] =
              double.parse(day["all_day_stats"]["total_persons"].toString());
        }
      }
    } catch (e) {
      print("errorrrr " + e.toString());
    }

    // print(hours.toString());
    return daysMap;
  }

  Future<List<String>> getDays(gadgetId) async {
    late List<String> days = [];
    FirebaseFirestore db = FirebaseFirestore.instance;

    var snapshot = await db
        .collection('users')
        .doc(FirestoreService.userId)
        .collection('gadgets')
        .doc(gadgetId)
        .collection("days")
        .get();
    for (var item in snapshot.docs.toList()) {
      days.add(item.id.toString());
    }

    print(days);
    print("daysssssssssssssssssssssssssssssssss");
    return days;
  }

  // Future<String> getNotification() {

  // }

  /*Future<void> sendFile(String notificationType, String filePath) async {
    final file = File(filePath);
    // Create the file metadata
    final metadata = SettableMetadata(contentType: "image/jpeg");
    // Create a reference to the Firebase Storage bucket
    final storageRef = FirebaseStorage.instance.ref();
    // Upload file and metadata to the path 'images/mountains.jpg'
    final uploadTask = storageRef
        .child("images/path/to/mountains.jpg")
        .putFile(file, metadata);

    // Listen for state changes, errors, and completion of the upload.
    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          print("Upload is $progress% complete.");
          break;
        case TaskState.paused:
          print("Upload is paused.");
          break;
        case TaskState.canceled:
          print("Upload was canceled");
          break;
        case TaskState.error:
          // Handle unsuccessful uploads
          break;
        case TaskState.success:
          // Handle successful uploads on complete
          // ...
          break;
      }
    });

    // String fileUrl =
    //     await storageRef.child("images/path/to/mountains.jpg").getDownloadURL();

    // FirebaseFirestore db = FirebaseFirestore.instance;
    // DocumentReference patientRef = db.collection('rooms').doc(userId);

    // patientRef.update({'files': fileUrl});
  }*/
}
