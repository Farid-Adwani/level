import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:Aerobotix/HomeScreen/Aerobotix_app_theme.dart';
import 'package:Aerobotix/model/member.dart';
import 'package:Aerobotix/screens/missionsScreen.dart';
import 'package:Aerobotix/services/firebase_service.dart';
import 'package:Aerobotix/ui/HexColor.dart';
import 'package:Aerobotix/utils/helpers.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:html/parser.dart' as html;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  String search = "";
  String netIm = "wait";
  Map<String, String> imMap = {};
  void getIm(String phone, String photo) async {
    try {
      await FirestoreService.getImage("profiles/" + phone + "/profile/", photo)
          .then((value) {
        imMap[phone] = value;
      });
      setState(() {});
    } catch (e) {}
  }

  Color selectedColor = Colors.white; // Default color for the matrix cells
  List<List<Color>> matrixColors = List.generate(
    17,
    (_) => List.generate(7, (_) => Colors.black),
  );
  void applyColorToCell(int row, int col) {
    setState(() {
      matrixColors[row][col] = selectedColor;
    });
  }

  bool musicScreen = true;
  AudioPlayer player = AudioPlayer();
  late AwesomeDialog ad;
  bool popUp(context, String id) {
    ad = AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.INFO,
        body: Center(
          child: Column(
            children: [
              EasyContainer(
                elevation: 0,
                borderRadius: 10,
                color: Colors.transparent,
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                          Text(
                            "Enter the data",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.blue,
                            ),
                          ),
                          Divider(),
                        ] +
                        [
                          TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.score),
                              border: OutlineInputBorder(),
                              hintText: 'Write a score < 5000',
                            ),
                            textAlign: TextAlign.center,
                            autofocus: true,
                            textAlignVertical: TextAlignVertical.center,
                            onChanged: (text) => search = text,
                            keyboardType: TextInputType.numberWithOptions(
                                signed: false, decimal: true),
                          ),
                        ],
                  ),
                ),
              ),
            ],
          ),
        ),
        btnOk: Wrap(
          alignment: WrapAlignment.center,
          children: [
            TextButton(
              child: Text("Chrara"),
              onPressed: () async {
                ad..dismiss();
              },
            ),
          ],
        ));

    ad..show();
    return true;
  }

  static String key = 'AIzaSyCHnsrr2R6mpgcqVEnm0tl9Ytwpabo-f_Q';
  YoutubeAPI ytApi = new YoutubeAPI(key);
  List<YouTubeVideo> videoResult = [];
  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  bool searching = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        color: AerobotixAppTheme.background,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: <Widget>[
              getMainListViewUI(),
              getAppBarUI(),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ));
  }

  Widget getMainListViewUI() {
    // Function to show color picker
    void _openColorPicker(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Pick a color'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: selectedColor,
                onColorChanged: (color) {
                  setState(() => selectedColor = color);
                },
                showLabel: true,
                pickerAreaHeightPercent: 0.8,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Handle color selection completion if needed
                },
                child: const Text('Done'),
              ),
            ],
          );
        },
      );
    }

    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          int i = 0;
          return SafeArea(
              child: ListView(
                  children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                musicScreen
                                    ? 'Select a song'
                                    : 'Write to led matrix',
                                textAlign: TextAlign.left,
                                style: AerobotixAppTheme.headline,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.width / 6,
                            child: TextField(
                              decoration: InputDecoration(
                                prefix: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        musicScreen = !musicScreen;
                                      });
                                    },
                                    icon: Icon(
                                      musicScreen
                                          ? Icons.abc_outlined
                                          : Icons.library_music,
                                    )),
                                alignLabelWithHint: true,
                                suffix: IconButton(
                                    onPressed: () async {
                                      print("waaaaaaa");
                                      if (Member.roles.contains("music")) {
                                        if (missionsScreen == true) {
                                          FirestoreService.playSong(
                                              Member.phone,
                                              "resume" +
                                                  Random()
                                                      .nextInt(5000)
                                                      .toString(),
                                              "");
                                        } else {
                                          FirestoreService.showMessage(search);
                                        }
                                      } else {
                                        showSnackBar(
                                            "You don't have the permission !",
                                            col: Colors.red);
                                      }
                                    },
                                    icon: Icon(
                                      musicScreen
                                          ? Icons.play_circle_outline_outlined
                                          : Icons.send,
                                    )),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                hintText: musicScreen
                                    ? 'Write your song'
                                    : 'Write your message',
                              ),
                              textAlign: TextAlign.center,
                              autofocus: true,
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (text) {
                                search = text;
                                print(search);
                              },
                              onSubmitted: (s) async {
                                if (Member.roles.contains("music")) {
                                  print("lawwejjj");
                                  setState(() {
                                    searching = true;
                                  });

                                  if (musicScreen) {
                                    try {
                                      videoResult = await ytApi.search(s);
                                    } catch (e) {
                                      showSnackBar("No Result !",
                                          col: Colors.redAccent);
                                    }
                                  } else {}
                                  setState(() {
                                    searching = false;
                                  });
                                  print(videoResult);
                                } else {
                                  showSnackBar(
                                      "You don't have the permission !",
                                      col: Colors.red);
                                }
                              },
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ),
                      ] +
                      [
                        if (searching == true)
                          Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(child: CircularProgressIndicator()))
                      ] +
                      (musicScreen
                          ? videoResult.map((e) {
                              i = i + 1;
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: e.duration != null
                                    ? GestureDetector(
                                        onTap: () async {
                                          print(e.url);
                                          FirestoreService.playSong(
                                              Member.phone, e.url, e.title);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: AerobotixAppTheme.white,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15))),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.network(
                                                  e.thumbnail.small.url
                                                      .toString(),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      7,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      7,
                                                  fit: BoxFit.fill,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Image.asset(
                                                        "assets/images/music.jpg",
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            7,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            7,
                                                        fit: BoxFit.fill);
                                                  },
                                                ),
                                              ),
                                              Expanded(
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      e.title,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child:
                                                    Text(e.duration.toString()),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(),
                              );
                            }).toList()
                          : [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          _openColorPicker(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                        ),
                                        child: const Text('Pick a color'),
                                      ),
                                      SizedBox(
                                          width:
                                              10.0), // Add some space between button and square
                                      Container(
                                        width: 30.0,
                                        height: 30.0,
                                        decoration: BoxDecoration(
                                          color: selectedColor,
                                          borderRadius: BorderRadius.circular(
                                              5.0), // Set the border radius
                                          border: Border.all(
                                            color: Colors
                                                .white, // Specify the color of the border
                                            width:
                                                2.0, // Specify the width of the border
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            if (Member.roles
                                                .contains("music")) {
                                              FirestoreService.showMatrix(
                                                  matrixColors);
                                            } else {
                                              showSnackBar(
                                                  "You don't have the permission !",
                                                  col: Colors.red);
                                            }
                                          },
                                          icon: Icon(
                                            musicScreen
                                                ? Icons
                                                    .play_circle_outline_outlined
                                                : Icons.send,
                                          )),
                                    ],
                                  ),
                                ),
                              ] +
                              [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0,
                                      bottom: 0,
                                      right: 80,
                                      left: 80),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors
                                              .white, // Specify the color of the border
                                          width:
                                              2.0, // Specify the width of the border
                                        ),
                                      ),
                                      height: 17 *
                                              (MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      32 +
                                                  2) + // 2 is for margin
                                          ((17 - 1) *
                                              2), // Add extra space for vertical margins
                                      child: GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 7,
                                          childAspectRatio:
                                              1.0, // Adjust this for square cells
                                        ),
                                        itemCount: 17 * 7,
                                        itemBuilder: (context, index) {
                                          int row = index ~/ 7;
                                          int col = index % 7;

                                          return GestureDetector(
                                            onTap: () {
                                              print(
                                                  "Tapped on cell at row $row, column $col");
                                              applyColorToCell(row, col);
                                            },
                                            child: Container(
                                              margin: EdgeInsets.all(2.0),
                                              color: matrixColors[row][col],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ] +
                              [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 5,
                                  ),
                                )
                              ])));
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AerobotixAppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AerobotixAppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Material',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: AerobotixAppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: AerobotixAppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 38,
                              width: 38,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0)),
                                onTap: () {},
                                child: Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_left,
                                    color: AerobotixAppTheme.grey,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Icon(
                                      Icons.calendar_today,
                                      color: AerobotixAppTheme.grey,
                                      size: 18,
                                    ),
                                  ),
                                  Text(
                                    '15 May',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: AerobotixAppTheme.fontName,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                      letterSpacing: -0.2,
                                      color: AerobotixAppTheme.darkerText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 38,
                              width: 38,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0)),
                                onTap: () {},
                                child: Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_right,
                                    color: AerobotixAppTheme.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
