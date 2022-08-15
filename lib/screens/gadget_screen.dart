import 'dart:math';
import 'package:animated_button/animated_button.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:levels/screens/authentication_screen.dart';
import 'package:levels/screens/male_screen.dart';
import 'package:levels/screens/multiple_gadgets_screen.dart';
import 'package:levels/screens/people_screen.dart';
import 'package:levels/screens/utils/helpers.dart';
import 'package:levels/screens/utils/route_generator.dart';
import 'package:levels/services/firebase_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:levels/ui/text_style.dart';

class HomeScreen extends StatefulWidget {
  static const id = 'HomeScreen';

  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  late List<MultiSelectItem<String>> selectionTab;
  CarouselController buttonCarouselController = CarouselController();
  void getGadgets() async {
    CollectionReference qr = FirebaseFirestore.instance
        .collection("users")
        .doc(FirestoreService.userId)
        .collection("gadgets");
    QuerySnapshot gadgets = await qr.get();
    List<String> gad = [];
    for (var item in gadgets.docs) {
      gad.add(item.id);
    }
    FirestoreService.gadgets = gad;
    print(FirestoreService.gadgets);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  List<String> gadgets = [];
  @override
  Widget build(BuildContext context) {
    Function onTapFunction = () {
      Navigator.pushNamed(context, "/people");
    };
    Function onTapFunctionF = () {
      Navigator.pushNamed(context, "/female");
    };
    Function onTapFunctionM = () {
      Navigator.pushNamed(context, "/male");
    };
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: const Color.fromARGB(255, 34, 22, 129),
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.navigate_before,
                  color: Colors.white,
                ),
                onPressed: () {
                  buttonCarouselController.previousPage();
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.navigate_next,
                  color: Colors.white,
                ),
                onPressed: () {
                  buttonCarouselController.nextPage();
                },
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 87, 73, 196),
          foregroundColor: Colors.white,
          onPressed: () async {
            await FirebasePhoneAuthHandler.signOut(context);
            showSnackBar('Logged out successfully!');
            Navigator.pushNamedAndRemoveUntil(
              context,
              AuthenticationScreen.id,
              (route) => false,
            );
          },
          child: const Icon(Icons.logout_outlined),
        ),
        body: Center(
          child: Container(
            color: const Color(0xFF736AB7),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirestoreService.userId)
                  .collection("gadgets")
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  var items = snapshot.data!.docs.toList();
                  print(items.toString());
                  List<Widget> gadWidgets = [];
                  int i = 0;
                  for (var item in items) {
                    i++;
                    gadWidgets.add(
                      GestureDetector(
                        onTap: () {
                          FirestoreService.gadget = item.id.toString();
                          RouteGenerator.generateRoute(
                              RouteSettings(name: MaleScreen.id));
                          Navigator.pushNamed(
                            context,
                            PeopleScreen.id,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.deepPurpleAccent,
                          ),
                          child: Column(
                            children: [
                              Flexible(
                                  fit: FlexFit.tight,
                                  flex: 90,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(topLeft:Radius.circular(20),topRight:Radius.circular(20)),
                                    child: Image.asset(
                                      "assets/images/gadget" +
                                          ((i % 4) + 1).toString() +
                                          ".jpg",
                                      fit: BoxFit.fill,
                                    ),
                                  )),
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 10,
                                child: Center(
                                  child: Text(
                                    item.id.toUpperCase(),
                                    style: Style.headerTextStyle,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  selectionTab = items
                      .map((it) => MultiSelectItem<String>(it.id, it.id))
                      .toList();
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: CarouselSlider(
                          items: gadWidgets,
                          carouselController: buttonCarouselController,
                          options: CarouselOptions(
                            autoPlay: true,
                            enlargeCenterPage: true,
                            viewportFraction: 0.5,
                            aspectRatio: 1.0,
                            initialPage: 1,
                          ),
                        ),
                      ),
                      AnimatedButton(
                        child: Text(
                          'Multiple Gadgets',
                          style: Style.headerTextStyle,
                        ),
                        onPressed: () {
                          setState(() {});
                          showMultiSelect(context);
                        },
                      ),
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ));
  }

  void showMultiSelect(BuildContext context) async {
    await showModalBottomSheet(
      isScrollControlled: true, // required for min/max child size
      backgroundColor: Colors.purple[400],
      elevation: 40,

      context: context,
      builder: (ctx) {
        return MultiSelectBottomSheet(
          title: Text("Select Your Gadgets"),
          items: selectionTab,
          initialValue: [],
          onConfirm: (values) {
            print("all");
            print(values.toList());
            FirestoreService.selectedGadgets = [];
            values.toList().forEach((element) {
              print("inn");
              if (element.runtimeType == String) {
                FirestoreService.selectedGadgets.add(element.toString());
              }
            });
            print("fr");
            print(FirestoreService.selectedGadgets);
            Navigator.pushNamed(
              context,
              MultipleGadgets.id,
            );
          },
          maxChildSize: 0.8,
        );
      },
    );
  }
}
