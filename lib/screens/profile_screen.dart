import 'package:Aerobotix/model/member.dart';
import 'package:Aerobotix/screens/profile_screen.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:Aerobotix/screens/gadget_screen.dart';
import 'package:Aerobotix/services/firebase_service.dart';
import 'package:Aerobotix/utils/helpers.dart';
import 'package:Aerobotix/widgets/custom_loader.dart';
import 'package:Aerobotix/widgets/pin_input_field.dart';
import 'package:gender_picker/source/enums.dart';

class ProfileScreen extends StatefulWidget {
  static const id = 'ProfileScreen';

  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String netIm = "wait";
  void getIm() async {
    netIm = await FirestoreService.getImage(
        "profiles/" + Member.phone + "/profile/" , Member.photo);
    setState(() {});
  }

  @override
  void initState() {
    getIm();
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        leading: const SizedBox.shrink(),
        title: const Text('Profile'),
        actions: [],
      ),
      body: Center(
        // padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CircleAvatar(
                radius: MediaQuery.of(context).size.width / 2.5,
                backgroundColor: Colors.white,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: netIm != "wait"
                      ? netIm.isNotEmpty
                          ? Image.network(netIm,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width,
                              fit: BoxFit.fill)
                          : Member.gender == Gender.Female
                              ? Image.asset(
                                  "assets/images/gadget2.jpg",
                                )
                              : Image.asset(
                                  "assets/images/gadget4.jpg",
                                )
                      : CircularProgressIndicator(),
                )),
            const SizedBox(height: 10),
            Center(
              child: Text(Member.first_name + " " + Member.last_name,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Center(
              child: Text(
                "☎️ : " + Member.phone.replaceFirst("+216", ""),
                style: const TextStyle(fontSize: 25),
              ),
            ),
         
            ],
        ),
      ),
    );
  }
}
