import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Aerobotix/screens/daily.dart';
import 'package:Aerobotix/screens/female_screen.dart';
import 'package:Aerobotix/screens/male_screen.dart';
import 'package:Aerobotix/services/firebase_service.dart';
import 'package:Aerobotix/model/profiles.dart';
import 'package:Aerobotix/ui/common/profile_summary.dart';

class PeopleScreen extends StatefulWidget {
  static const id = 'PeopleScreen';

  const PeopleScreen();

  @override
  State<PeopleScreen> createState() => _PeopleScreen();
}

class _PeopleScreen extends State<PeopleScreen> {
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
    updateDay();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     Function onTapFunctionP = () {
      Navigator.pushNamed(context, DailyPage.id);
    };
    Function onTapFunctionF = () {
      Navigator.pushNamed(context, FemaleScreen.id);
    };
    Function onTapFunctionM = () {
      Navigator.pushNamed(context, MaleScreen.id);
    };
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        color: const Color(0xFF736AB7),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: _getContent(Profile.Profiles["people"], onTapFunctionP, true)),
            Expanded(
                child: _getContent(
                    Profile.Profiles["female"], onTapFunctionF, false)),
            Expanded(
                child: _getContent(
                    Profile.Profiles["male"], onTapFunctionM, false)),
          ],
        ),
      ),
    );
  }

  Container _getContent(profile, onTapFunction, peopleCard) {
    final _overviewTitle = "Overview".toUpperCase();
    return Container(
      child: GestureDetector(
        onTap: onTapFunction,
        child: ListView(
          children: <Widget>[
            ProfileSummary(
              profile,
              peopleCard,
              horizontal: false,
            ),
          ],
        ),
      ),
    );
  }
}
