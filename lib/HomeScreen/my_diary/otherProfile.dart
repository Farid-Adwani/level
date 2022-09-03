import 'package:Aerobotix/HomeScreen/Aerobotix_app_theme.dart';
import 'package:Aerobotix/HomeScreen/ui_view/GlassTextView.dart';
import 'package:Aerobotix/HomeScreen/ui_view/body_measurement.dart';
import 'package:Aerobotix/HomeScreen/ui_view/glass_view.dart';
import 'package:Aerobotix/HomeScreen/ui_view/mediterranean_diet_view.dart';
import 'package:Aerobotix/HomeScreen/ui_view/detailsView.dart';
import 'package:Aerobotix/HomeScreen/ui_view/photoView.dart';
import 'package:Aerobotix/HomeScreen/ui_view/title_view.dart';
import 'package:Aerobotix/HomeScreen/my_diary/meals_list_view.dart';
import 'package:Aerobotix/HomeScreen/my_diary/water_view.dart';
import 'package:Aerobotix/model/member.dart';
import 'package:Aerobotix/services/firebase_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:status_view/status_view.dart';

class OtherProfile extends StatefulWidget {
  const OtherProfile({Key? key}) : super(key: key);

  @override
  _OtherProfileState createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;
  late ConfettiController _controllerCenter;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  late AnimationController? animationController;

  Map<String, String> user = {};

  Future<void> getUser() async {
    user = await FirestoreService.getOtherUser(Member.otherPhone).then((value) {
      setState(() {});
      return value;
    });
  }

  void initState() {
    user = {};

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    getUser();
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 1));
    _controllerCenter.play();

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

  void addAllListData() {
    print(user);
    print("waaaaaaaaaaaaaaaaaaa");
    const int count = 9;
    listViews.add(
      PhotoView(
        other: user,
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController!,
            curve:
                Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: animationController!,
      ),
    );
    listViews.add(
      GlassTextView(
        other: user,
        field: "first_name",
        ratio: 1.1,
        text: Member.first_name,
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController!,
            curve:
                Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: animationController!,
      ),
    );
    listViews.add(
      GlassTextView(
        other: user,
        field: "last_name",
        ratio: 1.5,
        text: Member.last_name,
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController!,
            curve:
                Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: animationController!,
      ),
    );
    listViews.add(
      GlassTextView(
        other: user,
        field: "branch",
        ratio: 2.5,
        text: Member.branch,
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController!,
            curve:
                Interval((1 / count) * 6, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: animationController!,
      ),
    );
    listViews.add(
      GlassTextView(
        other: user,
        field: "level",
        ratio: 5,
        text: Member.level.toString(),
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController!,
            curve:
                Interval((1 / count) * 7, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: animationController!,
      ),
    );
    listViews.add(
      TitleView(
        titleTxt: 'Level',
        subTxt: 'Details',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController!,
            curve:
                Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: animationController!,
      ),
    );
    listViews.add(
      MediterranesnDietView(
        xp: double.parse(user["xp"].toString()).toInt(),
        other: user,
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController!,
            curve:
                Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: animationController!,
      ),
    );

    listViews.add(
      GlassView(
          date: user["birth_date"]!,
          text: "Birth Date : ",
          photo: "birthdate.png",
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: animationController!,
                  curve: Interval((1 / count) * 7, 1.0,
                      curve: Curves.fastOutSlowIn))),
          animationController: animationController!),
    );
    listViews.add(
      GlassView(
          date: (DateTime.now().year - Member.entryYear).toString() + " Years",
          text: "Experience : ",
          photo: "aerDate.png",
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: animationController!,
                  curve: Interval((1 / count) * 8, 1.0,
                      curve: Curves.fastOutSlowIn))),
          animationController: animationController!),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  bool loading = false;
  int toAdd = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AerobotixAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
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
            user.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView(
                    children: [
                      getMainListViewUI(),
                      AnimatedBuilder(
                        animation: animationController!,
                        builder: (BuildContext context, Widget? child) {
                          return FadeTransition(
                            opacity: Tween<double>(begin: 0.0, end: 1.0)
                                .animate(CurvedAnimation(
                                    parent: animationController!,
                                    curve: Interval((1 / 9) * 8, 1.0,
                                        curve: Curves.fastOutSlowIn))),
                            child: new Transform(
                                transform: new Matrix4.translationValues(
                                    0.0,
                                    30 *
                                        (1.0 -
                                            Tween<double>(begin: 0.0, end: 1.0)
                                                .animate(CurvedAnimation(
                                                    parent:
                                                        animationController!,
                                                    curve: Interval(
                                                        (1 / 9) * 8, 1.0,
                                                        curve: Curves
                                                            .fastOutSlowIn)))
                                                .value),
                                    0.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onLongPress: () {
                                        setState(() {
                                          toAdd = toAdd - 100;
                                        });
                                      },
                                      child: IconButton(
                                          iconSize: 40,
                                          onPressed: () {
                                            setState(() {
                                              toAdd = toAdd - 10;
                                            });
                                          },
                                          icon: Icon(Icons.remove)),
                                    ),
                                    Text(toAdd.toString(),
                                        style: TextStyle(fontSize: 25)),
                                    GestureDetector(
                                      onLongPress: () {
                                        setState(() {
                                          toAdd = toAdd + 100;
                                        });
                                      },
                                      child: IconButton(
                                          iconSize: 40,
                                          onPressed: () {
                                            setState(() {
                                              toAdd = toAdd + 10;
                                            });
                                          },
                                          icon: Icon(Icons.add)),
                                    ),
                                    loading == false
                                        ? IconButton(
                                            iconSize: 40,
                                            onPressed: () async {
                                              setState(() {
                                                loading = true;
                                              });
                                              await FirestoreService.setXp(
                                                      user, toAdd)
                                                  .timeout(Duration(seconds: 6))
                                                  .then((value) {
                                                setState(() {
                                                  loading = false;
                                                });
                                                if (value) {
                                                  Navigator
                                                      .pushReplacementNamed(
                                                    context,
                                                    "/otherProfile",
                                                  );
                                                }
                                                // Navigator.push(context, "/otherProfile");
                                              });
                                            },
                                            icon: Icon(Icons.send))
                                        : CircularProgressIndicator()
                                  ],
                                )),
                          );
                        },
                      )
                    ],
                  ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    listViews = [];
    addAllListData();
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            shrinkWrap: true,
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              animationController?.forward();

              return listViews[index];
            },
          );
        }
      },
    );
  }
}
