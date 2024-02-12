import 'dart:ui';

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
  int level = 0;
  bool edit = false;
  String branchChoice = Member.branch;
  String levelChoice = Member.level.toString();
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
  TextEditingController _controller = new TextEditingController();

  late AwesomeDialog ad;
  final _popKey = GlobalKey<FormState>();
  String fieldReset = "";
  bool popUp(context) {
    _controller.text = widget.text;

    print(widget.text);
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
                    controller: _controller,
                    textAlign: TextAlign.center,
                    autofocus: true,
                    textAlignVertical: TextAlignVertical.center,
                    style: Style.headerTextStyle,
                    onChanged: (text) => fieldReset = text,
                    keyboardType: TextInputType.text,
                  ),
                ),
              ),
            ],
          ),
        ),
        btnOk: IconButton(
          iconSize: 50,
          onPressed: () async {
            await FirestoreService.setString(widget.field, fieldReset)
                .then((value) {
              FirestoreService.fetchUser(Member.phone).then((value) {
                setState(() {});
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
    if (widget.other.isNotEmpty) {
      switch (widget.field) {
        case "last_name":
          interpretedText = widget.other["last_name"]!;
          break;
        case "first_name":
          interpretedText = widget.other["first_name"]!;
          break;
        case "class":
          interpretedText = widget.other["branch"]! + widget.other["level"]!;
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
        case "class":
          interpretedText = Member.level == 6
              ? Member.branch + interpretedText + "5+"
              : Member.branch + interpretedText + Member.level.toString();
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
                child: edit == false
                    ? GestureDetector(
                        onTap: () {
                          if (widget.other.isEmpty) {
                            if (widget.field == "claim") {
                              FirestoreService.setXp({
                                "phone": Member.phone,
                                "gameLevel": Member.gameLevel,
                                "xp": Member.xp.toString()
                              }, Member.claim)
                                  .then((value) {
                                FirestoreService.resetClaim(Member.phone);
                                Navigator.pushReplacementNamed(
                                  context,
                                  AerobotixAppHomeScreen.id,
                                );
                              });
                            } else if (widget.field != "class") {
                              popUp(context);
                            } else {
                              setState(() {
                                edit = true;
                              });
                            }
                          }
                        },
                        child: widget.field == "claim"
                            ? GlassmorphicContainer(
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
                                    colors: [
                                      Color.fromARGB(255, 192, 204, 23)
                                          .withOpacity(0.1),
                                      Color.fromARGB(255, 255, 252, 62)
                                          .withOpacity(0.05),
                                    ],
                                    stops: [
                                      0.1,
                                      1,
                                    ]),
                                borderGradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color.fromARGB(255, 208, 211, 13)
                                        .withOpacity(0.5),
                                    Color((0xFFFFFFFF)).withOpacity(0.5),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: Center(
                                            child: Text(
                                      interpretedText,
                                    ))),
                                  ],
                                ),
                              )
                            : Text(
                                interpretedText,
                                overflow: TextOverflow.ellipsis,
                                style: widget.field != "class"
                                    ? TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      )
                                    : TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        color: AerobotixAppTheme.grey),
                              ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton(
                              dropdownColor: AerobotixAppTheme.background,
                              value: branchChoice,
                              items: [
                                DropdownMenuItem(
                                  child: Text('MPI'),
                                  value: 'MPI',
                                ),
                                DropdownMenuItem(
                                  child: Text('CBA'),
                                  value: 'CBA',
                                ),
                                DropdownMenuItem(
                                  child: Text('GL'),
                                  value: 'GL',
                                ),
                                DropdownMenuItem(
                                  child: Text('RT'),
                                  value: 'RT',
                                ),
                                DropdownMenuItem(
                                  child: Text('IIA'),
                                  value: 'IIA',
                                ),
                                DropdownMenuItem(
                                  child: Text('IMI'),
                                  value: 'IMI',
                                ),
                                DropdownMenuItem(
                                  child: Text('CH'),
                                  value: 'CH',
                                ),
                                DropdownMenuItem(
                                  child: Text('BIO'),
                                  value: 'BIO',
                                ),
                              ],
                              onChanged: (String? value) {
                                setState(() {
                                  branchChoice = value!;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton(
                              dropdownColor: AerobotixAppTheme.background,
                              value: levelChoice,
                              items: [
                                DropdownMenuItem(
                                  child: Text('1'),
                                  value: '1',
                                ),
                                DropdownMenuItem(
                                  child: Text('2'),
                                  value: '2',
                                ),
                                DropdownMenuItem(
                                  child: Text('3'),
                                  value: '3',
                                ),
                                DropdownMenuItem(
                                  child: Text('4'),
                                  value: '4',
                                ),
                                DropdownMenuItem(
                                  child: Text('5'),
                                  value: '5',
                                ),
                                DropdownMenuItem(
                                  child: Text('5+'),
                                  value: '6',
                                ),
                              ],
                              onChanged: (String? value) {
                                setState(() {
                                  levelChoice = value!;
                                });
                              },
                            ),
                          ),
                          IconButton(
                              onPressed: () async {
                                setState(() {
                                  edit = false;
                                });
                                await FirestoreService.setString(
                                        "branch", branchChoice)
                                    .then((value) {
                                  FirestoreService.fetchUser(Member.phone)
                                      .then((value) {
                                    setState(() {});
                                  });
                                });
                                await FirestoreService.setlevel(
                                        "level", int.parse(levelChoice))
                                    .then((value) {
                                  FirestoreService.fetchUser(Member.phone)
                                      .then((value) {
                                    setState(() {});
                                  });
                                });
                              },
                              icon: Icon(Icons.send))
                        ],
                      )));
      },
    );
  }
}
