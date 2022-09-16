import 'package:Aerobotix/HomeScreen/Aerobotix_app_theme.dart';
import 'package:Aerobotix/HomeScreen/ui_view/MaterialApproval.dart';
import 'package:Aerobotix/HomeScreen/ui_view/addMateriel.dart';
import 'package:Aerobotix/HomeScreen/ui_view/addMission.dart';
import 'package:Aerobotix/HomeScreen/ui_view/materialList.dart';
import 'package:Aerobotix/HomeScreen/ui_view/missionsApproval.dart';
import 'package:Aerobotix/HomeScreen/ui_view/missionsList.dart';
import 'package:flutter/material.dart';

class missionsScreen extends StatefulWidget {
  const missionsScreen({Key? key, required this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _missionsScreenState createState() => _missionsScreenState();
}

class _missionsScreenState extends State<missionsScreen>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AerobotixAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
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
          return DefaultTabController(
            length: 4,
            child: Scaffold(
              appBar: AppBar(
                bottom: const TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.add_box_outlined)),
                    Tab(icon: Icon(Icons.fiber_new_rounded)),
                    Tab(icon: Icon(Icons.highlight_remove_rounded)),
                    Tab(icon: Icon(Icons.done_all_outlined)),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  AddMission(),
                  MissionsList(animationController: widget.animationController,categ: ""),

                  MissionsList(animationController: widget.animationController,categ: "sub",),
                  MissionsList(animationController: widget.animationController,categ: "done",),

                ],
              ),
            ),
          )
              // child: ListView.builder(
              //   controller: scrollController,
              //   padding: EdgeInsets.only(
              //     top: AppBar().preferredSize.height +
              //         MediaQuery.of(context).padding.top +
              //         24,
              //     bottom: 62 + MediaQuery.of(context).padding.bottom,
              //   ),
              //   itemCount: listViews.length,
              //   scrollDirection: Axis.vertical,
              //   itemBuilder: (BuildContext context, int index) {
              //     widget.animationController?.forward();
              //     return listViews[index];
              //   },
              // ),

              ;
        }
      },
    );
  }
    }
