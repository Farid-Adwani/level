import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:Aerobotix/HomeScreen/Aerobotix_app_theme.dart';
import 'package:Aerobotix/model/member.dart';
import 'package:Aerobotix/services/firebase_service.dart';
import 'package:Aerobotix/ui/HexColor.dart';
import 'package:Aerobotix/utils/helpers.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_api/youtube_api.dart';
import 'package:html/parser.dart' as html;

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
              child: Text("3asfour"),
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
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          int i = 0;
          return SafeArea(
              child: searching == false
                  ? ListView(
                      children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(
                                child: Text(
                                  'Select a song 🎼',
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
                            TextField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.library_music),
                                border: OutlineInputBorder(),
                                hintText: 'Write your song',
                              ),
                              textAlign: TextAlign.center,
                              autofocus: true,
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (text) {
                                search = text;
                                print(search);
                              },
                              keyboardType: TextInputType.text,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      print("waaaaaaa");
                                      if(Member.roles.contains("music")){
                                      FirestoreService.playSong(
                                          Member.phone,
                                          "resume" +
                                              Random()
                                                  .nextInt(5000)
                                                  .toString());
                                    }
                                    else{
                                    showSnackBar("You don't have the permission !" ,col: Colors.red);
                                   }},
                                    icon: Icon(
                                        Icons.play_circle_outline_outlined,size: 40,)),
                                IconButton(
                                  onPressed: () async {
                                   if(Member.roles.contains("music")){
                                     print("lawwejjj");
                                    setState(() {
                                      searching = true;
                                    });
                                    
                                 
                                    try{
                                    videoResult = await ytApi.search(search);

                                    }catch(e){
                                          showSnackBar("No Result !" ,col: Colors.redAccent);
                                    }
                                    setState(() {
                                      searching = false;
                                    });
                                    print(videoResult);
                                   }else{
                                    showSnackBar("You don't have the permission !" ,col: Colors.red);
                                   }
                                  },
                                  icon: Icon(Icons.search, size: 40),
                                ),
                              ],
                            )
                          ] +
                          videoResult.map((e) {
                            i = i + 1;
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    print(e.url);
                                    FirestoreService.playSong(
                                        Member.phone, e.url);
                                  },
                                  child: Wrap(
                                    alignment: WrapAlignment.spaceBetween,
                                    direction: Axis.horizontal,
                                    children: [
                                      Text(i.toString() + " "),
                                      SingleChildScrollView(
                                          child: Text(e.title),
                                          scrollDirection: Axis.horizontal),
                                      Text(e.duration.toString()),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList() +
                          [
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Center(
                                  child: Text(
                                    "No more results 🚫 !",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 8,
                            )
                          ])
                  : ListView(children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Text(
                            'Select a song ',
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
                      TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.library_music),
                          border: OutlineInputBorder(),
                          hintText: 'Write your song',
                        ),
                        textAlign: TextAlign.center,
                        autofocus: true,
                        textAlignVertical: TextAlignVertical.center,
                        onChanged: (text) {
                          search = text;
                          print(search);
                        },
                        keyboardType: TextInputType.text,
                      ),
                      IconButton(
                        onPressed: () async {
                          print("lawwejjj");
                          setState(() {
                            searching = true;
                          });
                          try {
                            videoResult = await ytApi
                                .search(search)
                                .timeout(Duration(seconds: 7));
                          } on TimeoutException {
                            showSnackBar("Please enter valid data",
                                col: Colors.red);
                            print(videoResult);
                            setState(() {
                              searching = false;
                            });
                          } catch (e) {
                            showSnackBar(
                                "Please check your internet connection",
                                col: Colors.red);
                            print(videoResult);
                            setState(() {
                              searching = false;
                            });
                          }
                          setState(() {
                            searching = false;
                          });
                        },
                        icon: Icon(Icons.search, size: 40),
                      ),
                      Center(child: CircularProgressIndicator())
                    ]));
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
