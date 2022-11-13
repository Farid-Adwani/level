import 'package:Aerobotix/HomeScreen/Aerobotix_app_home_screen.dart';
import 'package:Aerobotix/HomeScreen/Aerobotix_app_theme.dart';
import 'package:Aerobotix/HomeScreen/ui_view/wave_view.dart';
import 'package:Aerobotix/model/member.dart';
import 'package:Aerobotix/services/firebase_service.dart';
import 'package:Aerobotix/ui/HexColor.dart';
import 'package:Aerobotix/ui/text_style.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'dart:math' as math;

import 'package:glassmorphism/glassmorphism.dart';

class GlassTextView extends StatefulWidget {
  GlassTextView(
      {Key? key,
      this.animationController,
      this.animation,
      required this.text,
      required this.ratio,
      required this.field,
      this.other = const {}})
      : super(key: key);

  final AnimationController? animationController;
  final Animation<double>? animation;
  String text;
  double ratio;
  String field;
  Map<String, String> other;

  String? filedReset;
  @override
  State<GlassTextView> createState() => _GlassTextViewState();
}

class _GlassTextViewState extends State<GlassTextView> {
  bool edited = false;
  int level = 0;
  String filiere = "";
  List<bool> _isSelected = [false, false, false, false, false, false];
  List<bool> _isSelected2 = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  late AwesomeDialog ad;
  final _popKey = GlobalKey<FormState>();
  String fieldReset = "";
  bool popUp(context) {
    if (widget.field == "branch" || widget.field == "level") {
      setState(() {
        edited = true;
      });
      return true;
    }
    level = 0;
    ad = AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.INFO,
        body: Center(
          child: Column(
            children: [
              Center(
                  child: (widget.field == "first_name")
                      ? Text('Enter the new First Name',
                          style: Style.commonTextStyle)
                      : Text('Enter the new Last_name',
                          style: Style.commonTextStyle)),
              EasyContainer(
                key: _popKey,
                elevation: 0,
                borderRadius: 10,
                color: Colors.transparent,
                child: Form(
                  child: TextField(
                    textAlign: TextAlign.center,
                    autofocus: true,
                    textAlignVertical: TextAlignVertical.center,
                    style: Style.headerTextStyle,
                    onChanged: (text) => fieldReset = text,
                    keyboardType: TextInputType.text,
                  ),
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     IconButton(
              //       onPressed: () {
              //         FirestoreService.call();
              //         //launch("tel://21620671572");
              //       },
              //       icon:  Icon(Icons.call),
              //       iconSize: 50,
              //     ),
              //     IconButton(
              //       iconSize: 50,
              //       onPressed: () {
              //         FirestoreService.sms("+21620671572");
              //       },
              //       icon: Icon(Icons.sms),
              //     )
              //   ],
              // )
            ],
          ),
        ),
        btnOk: IconButton(
          iconSize: 50,
          onPressed: () async {
            //print(filedReset);

            await FirestoreService.setString(widget.field, fieldReset)
                .then((value) {
              FirestoreService.fetchUser(Member.phone).then((value) {
                setState(() {
                  print("waaaaa");
                });
                ad..dismiss();
              });
            });
          },
          icon: Icon(Icons.send),
        ));
    fieldReset = "";
    ad..show();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    String interpretedText = "";
    print("wwwwwwwwwwwwwwwwwwwwwwww");
    print(widget.other);
    if (widget.other.isNotEmpty) {
      switch (widget.field) {
        case "last_name":
          interpretedText = widget.other["last_name"]!;
          break;
        case "first_name":
          interpretedText = widget.other["first_name"]!;
          break;
        case "branch":
          interpretedText = widget.other["branch"]!;
          break;
        case "level":
          interpretedText = widget.other["level"]!;
          break;
        default:
      }
    } else {
      switch (widget.field) {
        case "last_name":
          interpretedText = Member.last_name;
          break;
        case "first_name":
          interpretedText = Member.first_name;
          break;
        case "branch":
          interpretedText = Member.branch;
          break;
        case "level":
          interpretedText = Member.level.toString();
          break;
        case "claim":
          interpretedText = widget.text;
          break;
          
        default:
      }
    }

    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation!.value), 0.0),
            child: Padding(
                padding: const EdgeInsets.only(
                    left: 24, right: 24, top: 0, bottom: 0),
                child: Column(
                  children: [
                    edited == true
                        ? widget.field == "branch"
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ToggleButtons(
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width /
                                                13,
                                        minWidth:
                                            MediaQuery.of(context).size.width /
                                                13,
                                        maxHeight:
                                            MediaQuery.of(context).size.width /
                                                10,
                                        minHeight:
                                            MediaQuery.of(context).size.width /
                                                10),

                                    children: <Widget>[
                                      Text("MPI"),
                                      Text("CBA"),
                                      Text("IIA"),
                                      Text("IMI"),
                                      Text("GL"),
                                      Text("RT"),
                                      Text("BIO"),
                                      Text("CH"),
                                    ],

                                    isSelected: _isSelected2,

                                    onPressed: (int index) {
                                      setState(() {
                                        _isSelected2 = [
                                          false,
                                          false,
                                          false,
                                          false,
                                          false,
                                          false,
                                          false,
                                          false
                                        ];
                                        _isSelected2[index] =
                                            !_isSelected2[index];
                                        switch (index) {
                                          case 0:
                                            filiere = "MPI";
                                            break;
                                          case 1:
                                            filiere = "CBA";
                                            break;
                                          case 2:
                                            filiere = "IIA";
                                            break;
                                          case 3:
                                            filiere = "IMI";
                                            break;
                                          case 4:
                                            filiere = "GL";
                                            break;
                                          case 5:
                                            filiere = "RT";
                                            break;
                                          case 6:
                                            filiere = "BIO";
                                            break;
                                          case 7:
                                            filiere = "CH";
                                            break;

                                          default:
                                        }
                                      });
                                    },

                                    // region example 1

                                    color: Colors.grey,

                                    selectedColor: Colors.red,

                                    fillColor: Colors.lightBlueAccent,

                                    // endregion

                                    // region example 2

                                    borderColor: Colors.lightBlueAccent,

                                    selectedBorderColor: Colors.red,

                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),

                                    // endregion
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        setState(() {
                                          edited = false;
                                        });
                                        await FirestoreService.setString(
                                                widget.field, filiere)
                                            .then((value) {
                                          FirestoreService.fetchUser(
                                                  Member.phone)
                                              .then((value) {
                                            setState(() {
                                              print("waaaaa");
                                            });
                                          });
                                        });
                                      },
                                      icon: Icon(Icons.send))
                                ],
                              )
                            : Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ToggleButtons(
                                      constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              10,
                                          minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              10,
                                          maxHeight: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              10,
                                          minHeight: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              10),
                                      children: <Widget>[
                                        Text("1"),
                                        Text("2"),
                                        Text("3"),
                                        Text("4"),
                                        Text("5"),
                                        Text("5+"),
                                      ],

                                      isSelected: _isSelected,

                                      onPressed: (int index) {
                                        setState(() {
                                          _isSelected = [
                                            false,
                                            false,
                                            false,
                                            false,
                                            false,
                                            false,
                                          ];
                                          _isSelected[index] =
                                              !_isSelected[index];
                                          switch (index) {
                                            case 0:
                                              level = 1;
                                              break;
                                            case 1:
                                              level = 2;
                                              break;
                                            case 2:
                                              level = 3;
                                              break;
                                            case 3:
                                              level = 4;
                                              break;
                                            case 4:
                                              level = 5;
                                              break;
                                            case 5:
                                              level = 6;
                                              break;
                                            default:
                                          }
                                        });
                                      },

                                      // region example 1

                                      color: Colors.grey,

                                      selectedColor: Colors.red,

                                      fillColor: Colors.lightBlueAccent,

                                      // endregion

                                      // region example 2

                                      borderColor: Colors.lightBlueAccent,

                                      selectedBorderColor: Colors.red,

                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),

                                      // endregion
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          setState(() {
                                            edited = false;
                                          });
                                          await FirestoreService.setlevel(
                                                  widget.field, level)
                                              .then((value) {
                                            FirestoreService.fetchUser(
                                                    Member.phone)
                                                .then((value) {
                                              setState(() {
                                                print("waaaaa");
                                              });
                                            });
                                          });
                                        },
                                        icon: Icon(Icons.send))
                                  ],
                                ),
                              )
                        : GestureDetector(
                          onTap: (){
                            FirestoreService.setXp({"phone":Member.phone,"gameLevel":Member.gameLevel,"xp":Member.xp.toString()}, Member.claim).then((value) {
                              FirestoreService.resetClaim(Member.phone);
                               Navigator
                                                      .pushReplacementNamed(
                                                    context,
                                                    AerobotixAppHomeScreen.id,
                                                  );
                                                  
                            });
                          },
                          child: GlassmorphicContainer(
                              width: MediaQuery.of(context).size.width /
                                  widget.ratio,
                              height: MediaQuery.of(context).size.width / 9,
                              borderRadius: 20,
                              blur: 20,
                              alignment: Alignment.bottomCenter,
                              border: 2,
                              linearGradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: widget.field == "claim"
                                      ? [
                                          Color.fromARGB(255, 192, 204, 23).withOpacity(0.1),
                                          Color.fromARGB(255, 255, 252, 62).withOpacity(0.05),
                                        ]
                                      : [
                                          Color(0xFFffffff).withOpacity(0.1),
                                          Color(0xFFFFFFFF).withOpacity(0.05),
                                        ],
                                  stops: [
                                    0.1,
                                    1,
                                  ]),
                              borderGradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors:widget.field == "claim" ?
                                
                                [
                                  Color.fromARGB(255, 208, 211, 13)
                                      .withOpacity(0.5),
                                  Color((0xFFFFFFFF)).withOpacity(0.5),
                                ]: [
                                  Color.fromARGB(255, 165, 26, 26)
                                      .withOpacity(0.5),
                                  Color((0xFFFFFFFF)).withOpacity(0.5),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child:
                                          Center(child: Text(interpretedText))),
                                  if (widget.other.isEmpty &&
                                      widget.field != "claim")
                                    IconButton(
                                        onPressed: () {
                                          popUp(context);
                                        },
                                        icon: Icon(Icons.edit))
                                ],
                              ),
                            ),
                        ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 150,
                    ),
                  ],
                )),
          ),
        );
      },
    );
  }
}
