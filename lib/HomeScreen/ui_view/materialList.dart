import 'dart:math';
import 'package:Aerobotix/model/member.dart';
import 'package:Aerobotix/services/firebase_service.dart';
import 'package:Aerobotix/ui/text_style.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:gender_picker/source/enums.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:Aerobotix/utils/helpers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class MaterialList extends StatefulWidget {
  MaterialList({
    Key? key,
  }) : super(key: key);

  @override
  State<MaterialList> createState() => _MaterialListState();
}

class _MaterialListState extends State<MaterialList> {
  String matImDesc = "";
  void getIm() async {
    try {
      matImDesc = await FirestoreService.getMaterialImage("materials/", photo);
      setState(() {});
    } catch (e) {}
  }

  String note = "";

  final db = FirebaseFirestore.instance;
  int detail = 0;
  String description = "";
  String name = "";
  String photo = "";
  String search = "";
  double x = 0;
  double y = 0;

  Map<String, int> quantiteMap = {};

  int totalMat() {
    int sum = 0;
    quantiteMap.forEach((key, value) {
      sum += value;
    });

    return sum;
  }

  List<Widget> getListSelected() {
    List<Widget> l = [];
    quantiteMap.forEach((key, value) {
      if (value > 0) {
        l.add(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(key.toString()),
                Text("X" + value.toString()),
               
                
              ],
            ));
            l.add(Divider());
      }
    });
    return l;
  }
late AwesomeDialog ad;
  bool popUp(context) {
    note = "";

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
                            "You are going to request these items \nPlease confirm your request",
                            style: TextStyle(
                              
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.blue,
                            ),
                          ),
                          Divider(),
                        ] +
                        getListSelected() +
                        
                        [
                          TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.note_alt_outlined),
                              border: OutlineInputBorder(),
                              hintText: 'Write your note if you have one',
                            ),
                            textAlign: TextAlign.center,
                            autofocus: true,
                            textAlignVertical: TextAlignVertical.center,
                            onChanged: (text) => note = text,
                            keyboardType: TextInputType.text,
                          ),
                        ],
                  ),
                ),
              ),
            ],
          ),
        ),
        btnOk: IconButton(
          iconSize: 50,
          onPressed: () async {
            Member.isNew?                                  showSnackBar("Your account must be verified !",col:Colors.red):
            
            FirestoreService.requestMaterial(quantiteMap,note);
            ad..dismiss();
          },
          icon: Icon(Icons.send,color:Colors.green),
        ),
        
        );

    
      
    ad..show();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return detail == 1
        ? ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    fontSize: 20,
                    color: Color.fromARGB(255, 0, 255, 230),
                  ),
                ),
              ),
              AvatarGlow(
                glowColor: Colors.blue,
                endRadius: MediaQuery.of(context).size.width / 2,
                duration: Duration(milliseconds: 2000),
                repeat: true,
                showTwoGlows: true,
                repeatPauseDuration: Duration(milliseconds: 100),
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: MediaQuery.of(context).size.width / 1.5,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(255, 211, 211, 211),
                            width: 5),
                        shape: BoxShape.circle,
                        image: (matImDesc.isNotEmpty && matImDesc != "wait")
                            ? DecorationImage(
                                image: NetworkImage(
                                  matImDesc,
                                ),
                                fit: BoxFit.fill)
                            : matImDesc.isEmpty
                                ? DecorationImage(
                                    image: AssetImage(
                                      "assets/images/tools.jpg",
                                    ),
                                    fit: BoxFit.fill)
                                : null,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Description 🗒️\n" + description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    letterSpacing: 1.5,
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height / 6),
                child: EasyContainer(
                    width: double.infinity,
                    onTap: () async {
                      setState(() {
                        detail = 0;
                      });
                    },
                    child: const Text(
                      'Previous 🔙',
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ],
          )
        : Stack(children: [
            StreamBuilder<QuerySnapshot>(
              stream: db.collection('materials').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView(
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
                        snapshot.data!.docs.map((DocumentSnapshot doc) {
                          if (doc
                                  .get("name")
                                  .toString()
                                  .toUpperCase()
                                  .contains(search.toUpperCase()) ||
                              search == "") {
                            return Card(
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
                                          name = doc.get("name");
                                          description = doc.get("description");
                                          photo = doc.get("photo");

                                          detail = 1;
                                        });
                                        getIm();
                                      },
                                      child: Center(
                                          child: Text(
                                        "  📌   " + doc.get("name"),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                          fontSize: 20,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                      ))),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (quantiteMap.containsKey(
                                                  doc.get("name"))) {
                                                quantiteMap[doc.get("name")] =
                                                    max(
                                                            0,
                                                            quantiteMap[doc.get(
                                                                    "name")]! -
                                                                1)
                                                        .toInt();
                                              } else {
                                                quantiteMap[doc.get("name")] =
                                                    0;
                                              }
                                            });
                                          },
                                          icon: Icon(Icons.remove)),
                                      (quantiteMap.containsKey(doc.get("name")))
                                          ? Text(quantiteMap[doc.get("name")]
                                              .toString())
                                          : Text("0"),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (quantiteMap.containsKey(
                                                  doc.get("name"))) {
                                                quantiteMap[doc.get("name")] =
                                                    (quantiteMap[
                                                            doc.get("name")]! +
                                                        1);
                                              } else {
                                                quantiteMap[doc.get("name")] =
                                                    1;
                                              }
                                            });
                                          },
                                          icon: Icon(Icons.add)),
                                    ],
                                  )
                                ],
                              ),
                            );
                          } else {
                            return Card();
                          }
                        }).toList()
                 +
                 [
                  Card(
                    child: SizedBox(
                    height: 100,
                  ),
                  )
                 ]
                 
                  );
                }
              },
            ),
            Positioned(
              top: y,
              left: x,
              child: GestureDetector(
                onPanUpdate: (tapInfo) {
                  setState(() {
                    x += tapInfo.delta.dx;
                    y += tapInfo.delta.dy;
                  });
                },
                onTap: () {
                  if(totalMat()<=0){
                    showSnackBar(
                      "Please select your at least an item",col:Colors.red
                    );
                  }else{
popUp(context);
                  }
                },
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width / 8,
                      width: MediaQuery.of(context).size.width / 8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.blue,
                      ),
                    ),
                    if (totalMat() > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            totalMat().toString(),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ]);
  }
}
