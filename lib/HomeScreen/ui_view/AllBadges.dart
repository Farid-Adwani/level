import 'package:Aerobotix/HomeScreen/Aerobotix_app_theme.dart';
import 'package:Aerobotix/HomeScreen/ui_view/MaterialApproval.dart';
import 'package:Aerobotix/HomeScreen/ui_view/addMateriel.dart';
import 'package:Aerobotix/HomeScreen/ui_view/badges.dart';
import 'package:Aerobotix/HomeScreen/ui_view/materialList.dart';
import 'package:flutter/material.dart';

class AllBadgesScreen extends StatefulWidget {
  const AllBadgesScreen({Key? key}) : super(key: key);

  
  @override
  _AllBadgesScreenState createState() => _AllBadgesScreenState();
}

class _AllBadgesScreenState extends State<AllBadgesScreen>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {

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
                    Tab(icon: Icon(Icons.badge_outlined),text: "Badges"),
                    Tab(icon: Icon(Icons.military_tech_outlined),text: "Awards"),
                    Tab(icon: Icon(Icons.event),text: "Events"),
                    Tab(icon: Icon(Icons.lightbulb_outline_rounded),text: "Workshops"),

                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  BadgesScreen(type:"badges"),
                  BadgesScreen(type:"awards"),
                  BadgesScreen(type:"events"),
                  BadgesScreen(type:"workshops"),

                ],
              ),
            ),
          )
              ;
        }
      },
    );
  }

  }
