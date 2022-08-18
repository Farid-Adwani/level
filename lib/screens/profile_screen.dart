import 'package:Aerobotix/model/member.dart';
import 'package:Aerobotix/screens/profile_screen.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:Aerobotix/services/firebase_service.dart';
import 'package:Aerobotix/utils/helpers.dart';
import 'package:Aerobotix/widgets/custom_loader.dart';
import 'package:Aerobotix/widgets/pin_input_field.dart';
import 'package:gender_picker/source/enums.dart';
import 'dart:math';

class ProfileScreen extends StatefulWidget {
  static const id = 'ProfileScreen';

  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ConfettiController _controllerCenter;
  String netIm = "wait";
  void getIm() async {
    netIm = await FirestoreService.getImage(
        "profiles/" + Member.phone + "/profile/", Member.photo);
    setState(() {});
  }

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 1));
    _controllerCenter.play();
    getIm();
    super.initState();
  }

  bool tryingDisconnect = false;
  Text _display(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        leading: const SizedBox.shrink(),
        title: const Text('Profile'),
        actions: [
          IconButton(
              onPressed: () async {
                setState(() {
                  tryingDisconnect = true;
                });
                bool conn =
                    await FirestoreService.disconnect(Member.phone, context);
                if (conn == false) {
                  setState(() {
                    tryingDisconnect = false;
                  });
                }
              },
              icon: tryingDisconnect == true
                  ? CircularProgressIndicator()
                  : Icon(Icons.logout))
        ],
      ),
      body: Center(
        // padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ConfettiWidget(
              confettiController: _controllerCenter,
              blastDirectionality: BlastDirectionality
                  .explosive, // don't specify a direction, blast randomly
              shouldLoop:
                  false, // start again as soon as the animation is finished
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.red,
                Colors.blueAccent,
                Colors.yellow,
                Colors.black,
                Colors.white,
                Colors.pink,
                Colors.brown,
              ], // manually specify the colors to be used
              // createParticlePath: drawStar, // define a custom shape/path.
              emissionFrequency: 0.0001,
              gravity: 1,
              numberOfParticles: 200,
              minimumSize: Size(15, 15),
              maximumSize: Size(16, 16),
              particleDrag: 0.03,
            ),
           
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
