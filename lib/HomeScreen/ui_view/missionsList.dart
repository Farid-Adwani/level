import 'package:Aerobotix/HomeScreen/Aerobotix_app_theme.dart';
import 'package:Aerobotix/model/member.dart';
import 'package:Aerobotix/services/firebase_service.dart';
import 'package:Aerobotix/ui/HexColor.dart';
import 'package:Aerobotix/utils/helpers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';

class MissionsList extends StatefulWidget {
  MissionsList({Key? key, this.animationController, required this.categ}) : super(key: key);

  String categ="";
  final AnimationController? animationController;
  @override
  _MissionsListState createState() => _MissionsListState();
}

class _MissionsListState extends State<MissionsList>
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
      await FirestoreService.getImage("missions/", photo).then((value) {
        imMap[phone] = value;
      });
      setState(() {});
    } catch (e) {}
  }


List<String> names(List<dynamic> inn){
  List<String> l =[];
  for(int i=0; i<inn.length;i++){
    String e=inn[i];

     if(e.toString().split("~").length>1){
    l.add(e.toString().split("~")[1]);
    }else{
      l.add("nooo");
    }
  }
 

  return l;

}

List<String> phones(List<dynamic> inn){
  List<String> l =[];
  for(int i=0; i<inn.length;i++){
    String e=inn[i];
    l.add(e.toString().split("~")[0]);
  }

  return l;

}
  final db = FirebaseFirestore.instance;
  Widget missionsList(categories) {
    return StreamBuilder<QuerySnapshot>(
      stream: db.collection('missions').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          int index = 0;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                          Card(
                            margin: EdgeInsets.all(20),
                            child: TextFormField(
                              initialValue: search,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(),
                                hintText: 'Enter name of the component',
                              ),

                              onChanged: (value) {
                                setState(() {
                                  search = value.trim();
                                });
                              },
                              // maxLength: 20,
                              maxLines: 1,
                            ),
                          )
                        ] +
                        snapshot.data!.docs.map((doc) {
                          if (imMap.containsKey(doc.get("name")) == false) {
                            getIm(doc.get("name"), doc.get("photo"));
                          }
                          if ((categories == doc.get("state").toString() || (widget.categ=="sub" && phones(doc.get("members")).contains(Member.phone)) || (widget.categ=="done" && phones(doc.get("done")).contains(Member.phone))) &&
                              (search == "" ||
                                  doc
                                      .get("name")
                                      .toString()
                                      .toUpperCase()
                                      .contains(search.toUpperCase()))) {
                            index = index + 1;
                            return Card(
                              borderOnForeground: true,
                              // color: Color.fromARGB(255, 104, 45, 48),
                              elevation: 1000,
                              margin: EdgeInsets.all(8),
                              child: GestureDetector(
                                onLongPress: () {
                             
if(Member.roles.contains("admin")) {
                                  popUp(context, doc.get("name"),doc.get("members"),doc.get("done"),doc.get("score"));

}                                  // }
                                },
                                onTap: () {},
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.05,
                                        height:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          // border: Border.all(
                                          //     width: 5),
                                          // shape: BoxShape.circle,
                                          image: ((imMap.containsKey(
                                                          doc.get("name")) &&
                                                      imMap[doc.get("name")]
                                                          .toString()
                                                          .isNotEmpty) &&
                                                  imMap[doc.get("name")] !=
                                                      "wait")
                                              ? DecorationImage(
                                                  image: NetworkImage(
                                                    imMap[doc.get("name")]
                                                        .toString(),
                                                  ),
                                                  fit: BoxFit.fill)
                                              : imMap[doc.get("name")]
                                                      .toString()
                                                      .isEmpty
                                                  ? DecorationImage(
                                                      image: AssetImage(
                                                        "assets/images/mission.png",
                                                      ),
                                                      fit: BoxFit.fill)
                                                  : null,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Task : " + doc.get('name'),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20,
                                            foreground: Paint()
                                              ..style = PaintingStyle.stroke
                                              ..strokeWidth = 1
                                              ..color = Colors.red,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Description : \n" +
                                              doc.get('description'),
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.card_giftcard),
                                              Text(
                                                "Award : ",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                              Text(
                                                doc.get('score') + " xp",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  foreground: Paint()
                                                    ..style =
                                                        PaintingStyle.stroke
                                                    ..strokeWidth = 1
                                                    ..color = Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Row(
                                          //   children: [
                                          //     Icon(Icons.people_outline_sharp),
                                          //     Text(
                                          //       "Available : ",
                                          //       textAlign: TextAlign.center,
                                          //       style: TextStyle(
                                          //         fontSize: 20,
                                          //       ),
                                          //     ),
                                          //     Text(
                                          //       doc.get('max'),
                                          //       textAlign: TextAlign.center,
                                          //       style: TextStyle(
                                          //         fontSize: 20,
                                          //         foreground: Paint()
                                          //           ..style =
                                          //               PaintingStyle.stroke
                                          //           ..strokeWidth = 1
                                          //           ..color = Colors.red,
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                        ],
                                      ),
                                      if ((phones(doc.get("members")).contains(Member.phone) || phones(doc.get("done")).contains(Member.phone))==false && doc.get("state")=="new" ) 
                                      TextButton(
                                          style: TextButton.styleFrom(
                                            
                                            backgroundColor: Colors.green,


                                          ),
                                          onPressed: () async {
                                            setState(() {
                                              isloading=true;

                                            });
                                            await FirestoreService.addMissionMember(doc.get("name"), Member.phone, Member.first_name+" "+Member.last_name, "members").then((value) {
                                              setState(() {
                                                isloading=false;
                                              });
                                            });
                                          },
                                          child:isloading==false? Text("Subscribe",style: TextStyle(color: Colors.white),): CircularProgressIndicator())
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Card();
                          }
                        }).toList() +
                        [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Center(
                                child: Text(
                                  "That's All ???? !",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                          Card(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height / 10,
                            ),
                          )
                        ]),
              ],
            ),
          );
        }
      },
    );
  }

  String entryYear = DateTime.now().year.toString();
  late AwesomeDialog ad;
  bool popUp(context, String id,List<dynamic> members,List<dynamic> done,String score) {
    List<String> output = [];
members.forEach((element) {
    if(!done.contains(element)){
    output.add(element);
}
});


    entryYear = "";

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
                          "Subscribed Members",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.blue,
                          ),
                        ),
                        Divider(),
                        Column(
                          children: names(output).asMap().entries.map((entry) {
                            String doc=entry.value;
                            int ind=entry.key;
                              return 
                                 Card(
                              borderOnForeground: true,
                              elevation: 50,
                              margin: EdgeInsets.all(2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                         
                                        });
                                       
                                      },
                                      child: Center(
                                          child: Text(
                                       
                                       doc.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                          fontSize: 15,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                      ))),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () async{
                                            
                                            ad..dismiss();

                                            await FirestoreService.addMissionMember(id,output[ind].split('~')[0],doc, "done").then((value) {

                                            });
                                           await  FirestoreService.setClaim(output[ind].split('~')[0],double.parse(score).toInt());
                                            
                                          },
                                          icon: Icon(Icons.done_outline_rounded,color: Colors.green,)),
                                    
                                    ],
                                  ),
                                  
                                ],
                              ),
                            )
                      ;
                          }).toList()
                        )
                      ,
                      Text(
                          "Succeeded Members",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.blue,
                          ),
                        ),
                        Divider(),
                        Column(
                          children: names(done).map((doc) {
                              return 
                                 Card(
                              borderOnForeground: true,
                              elevation: 50,
                              margin: EdgeInsets.all(2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                         
                                        });
                                       
                                      },
                                      child: Center(
                                          child: Text(
                                       doc.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                          fontSize: 15,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                      ))),
                             
                                  
                                ],
                              ),
                            )
                      ;
                          }).toList()
                        )
                     
                      ]),
                ),
              ),
            ],
          ),
        ),
        btnOk: Wrap(
          alignment: WrapAlignment.center,
          children: [
            TextButton(
              child: Text("New"),
              onPressed: () async {
                FirestoreService.changeMissionState(id, "new");

                ad..dismiss();
              },
            ),
            TextButton(
              child: Text("Old"),
              onPressed: () async {
                FirestoreService.changeMissionState(id, "old");

                ad..dismiss();
              },
            ),
          ],
        ));

    ad..show();
    return true;
  }

bool isloading =false;
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
          return SafeArea(
            child: 
            widget.categ.isNotEmpty?
            missionsList(""):
            DefaultTabController(
              initialIndex: 0,
              length: 2,
              child: Column(
                children: <Widget>[
                  ButtonsTabBar(
                    radius: 12,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    borderWidth: 2,
                    borderColor: Colors.transparent,
                    center: true,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFF0D47A1),
                          Color(0xFF1976D2),
                          Color(0xFF42A5F5),
                        ],
                      ),
                    ),
                    unselectedLabelStyle: TextStyle(color: Colors.black),
                    labelStyle: TextStyle(color: Colors.white),
                    tabs: [
                      Tab(
                        text: "New",
                      ),
                      Tab(
                        text: "Old",
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: <Widget>[
                        missionsList("new"),
                        missionsList("old"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
