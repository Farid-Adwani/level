import 'package:Aerobotix/HomeScreen/Aerobotix_app_theme.dart';
import 'package:Aerobotix/HomeScreen/ui_view/GlassTextView.dart';
import 'package:Aerobotix/HomeScreen/ui_view/body_measurement.dart';
import 'package:Aerobotix/HomeScreen/ui_view/glass_view.dart';
import 'package:Aerobotix/HomeScreen/ui_view/mediterranean_diet_view.dart';
import 'package:Aerobotix/HomeScreen/ui_view/detailsView.dart';
import 'package:Aerobotix/HomeScreen/ui_view/photoView.dart';
import 'package:Aerobotix/HomeScreen/ui_view/title_view.dart';
import 'package:Aerobotix/HomeScreen/my_diary/water_view.dart';
import 'package:Aerobotix/model/member.dart';
import 'package:Aerobotix/screens/missionsScreen.dart';
import 'package:Aerobotix/services/firebase_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:status_view/status_view.dart';

class MyDiaryScreen extends StatefulWidget {
  const MyDiaryScreen({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _MyDiaryScreenState createState() => _MyDiaryScreenState();
}

class _MyDiaryScreenState extends State<MyDiaryScreen>
    with TickerProviderStateMixin {
   final db = FirebaseFirestore.instance;   
 AnimationController? animationController;
int missionNum=0;
  Animation<double>? topBarAnimation;
  late ConfettiController _controllerCenter;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  void initState() {


 animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 1));
    _controllerCenter.play();

    addAllListData();

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
    const int count = 9;
    listViews.add(
      PhotoView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
    listViews.add(
      GlassTextView(
        field: "first_name",
        ratio: 1.1,
        text: Member.first_name,
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
    listViews.add(
      GlassTextView(
        field: "last_name",

        ratio: 1.5,
        text: Member.last_name,
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
    listViews.add(
      GlassTextView(
        field: "branch",

        ratio: 2.5,
        text: Member.branch,
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                Interval((1 / count) * 6, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
    listViews.add(
      GlassTextView(
        field: "level",

        ratio: 5,
        text: Member.level.toString(),
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                Interval((1 / count) * 7, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );

    listViews.add(
      TitleView(
        titleTxt: 'Level',
        subTxt: 'Details',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
    listViews.add(
      MediterranesnDietView(
        xp:Member.xp,
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );

      listViews.add(
      GlassView(
          date: "",
          text: "Badges",
          photo: "badge2.png",
          phone: Member.phone,

          animation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: widget.animationController!,
                  curve: Interval((1 / count) * 7, 1.0,
                      curve: Curves.fastOutSlowIn))),
          animationController: widget.animationController!),
    );

    listViews.add(
      GlassView(
          date: Member.birthDate.day.toString() +
              "-" +
              Member.birthDate.month.toString() +
              "-" +
              Member.birthDate.year.toString(),
          text: "Birth Date : ",
          photo: "birthdate.png",
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: widget.animationController!,
                  curve: Interval((1 / count) * 7, 1.0,
                      curve: Curves.fastOutSlowIn))),
          animationController: widget.animationController!),
    );
    listViews.add(
      GlassView(
          date: (DateTime.now().year-Member.entryYear).toString()+
              " Years",
          text: "Experience : ",
          photo: "aerDate.png",
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: widget.animationController!,
                  curve: Interval((1 / count) * 8, 1.0,
                      curve: Curves.fastOutSlowIn))),
          animationController: widget.animationController!),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

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
            getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            shrinkWrap: true,
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController?.forward();

              return listViews[index];
            },
          );
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
                    color: AerobotixAppTheme.background,
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
                                  'Profile',
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
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Stack(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              print("missions");
                                               Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  missionsScreen(animationController: animationController)),
  );
                                            },
                                            icon: Icon(
                                              Icons.task_alt_sharp,
                                              color: AerobotixAppTheme.grey,
                                              size: 30,
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            child: 
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.red
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child:
                     
                     StreamBuilder<QuerySnapshot>(
      stream: db.collection('missions').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          missionNum=0;
          for (var element in snapshot.data!.docs) {
            if(element.get("state")=="new"){
              missionNum++;
            }
          }
          return Text(missionNum.toString(),style: TextStyle(fontSize: 10));
        }else{
          return Text("0");
        }
      },

                                              
                                              //  Text(missionNum.toString(),style: TextStyle(fontSize: 10),),
                                            ),
                                          )
                                          )
                                          )
                                        ],
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: IconButton(
                                        onPressed: () {
                                          FirestoreService.disconnect(
                                              Member.phone, context);
                                        },
                                        icon: Icon(
                                          Icons.logout_rounded,
                                          color: AerobotixAppTheme.grey,
                                          size: 30,
                                        ),
                                      )),
                                ],
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
