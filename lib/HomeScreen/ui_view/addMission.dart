import 'package:Aerobotix/HomeScreen/Aerobotix_app_theme.dart';
import 'package:Aerobotix/model/member.dart';
import 'package:Aerobotix/services/firebase_service.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:gender_picker/source/enums.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:Aerobotix/utils/helpers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class AddMission extends StatefulWidget {


  AddMission({Key? key,})
      : super(key: key);

  @override
  State<AddMission> createState() => _AddMissionState();
}

class _AddMissionState extends State<AddMission> {
  String matIm = "";
  void getIm() async {
    try {
      matIm =
          await FirestoreService.getMaterialImage("missions/",missionNameRef);
      setState(() {});
    } catch (e) {}
  }

  bool verif = false;
  @override
  void initState() {
    super.initState();
  }

  File? _photo;
  final ImagePicker _picker = ImagePicker();
  bool uploading = false;
  Future uploadFile() async {
    if (_photo == null) return;
    setState(() {
      uploading = true;
    });
    final fileName = basename(_photo!.path);
    final destination = 'missions/';




    try {
      String name = DateTime.now().toString() + fileName;
      missionNameRef = name;
      final ref = FirebaseStorage.instance.ref(destination).child(name);

      await ref.putFile(_photo!).timeout(Duration(seconds: 7));
      await FirestoreService.addMissionPhoto(name,missionName)
          .timeout(Duration(seconds: 7))
          .then((value) {
        showSnackBar("Your photo is updated successfully !");
        getIm();
      });
    } on TimeoutException {
      showSnackBar("Please check your internet connection and retry !",
          col: Colors.red);
      setState(() {
        uploading = false;
        _photo = null;
      });
    } catch (e) {
      showSnackBar("Please check your internet connection and retry !",
          col: Colors.red);
      print(e);
      setState(() {
        uploading = false;
        _photo = null;
      });
    }
    setState(() {
      uploading = false;
    });
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);

        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  String missionName = "";
  String missionDescription = "";
  String missionNameRef="";
  String maxSub="1000";
  String score="0";

  int step = 1;

  @override
  Widget build(BuildContext context) {
    
        return
                 Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 0, bottom: 0),
                  child: ListView(
                    
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: step == 1
                              ? Text(
                                  'Add a new Mission',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                    fontSize: 20,
                                    color: AerobotixAppTheme.darkerText,
                                  ),
                                )
                              : Text(
                                  'Insert the image',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                    fontSize: 20,
                                    color: AerobotixAppTheme.darkerText,
                                  ),
                                )),
                      if (step == 1)
                        TextFormField(
                          initialValue: missionName,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter the name of the Mission',
                            prefixIcon: Icon(Icons.add_shopping_cart_rounded),
                          ),
                          onFieldSubmitted: (value) {
                            missionName = value.trim();
                          },
                          onChanged: (value) {
                            missionName = value.trim();
                          },
                          maxLength: 20,
                        ),
                      if (step == 1)
                        TextFormField(
                          initialValue: missionDescription,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter the description of the Mission',
                            // prefixIcon: Icon(Icons.description_outlined,),
                          ),
                          onFieldSubmitted: (value) {
                            missionDescription = value.trim();
                          },
                          onChanged: (value) {
                            missionDescription = value.trim();
                          },
                          maxLength: 250,
                          maxLines: 10,
                        ),
                         if (step == 1)
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text("Score"),
                         ),
                         if (step == 1)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            initialValue: score.toString(),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Mission Score',
                            ),
                            onFieldSubmitted: (value) {
                              score =value.trim();
                            },
                            onChanged: (value) {
                                 score = value.trim();
                            },
                           
                          ),
                        ),
                        //  if (step == 1)
                        //  Padding(
                        //    padding: const EdgeInsets.all(8.0),
                        //    child: Text("Max"),
                        //  ),
                        //  if (step == 1)
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: TextFormField(
                        //     style: TextStyle(
                              
                        //     ),
                        //     keyboardType: TextInputType.number,
                        //     textAlign: TextAlign.center,
                        //     initialValue: maxSub.toString(),
                        //     decoration: InputDecoration(
                            
                        //       border: OutlineInputBorder(),
                        //       hintText: 'Max',
                        //     ),
                        //     onFieldSubmitted: (value) {
                        //       maxSub = value.trim();
                        //     },
                        //     onChanged: (value) {
                        //          maxSub = value.trim();
                        //     },
                           
                        //   ),
                        // ),

                        
                      if (step == 2)
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
                                  image: (matIm.isNotEmpty && matIm != "wait")
                                      ? DecorationImage(
                                          image: NetworkImage(
                                            matIm,
                                          ),
                                          fit: BoxFit.fill)
                                      : matIm.isEmpty
                                          ? DecorationImage(
                                              image: AssetImage(
                                                "assets/images/mission.png",
                                              ),
                                              fit: BoxFit.fill)
                                          : null,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 6,
                                  height: MediaQuery.of(context).size.width / 6,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 211, 211, 211),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                      onPressed: () {
                                        _showPicker(context);
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Color.fromARGB(255, 44, 19, 187),
                                      )),
                                ),
                              )
                            ],
                          ),
                        ),
                      EasyContainer(
                          width: double.infinity,
                          onTap: () async {
                           
                            // step
                            if (step == 1) {
                               setState(() {
                              verif=true;
                            });
                              if (missionName.isEmpty) {
                                showSnackBar(
                                    'Please enter the name of the Mission',
                                    col: Colors.redAccent[700]);
                                    setState(() {
                              verif=false;
                            });
                              } else {
                                

                              bool result= await FirestoreService.addMission(missionName,missionDescription,score,maxSub).then((value) {

                                if(value==true){
                                  setState(() {
                                    
                                  step = 2;
                                });
                                }
                             setState(() {
                              verif=false;
                            });
                                return value;
                              
                               });
                                
                              }
                              
                            } else {
                              setState(() { 
                                step=1;
                              });
                            }
                          },
                          child:verif==false? step==1?const Text(
                            'Continue',
                            style: TextStyle(fontSize: 18),
                          ):const Text(
                            'Finish ☑️',
                            style: TextStyle(fontSize: 18),
                          ):
                          CircularProgressIndicator()
                          
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height/10,
                          )
                    ],
                  ),
                );
     
    
  }
}
