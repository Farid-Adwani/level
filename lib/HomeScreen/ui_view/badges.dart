import 'dart:math';
import 'package:Aerobotix/HomeScreen/Aerobotix_app_theme.dart';
import 'package:Aerobotix/model/member.dart';
import 'package:Aerobotix/services/firebase_service.dart';
import 'package:Aerobotix/ui/HexColor.dart';
import 'package:Aerobotix/ui/text_style.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:gender_picker/source/enums.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:Aerobotix/utils/helpers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class BadgesScreen extends StatefulWidget {
  BadgesScreen({Key? key, required this.type}) : super(key: key);
  String type;

  @override
  State<BadgesScreen> createState() => _BadgesScreenState();
}

class _BadgesScreenState extends State<BadgesScreen> {
  String netIm = "";
  String search = "";
  Color shadow = Colors.white;
  List<Color> gradient = [Colors.red, Colors.black];
  String photo = "assets/HomeScreen/dinner.png";
  final db = FirebaseFirestore.instance;

  Widget allWidgets(context, state) {
    int index = 0;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          Wrap(
              alignment: WrapAlignment.center,
              children: Member.badges.map((doc) {
                 
                if (doc["type"] == "mecanique") {
                  gradient = [
                    Colors.orange,
                    Color.fromARGB(255, 0, 0, 55),
                    Color.fromARGB(255, 0, 0, 55),
                  ];
                  shadow = Colors.white;
                  photo = "assets/images/badges/mecanique.png";
                }
                if (doc["type"] == "software") {
                  gradient = [
                    Colors.orange,
                    Colors.purple[900]!,
                    Colors.purple[900]!,
                  ];
                  shadow = Colors.white;
                  photo = "assets/images/badges/software.png";
                }

                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 32, left: 8, right: 8, bottom: 16),
                      child: Container(
                        // width: MediaQuery.of(context).size.width/3,

                        decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: shadow.withOpacity(0.6),
                                offset: const Offset(1.1, 4.0),
                                blurRadius: 8.0),
                          ],
                          gradient: LinearGradient(
                            colors: gradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(54.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 54, left: 16, right: 16, bottom: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                doc["title"].replaceAll(" ", "\n"),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AerobotixAppTheme.fontName,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  letterSpacing: 0.2,
                                  color: AerobotixAppTheme.white,
                                ),
                              ),
                              Text(
                                doc["date"],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AerobotixAppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  letterSpacing: 0.2,
                                  color: AerobotixAppTheme.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          color: AerobotixAppTheme.nearlyWhite.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 3,
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.asset(photo),
                      ),
                    )
                  ],
                );
              }).toList()),
        ],
      ),
    );

    //   Padding(
    //   padding: const EdgeInsets.all(30.0),
    //   child: Center(
    //     child: Text(
    //                       "That's All 🚫 !",
    //                       style: TextStyle(
    //                         fontSize: 20
    //                       ),
    //                      ),
    //   ),
    // )
  }

  @override
  Widget build(BuildContext context) {
    return allWidgets(context, widget.type);
  }
}
