import 'package:Aerobotix/HomeScreen/Aerobotix_app_theme.dart';
import 'package:Aerobotix/HomeScreen/models/tabIcon_data.dart';
import 'package:Aerobotix/HomeScreen/training/training_screen.dart';
import 'package:Aerobotix/screens/AllMembers.dart';
import 'package:Aerobotix/screens/leaderboard.dart';
import 'package:Aerobotix/screens/musicScreen.dart';
import 'package:flutter/material.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';

import 'my_diary/my_diary_screen.dart';

class AerobotixAppHomeScreen extends StatefulWidget {
   static const id = 'SignUpScreen';
  @override
  _AerobotixAppHomeScreenState createState() => _AerobotixAppHomeScreenState();
}

class _AerobotixAppHomeScreenState extends State<AerobotixAppHomeScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: AerobotixAppTheme.background,
  );

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
   // tabIconsList[3].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = MyDiaryScreen(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AerobotixAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {
            setState(() {
                  tabBody =
                      MyDiaryScreen(animationController: animationController);
                    
                });
          },
          changeIndex: (int index) {
            if (index == 0  ) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                        leaderboardScreen(animationController: animationController);
                });
              });
            } else  if (index == 1  ) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      AllMembersScreen(animationController: animationController);
                });
              });
            }  else  if (index == 2  ) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =TrainingScreen(animationController: animationController);
                     
                });
              });
            } 
            else if (index == 3) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                   MusicScreen(animationController: animationController);
                });
              });
            }
          },
        ),
      ],
    );
  }
}
