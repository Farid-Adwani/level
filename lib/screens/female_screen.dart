import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Aerobotix/services/firebase_service.dart';
import 'package:Aerobotix/model/profiles.dart';
import 'package:Aerobotix/ui/common/profile_summary.dart';

class FemaleScreen extends StatefulWidget {
  static const id = 'FemaleScreen';
  const FemaleScreen();

  @override
  State<FemaleScreen> createState() => _FemaleScreen();
}

class _FemaleScreen extends State<FemaleScreen> {
  void updateDay() async {
    FirestoreService fs = FirestoreService();
    FirestoreService.days = await fs.getDays(FirestoreService.gadget);
    print(FirestoreService.days);
    FirestoreService.selectedDay =
        FirestoreService.days[FirestoreService.days.length - 1];
    print(FirestoreService.selectedDay);
    FirebaseFirestore db = FirebaseFirestore.instance;
    print(FirestoreService.selectedDay);
    final gadgetsRef = FirebaseFirestore.instance
        .collection("users")
        .doc(FirestoreService.userId)
        .collection('gadgets')
        .doc(FirestoreService.gadget)
        .collection("days")
        .doc(FirestoreService.selectedDay);
    gadgetsRef.snapshots().listen((event) {
      var all_data = event.get("all_day_stats");
      print("all_data  : ${all_data}");
      print("end data");
      setState(() {
        Profile.data["total_persons"] = all_data["total_persons"];
        Profile.data["mkid"] = all_data["mkid"];
        Profile.data["fkid"] = all_data["fkid"];
        Profile.data["myoung"] = all_data["myoung"];
        Profile.data["fyoung"] = all_data["fyoung"];
        Profile.data["madult"] = all_data["madult"];
        Profile.data["fadult"] = all_data["fadult"];
        Profile.data["mold"] = all_data["mold"];
        Profile.data["fold"] = all_data["fold"];
      });
    });
  }

  @override
  void initState() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    updateDay();
    final gadgetsRef = FirebaseFirestore.instance
        .collection("users")
        .doc(FirestoreService.userId)
        .collection('gadgets')
        .doc(FirestoreService.gadget)
        .collection("days")
        .doc(FirestoreService.selectedDay);
    gadgetsRef.snapshots().listen((event) {
      var all_data = event.get("all_day_stats");
      print("all_data  : ${all_data}");
      print("end data");
      setState(() {
        Profile.data["total_persons"] = all_data["total_persons"];
        Profile.data["mkid"] = all_data["mkid"];
        Profile.data["fkid"] = all_data["fkid"];
        Profile.data["myoung"] = all_data["myoung"];
        Profile.data["fyoung"] = all_data["fyoung"];
        Profile.data["madult"] = all_data["madult"];
        Profile.data["fadult"] = all_data["fadult"];
        Profile.data["mold"] = all_data["mold"];
        Profile.data["fold"] = all_data["fold"];
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        color: const Color(0xFF736AB7),
        child: Container(
          margin: const EdgeInsets.only(top: 20, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(child: _getContent(Profile.Profiles["fkid"], () {})),
              Expanded(child: _getContent(Profile.Profiles["fyoung"], () {})),
              Expanded(child: _getContent(Profile.Profiles["fadult"], () {})),
              Expanded(child: _getContent(Profile.Profiles["fold"], () {})),
            ],
          ),
        ),
      ),
    );
  }

  Container _getContent(profile, onTapFunction) {
    final _overviewTitle = "Overview".toUpperCase();
    return Container(
      child: GestureDetector(
        onTap: onTapFunction,
        child: ListView(
          children: <Widget>[
            ProfileSummary(
              profile,
              false,
              horizontal: true,
            ),
          ],
        ),
      ),
    );
  }
}
