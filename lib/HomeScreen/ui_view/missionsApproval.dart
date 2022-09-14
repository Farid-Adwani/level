import 'dart:math';
import 'package:Aerobotix/model/member.dart';
import 'package:Aerobotix/services/firebase_service.dart';
import 'package:Aerobotix/ui/text_style.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
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

class MissionsApproval extends StatefulWidget {
  MissionsApproval({
    Key? key,
  }) : super(key: key);

  @override
  State<MissionsApproval> createState() => _MissionsApprovalState();
}

class _MissionsApprovalState extends State<MissionsApproval> {
  
  String netIm = "";
  String search="";
    final db = FirebaseFirestore.instance;



  String note="";
late AwesomeDialog ad;

Column matList(list) {
    List<Widget> l = [];
    list.forEach((key, value) {
      if (value > 0) {
        l.add(
            Padding(
              padding: const EdgeInsets.only(right: 15,left:15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(key.toString()),
                  Text("X" + value.toString()),
                 
                  
                ],
              ),
            ));
            l.add(Divider());
      }
    });
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: 
        l
      
    );
  }

  bool popUp(context,String id) {
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
                            "Enter your note",
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
        btnOk: 
        Row(
          children: [
            IconButton(
          iconSize: 50,
          onPressed: () async {
            FirestoreService.changeRequestState(id, note, "requested");
            ad..dismiss();
          },
          icon: Icon(Icons.fiber_new_sharp,color:Colors.red[700]),
        ),
         IconButton(
          iconSize: 50,
          onPressed: () async {
            FirestoreService.changeRequestState(id, note, "accepted");

            ad..dismiss();
          },
          icon: Icon(Icons.done_all_outlined,color:Colors.red[500]),
        ),
         IconButton(
          iconSize: 50,
          onPressed: () async {
            FirestoreService.changeRequestState(id, note, "delievered");

            ad..dismiss();
          },
          icon: Icon(Icons.handyman_sharp,color:Colors.red[300]),
        ),
         IconButton(
          iconSize: 50,
          onPressed: () async {
            FirestoreService.changeRequestState(id, note, "restored");

            ad..dismiss();
          },
          icon: Icon(Icons.restore,color:Colors.red[100]),
        ),


          ],
        ) 
        
        );

    
      
    ad..show();
    return true;
  }

 Widget allWidgets(state) {
   return 
            StreamBuilder<QuerySnapshot>(
              stream: db.collection('materialRequest').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                 
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                   int index=0;
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
                        snapshot.data!.docs.map((doc) {

                          if (state=="all" || (doc
                                  .get("state")
                                  .toString() == state && (doc
                                  .get("member_phone")
                                  .toString()
                                  .toUpperCase()
                                  .contains(search.toUpperCase()) || doc
                                  .get("full_name")
                                  .toString()
                                  .toUpperCase()
                                  .contains(search.toUpperCase()) ||
                              search == ""))) {
                                index=index+1;
                            return Card(

                              color: index.isEven? Colors.pink:Colors.blueAccent,
                              borderOnForeground: true,
                              elevation: 200,
                              margin: EdgeInsets.all(5),
                              
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(doc.get('full_name'),
                                    style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                    fontSize: 20,
                                    color: Colors.black,
                                      ),
                                    ),
                              
                                    Text(
                                      textAlign: TextAlign.center,
                                      "  📞   " + doc.get("member_phone"),
                                      style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                    fontSize: 20,
                                    
                                    color: Color.fromARGB(
                                        255, 255, 255, 255),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                          Member.otherPhone=doc.get("member_phone");
                                          Navigator.pushNamed(context, "/otherProfile");
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            textAlign: TextAlign.center,
                                            "Visit Profile ➡️",
                                            style: TextStyle(
                                              
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                          fontSize: 20,
                                          
                                          color: Color.fromARGB(
                                              255, 0, 0, 255),
                                            ),
                                          ),
                                          IconButton(onPressed: (){
                                  popUp(context,doc.id);
                                }, icon: Icon(Icons.settings))
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "State :  "+doc.get("state"),
                                    ),
                                    Text(
                                      "Request Date : "+doc.get("requestDate").toDate().toString()
                                    ),
                                    if(doc.get("acceptDate")!=null&&( doc.get("state")=="accepted" || doc.get("state")=="delievered" || doc.get("state")=="restored")) 
                                    Text(
                                      "Accept Date : "+doc.get("acceptDate").toDate().toString()
                                    ),
                                    if(doc.get("takeDate")!=null&&(  doc.get("state")=="delievered" || doc.get("state")=="restored")) 
                                    
                                    Text(
                                      "Deliever Date : "+doc.get("takeDate").toDate().toString()
                                    ),
                                    if(doc.get("backDate")!=null&&( doc.get("state")=="restored")) 
                                    
                                    Text(
                                      "Restore Date : "+doc.get("backDate").toDate().toString()
                                    ),
                                     Text("Requested items : ")
                                      
                                            ,
                                           matList(doc.get("list")),
                                             Text("Note 🗒️: "),
                                               Text(doc.get('note')),
                                               SizedBox(
                                                height: 8,
                                               )
                              
                                          
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Card();
                          }
                        }).toList()+ 
                        [Card(child:
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Center(
                            child: Text(
                                              "That's All 🚫 !",
                                              style: TextStyle(
                                                fontSize: 20
                                              ),
                                             ),
                          ),
                        ),)]
                  );
                }
              },
            );
           
          
}
  @override
  Widget build(BuildContext context) {
    return 
    DefaultTabController(
      initialIndex: 0,

  length: 5,
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

                    icon: Icon(Icons.all_inbox_outlined),
                    text: "All",
                  ),
                  Tab(
                    icon: Icon(Icons.fiber_new_sharp),
                    text: "Requested",
                  ),
                  Tab(
                    icon: Icon(Icons.done_all_outlined),
                    text: "Accepted",
                  ),
                  Tab(
                    icon: Icon(Icons.handyman_sharp),
                    text: "Delievered",
                  ),
                  Tab(
                    icon: Icon(Icons.restore),
                    text: "Restored",
                  ),
                  
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                     allWidgets("all"),
                  
                      allWidgets("requested"),
                    
                   allWidgets("accepted"),
                    allWidgets("delievered"),
                   allWidgets("restored"),
                 
                  ],
                ),
              ),
    ],
  ),
);
    // return 
  
    //         StreamBuilder<QuerySnapshot>(
    //           stream: db.collection('materials').snapshots(),
    //           builder: (context, snapshot) {
    //             if (!snapshot.hasData) {
    //               return Center(
    //                 child: CircularProgressIndicator(),
    //               );
    //             } else {
    //               return ListView(
    //                 children: [
    //                       Card(
    //                         margin: EdgeInsets.all(20),
    //                         child: TextFormField(
    //                           initialValue: search,
    //                           decoration: InputDecoration(
    //                             prefixIcon: Icon(Icons.search),
    //                             border: OutlineInputBorder(),
    //                             hintText: 'Enter name of the component',
    //                           ),

    //                           onChanged: (value) {
    //                             setState(() {
    //                               search = value.trim();
    //                             });
    //                           },
    //                           // maxLength: 20,
    //                           maxLines: 1,
    //                         ),
    //                       )
    //                     ] +
    //                     snapshot.data!.docs.map((doc) {
    //                       if (doc
    //                               .get("name")
    //                               .toString()
    //                               .toUpperCase()
    //                               .contains(search.toUpperCase()) ||
    //                           search == "") {
    //                         return Card(
    //                           borderOnForeground: true,
    //                           elevation: 50,
    //                           margin: EdgeInsets.all(2),
    //                           child: Row(
    //                             mainAxisAlignment:
    //                                 MainAxisAlignment.spaceBetween,
    //                             children: [
    //                               GestureDetector(
    //                                   onTap: () async {
    //                                     setState(() {
    //                                       name = doc.get("name");
    //                                       description = doc.get("description");
    //                                       photo = doc.get("photo");

    //                                       detail = 1;
    //                                     });
    //                                     getIm();
    //                                   },
    //                                   child: Center(
    //                                       child: Text(
    //                                     "  📌   " + doc.get("name"),
    //                                     style: TextStyle(
    //                                       fontWeight: FontWeight.bold,
    //                                       letterSpacing: 1.2,
    //                                       fontSize: 20,
    //                                       color: Color.fromARGB(
    //                                           255, 255, 255, 255),
    //                                     ),
    //                                   ))),
    //                               Row(
    //                                 children: [
    //                                   IconButton(
    //                                       onPressed: () {
                                         
    //                                       },
    //                                       icon: Icon(Icons.remove)),
    //                                   (quantiteMap.containsKey(doc.get("name")))
    //                                       ? Text(quantiteMap[doc.get("name")]
    //                                           .toString())
    //                                       : Text("0"),
    //                                   IconButton(
    //                                       onPressed: () {
    //                                         setState(() {
    //                                           if (quantiteMap.containsKey(
    //                                               doc.get("name"))) {
    //                                             quantiteMap[doc.get("name")] =
    //                                                 (quantiteMap[
    //                                                         doc.get("name")]! +
    //                                                     1);
    //                                           } else {
    //                                             quantiteMap[doc.get("name")] =
    //                                                 1;
    //                                           }
    //                                         });
    //                                       },
    //                                       icon: Icon(Icons.add)),
    //                                 ],
    //                               )
    //                             ],
    //                           ),
    //                         );
    //                       } else {
    //                         return Card();
    //                       }
    //                     }).toList(),
    //               );
    //             }
    //           },
    //         ),
           
    //       ;
  }
}
