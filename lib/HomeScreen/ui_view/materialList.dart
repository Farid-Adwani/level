import 'package:Aerobotix/HomeScreen/Aerobotix_app_theme.dart';
import 'package:Aerobotix/model/member.dart';
import 'package:Aerobotix/services/firebase_service.dart';
import 'package:avatar_glow/avatar_glow.dart';
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
  String matIm = "";
  // void getIm() async {
  //   try {
  //     matIm =
  //         await FirestoreService.getMaterialImage("materials/",materialNameRef);
  //     setState(() {});
  //   } catch (e) {}
  // }

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: db.collection('materials').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return Card(
                child: 
                  
                  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Center(child: Text(doc.get("name"))),
                      Row(
                        children: [
                          IconButton(onPressed: 
                          (){

                          }, icon: Icon(Icons.remove)),
                          Text("0"),
                          IconButton(onPressed: 
                          (){

                          }, icon: Icon(Icons.add)),
                        ],
                      )
                    ],
                  ),
                
              );
            }).toList(),
          );
      },
    );
  }
}
