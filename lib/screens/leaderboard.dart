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

class leaderboardScreen extends StatefulWidget {
  const leaderboardScreen({Key? key, this.animationController})
      : super(key: key);

  final AnimationController? animationController;
  @override
  _leaderboardScreenState createState() => _leaderboardScreenState();
}

class _leaderboardScreenState extends State<leaderboardScreen>
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

  List<DocumentSnapshot> poduim3as = [];
  List<DocumentSnapshot> poduimWli = [];
  List<DocumentSnapshot> poduimKas = [];
  List<DocumentSnapshot> poduimJen = [];
  List<DocumentSnapshot> poduimR3a = [];

  final db = FirebaseFirestore.instance;
  Widget MembersList(categories) {
    return StreamBuilder<QuerySnapshot>(
      stream: db.collection('members').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          List<DocumentSnapshot> all = snapshot.data!.docs.toList();
          int index = 0;

          all.sort(((a, b) => double.parse(b.get("xp").toString())
              .compareTo(double.parse(a.get("xp").toString()))));
          poduim3as = [];
          poduimWli = [];
          poduimKas = [];
          poduimJen = [];
          poduimR3a = [];

          for (var element in all) {
            if(element.get("gameLevel")=="3asfour"){
              if(poduim3as.length<3){
                poduim3as.add(element);
              }
            }else if(element.get("gameLevel")=="wlidha"){
              if(poduimWli.length<3){
                poduimWli.add(element);
              }
            }
            else if(element.get("gameLevel")=="kassa7"){
              if(poduimKas.length<3){
                poduimKas.add(element);
              }
            }
            else if(element.get("gameLevel")=="r3ad"){
              if(poduimR3a.length<3){
                poduimR3a.add(element);
              }
            }
            else if(element.get("gameLevel")=="jen"){
              if(poduimJen.length<3){
                poduimJen.add(element);
              }
            }
          }

Column getPoduim(DocumentSnapshot pod,Color col , double size){
  return 
       Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: AvatarGlow(
                                      glowColor: Colors.blue,
                                      endRadius:
                                          MediaQuery.of(context).size.width / size,
                                      duration: Duration(milliseconds: 2000),
                                      repeat: true,
                                      showTwoGlows: true,
                                      repeatPauseDuration:
                                          Duration(milliseconds: 100),
                                      child: Container(
                                        // width: MediaQuery.of(context).size.width / 2,
                                        // height: MediaQuery.of(context).size.width / 2,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  col,
                                              width: 4),
                                          shape: BoxShape.circle,
                                          image: (imMap[pod.get("phone")]
                                                      .toString()
                                                      .isNotEmpty &&
                                                  imMap.containsKey(
                                                      pod.get("phone")) &&
                                                  imMap[pod.get("phone")] !=
                                                      "wait")
                                              ? DecorationImage(
                                                  image: NetworkImage(
                                                    imMap[pod.get("phone")]
                                                        .toString(),
                                                  ),
                                                  fit: BoxFit.fill)
                                              : imMap[pod.get("phone")]
                                                      .toString()
                                                      .isEmpty
                                                  ? pod.get("gender") ==
                                                          "Female"
                                                      ? DecorationImage(
                                                          image: AssetImage(
                                                            "assets/images/gadget2.jpg",
                                                          ),
                                                          fit: BoxFit.fill)
                                                      : DecorationImage(
                                                          image: AssetImage(
                                                            "assets/images/gadget4.jpg",
                                                          ),
                                                          fit: BoxFit.fill)
                                                  : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                 Icon(Icons.military_tech,size: 30,color: col,),
                                
                                ],
                              );
                        
}
          return ListView(
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
                              hintText: 'Enter a name',
                            ),

                            onChanged: (value) {
                              setState(() {
                                search = value.trim();
                              });
                            },
                            // maxLength: 20,
                            maxLines: 1,
                          ),
                        ),
                        if (categories=="3asfour" && poduim3as.length > 2)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              getPoduim(poduim3as[2], Color.fromARGB(255,205, 127, 50),11),
                              getPoduim(poduim3as[0], Color.fromARGB(255,218,165,3), 9),
                              getPoduim(poduim3as[1], Color.fromARGB(255, 192,192,192), 10),

                               ],
                          ),
                          if (categories=="wlidha" && poduimWli.length > 2)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              getPoduim(poduimWli[2], Color.fromARGB(255,205, 127, 50),11),
                              getPoduim(poduimWli[0], Color.fromARGB(255,218,165,3), 9),
                              getPoduim(poduimWli[1], Color.fromARGB(255, 192,192,192), 10),

                               ],
                          )
                          ,
                          if (categories=="kassa7" && poduimKas.length > 2)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              getPoduim(poduimKas[2], Color.fromARGB(255,205, 127, 50),11),
                              getPoduim(poduimKas[0], Color.fromARGB(255,218,165,3), 9),
                              getPoduim(poduimKas[1], Color.fromARGB(255, 192,192,192), 10),

                               ],
                          ),
                          if (categories=="r3ad" && poduimR3a.length > 2)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              getPoduim(poduimR3a[2], Color.fromARGB(255,205, 127, 50),11),
                              getPoduim(poduimR3a[0], Color.fromARGB(255,218,165,3), 9),
                              getPoduim(poduimR3a[1], Color.fromARGB(255, 192,192,192), 10),

                               ],
                          ),
                          if (categories=="jen" && poduimJen.length > 2)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              getPoduim(poduimJen[2], Color.fromARGB(255,205, 127, 50),11),
                              getPoduim(poduimJen[0], Color.fromARGB(255,218,165,3), 9),
                              getPoduim(poduimJen[1], Color.fromARGB(255, 192,192,192), 10),

                               ],
                          )
                      ] +
                      all.map((doc) {
                        String gif = "assets/HomeScreen/3asfour.gif";
                        Color colorLevel = HexColor("973747");
                        switch (doc.get("gameLevel").toString()) {
                          case "wlidha":
                            gif = "assets/HomeScreen/wlidha.gif";
                            colorLevel = HexColor("973747");
                            break;
                          case "kassa7":
                            gif = "assets/HomeScreen/kassa7.gif";
                            colorLevel = HexColor("911E0E");
                            break;
                          case "r3ad":
                            gif = "assets/HomeScreen/r3ad.gif";
                            colorLevel = HexColor("E1CB53");

                            break;
                          case "jen":
                            gif = "assets/HomeScreen/jen.gif";
                            colorLevel = HexColor("CA9FC8");

                            break;
                          case "3orsa":
                            gif = "assets/HomeScreen/3orsa.gif";
                            colorLevel = HexColor("#90F1FB");

                            break;
                          default:
                            colorLevel = HexColor("BD8484");
                            gif = "assets/HomeScreen/3asfour.gif";
                        }
                        if (imMap.containsKey(doc.get("phone")) == false) {
                          getIm(doc.get("phone"), doc.get("photo"));
                        }
                        if ((categories == "all" ||
                                categories == doc.get("gameLevel").toString() ||
                                (categories == "new" &&
                                    doc.get("new") == true)) &&
                            (search == "" ||
                                doc
                                    .get("first_name")
                                    .toString()
                                    .toUpperCase()
                                    .contains(search.toUpperCase()) ||
                                doc
                                    .get("last_name")
                                    .toString()
                                    .toUpperCase()
                                    .contains(search.toUpperCase()))) {
                          index = index + 1;
                         
                          return Card(
                            borderOnForeground: true,
                            color: Colors.white,
                            elevation: 200,
                            margin: EdgeInsets.all(8),
                            child: GestureDetector(
                              onLongPress: () {
                                if (doc.get("new") == true) {
                                  print(doc.get("new"));
                                  popUp(context, doc.get("phone"));
                                }
                              },
                              onTap: () {
                                Member.otherPhone = doc.get("phone");
                                Navigator.pushNamed(context, "/otherProfile");
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 22, 21, 119)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: search==""?Text(index.toString()): Text("#"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: AvatarGlow(
                                              glowColor: Colors.blue,
                                              endRadius: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  15,
                                              duration:
                                                  Duration(milliseconds: 2000),
                                              repeat: true,
                                              showTwoGlows: true,
                                              repeatPauseDuration:
                                                  Duration(milliseconds: 100),
                                              child: Container(
                                                // width: MediaQuery.of(context).size.width / 2,
                                                // height: MediaQuery.of(context).size.width / 2,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: doc.get(
                                                                  "gender") ==
                                                              "Female"
                                                          ? Colors.pinkAccent
                                                          : Colors.blue,
                                                      width: 2),
                                                  shape: BoxShape.circle,
                                                  image: (imMap[doc.get("phone")]
                                                              .toString()
                                                              .isNotEmpty &&
                                                          imMap.containsKey(doc
                                                              .get("phone")) &&
                                                          imMap[doc.get(
                                                                  "phone")] !=
                                                              "wait")
                                                      ? DecorationImage(
                                                          image: NetworkImage(
                                                            imMap[doc.get(
                                                                    "phone")]
                                                                .toString(),
                                                          ),
                                                          fit: BoxFit.fill)
                                                      : imMap[doc.get("phone")]
                                                              .toString()
                                                              .isEmpty
                                                          ? doc.get("gender") ==
                                                                  "Female"
                                                              ? DecorationImage(
                                                                  image:
                                                                      AssetImage(
                                                                    "assets/images/gadget2.jpg",
                                                                  ),
                                                                  fit: BoxFit
                                                                      .fill)
                                                              : DecorationImage(
                                                                  image:
                                                                      AssetImage(
                                                                    "assets/images/gadget4.jpg",
                                                                  ),
                                                                  fit: BoxFit
                                                                      .fill)
                                                          : null,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          doc.get('first_name') +
                                              " " +
                                              doc.get('last_name'),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              doc.get('xp').toString() + " XP",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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
                                "That's All 🚫 !",
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
          );
        }
      },
    );
  }

  String score = "";
  String entryYear = DateTime.now().year.toString();
  late AwesomeDialog ad;
  bool popUp(context, String id) {
    score = "";
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
                            onChanged: (text) => score = text,
                            keyboardType: TextInputType.numberWithOptions(
                                signed: false, decimal: true),
                          ),
                          Divider(),
                          TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.date_range_outlined),
                              border: OutlineInputBorder(),
                              hintText: 'Write the entry year',
                            ),
                            textAlign: TextAlign.center,
                            autofocus: true,
                            textAlignVertical: TextAlignVertical.center,
                            onChanged: (text) => entryYear = text,
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
                if (entryYear.isNotEmpty &&
                    double.tryParse(entryYear) != null &&
                    double.parse(entryYear) <= DateTime.now().year &&
                    double.parse(entryYear) >= 2000 &&
                    score.isNotEmpty &&
                    double.tryParse(score) != null &&
                    double.parse(score) <= 5000 &&
                    double.parse(score) >= 0) {
                  FirestoreService.verifyUser(id, double.parse(score).toInt(),
                      double.parse(entryYear).toInt(), "3asfour");
                } else {
                  showSnackBar("Please enter valid data", col: Colors.red);
                }

                ad..dismiss();
              },
            ),
            TextButton(
              child: Text("Wlidha"),
              onPressed: () async {
                if (entryYear.isNotEmpty &&
                    double.tryParse(entryYear) != null &&
                    double.parse(entryYear) <= DateTime.now().year &&
                    double.parse(entryYear) >= 2000 &&
                    score.isNotEmpty &&
                    double.tryParse(score) != null &&
                    double.parse(score) <= 5000 &&
                    double.parse(score) >= 0) {
                  FirestoreService.verifyUser(id, double.parse(score).toInt(),
                      double.parse(entryYear).toInt(), "wlidha");
                } else {
                  showSnackBar("Please enter valid data", col: Colors.red);
                }

                ad..dismiss();
              },
            ),
            TextButton(
              child: Text("Kassa7"),
              onPressed: () async {
                if (entryYear.isNotEmpty &&
                    double.tryParse(entryYear) != null &&
                    double.parse(entryYear) <= DateTime.now().year &&
                    double.parse(entryYear) >= 2000 &&
                    score.isNotEmpty &&
                    double.tryParse(score) != null &&
                    double.parse(score) <= 5000 &&
                    double.parse(score) >= 0) {
                  FirestoreService.verifyUser(id, double.parse(score).toInt(),
                      double.parse(entryYear).toInt(), "kassa7");
                } else {
                  showSnackBar("Please enter valid data", col: Colors.red);
                }

                ad..dismiss();
              },
            ),
            TextButton(
              child: Text("R3ad"),
              onPressed: () async {
                if (entryYear.isNotEmpty &&
                    double.tryParse(entryYear) != null &&
                    double.parse(entryYear) <= DateTime.now().year &&
                    double.parse(entryYear) >= 2000 &&
                    score.isNotEmpty &&
                    double.tryParse(score) != null &&
                    double.parse(score) <= 5000 &&
                    double.parse(score) >= 0) {
                  FirestoreService.verifyUser(id, double.parse(score).toInt(),
                      double.parse(entryYear).toInt(), "r3ad");
                } else {
                  showSnackBar("Please enter valid data", col: Colors.red);
                }

                ad..dismiss();
              },
            ),
            TextButton(
              child: Text("Jen"),
              onPressed: () async {
                if (entryYear.isNotEmpty &&
                    double.tryParse(entryYear) != null &&
                    double.parse(entryYear) <= DateTime.now().year &&
                    double.parse(entryYear) >= 2000 &&
                    score.isNotEmpty &&
                    double.tryParse(score) != null &&
                    double.parse(score) <= 5000 &&
                    double.parse(score) >= 0) {
                  FirestoreService.verifyUser(id, double.parse(score).toInt(),
                      double.parse(entryYear).toInt(), "jen");
                } else {
                  showSnackBar("Please enter valid data", col: Colors.red);
                }

                ad..dismiss();
              },
            ),
            TextButton(
              child: Text("3orsa"),
              onPressed: () async {
                if (entryYear.isNotEmpty &&
                    double.tryParse(entryYear) != null &&
                    double.parse(entryYear) <= DateTime.now().year &&
                    double.parse(entryYear) >= 2000 &&
                    score.isNotEmpty &&
                    double.tryParse(score) != null &&
                    double.parse(score) <= 5000 &&
                    double.parse(score) >= 0) {
                  FirestoreService.verifyUser(id, double.parse(score).toInt(),
                      double.parse(entryYear).toInt(), "3orsa");
                } else {
                  showSnackBar("Please enter valid data", col: Colors.red);
                }

                //  ad..dismiss();
              },
            ),
          ],
        ));

    ad..show();
    return true;
  }

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
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              getMainListViewUI(),
              getAppBarUI(),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
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
            child: DefaultTabController(
              initialIndex: 0,
              length: 6,
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
                        text: "3asfour",
                      ),
                      Tab(
                        text: "Wlidha",
                      ),
                      Tab(
                        text: "Kassa7",
                      ),
                      Tab(
                        text: "R3ad",
                      ),
                      Tab(
                        text: "Jen",
                      ),
                      Tab(
                        text: "3orsa",
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: <Widget>[
                        MembersList("3asfour"),
                        MembersList("wlidha"),
                        MembersList("kassa7"),
                        MembersList("r3ad"),
                        MembersList("jen"),
                        MembersList("3orsa"),
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
